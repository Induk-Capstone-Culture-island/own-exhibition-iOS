//
//  ImageLoader.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/10.
//

import UIKit

enum NetworkError: Error {
    case invalidURL
    case invalidStatusCode
    case nonExistentData
}

enum ImageLoaderError: Error {
    case notImageData
}

struct ImageLoader {
    
    static func patch(_ url: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL.init(string: url) else {
            return completion(.failure(NetworkError.invalidURL))
        }
        
        patch(url, completion)
    }
    
    static func patch(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        let urlRequest: URLRequest = .init(url: url)
        patch(urlRequest, completion)
    }
    
    static func patch(_ urlRequest: URLRequest, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let response = urlResponse as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode)
            else {
                return completion(.failure(NetworkError.invalidStatusCode))
            }
            
            guard let data = data else {
                return completion(.failure(NetworkError.nonExistentData))
            }
            
            guard let image = UIImage.init(data: data) else {
                return completion(.failure(ImageLoaderError.notImageData))
            }
            
            return completion(.success(image))
        }
        .resume()
    }
}
