//
//  NetworkService.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/18.
//

import RxSwift
import RxCocoa

/// 기본적으로 모든 Response body 가 JSON 타입으로 온다고 가정하고 작동하는 Network 모듈입니다.
///
/// Response body 가 JSON 이 아닐 시, Error 를 방출합니다.
final class NetworkService<T: Decodable> {
    
    private let endPoint: String = "http://13.125.82.62/api"
    
    func getItem(byPath path: String) -> Observable<T> {
        guard let urlRequest: URLRequest = makeURLRequest(byPath: path) else {
            return .error(NetworkError.invalidURL)
        }
        
        return URLSession.shared.rx.data(request: urlRequest)
            .map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
    
    func getItems(byPath path: String) -> Observable<[T]> {
        guard let urlRequest: URLRequest = makeURLRequest(byPath: path) else {
            return .error(NetworkError.invalidURL)
        }
        
        return URLSession.shared.rx.data(request: urlRequest)
            .map { data -> [T] in
                return try JSONDecoder().decode([T].self, from: data)
            }
    }
}

// MARK: - Private Functions

private extension NetworkService {
    
    func makeURLRequest(byPath path: String) -> URLRequest? {
        let absolutePath: String = "\(endPoint)/\(path)"
        guard let url: URL = .init(string: absolutePath) else {
            return nil
        }
        
        return .init(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: 10.0
        )
    }
}
