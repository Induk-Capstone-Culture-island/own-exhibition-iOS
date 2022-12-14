//
//  ImageLoader.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/10.
//

import UIKit

final class ImageLoader {
    
    static let shared: ImageLoader = .init()
    
    private let imageCache: NSCache<NSURLRequest, UIImage>
    
    private init() {
        self.imageCache = .init()
        self.imageCache.name = "SharedImageCache"
    }
    
    func patch(_ url: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL.init(string: url) else {
            return completion(.failure(NetworkError.invalidURL))
        }
        
        patch(url, completion)
    }
    
    func patch(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        let urlRequest: URLRequest = .init(url: url)
        patch(urlRequest, completion)
    }
    
    func patch(_ urlRequest: URLRequest, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        let nsURLRequest = urlRequest as NSURLRequest
        if let image = imageCache.object(forKey: nsURLRequest) {
            return completion(.success(image))
        }
        
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
            
            self.imageCache.setObject(image, forKey: nsURLRequest)
            return completion(.success(image))
        }
        .resume()
    }
}

extension ImageLoader {
    
    enum ImageLoaderError: Error {
        case notImageData
    }
}
