//
//  NetworkService.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/18.
//

import RxSwift
import RxCocoa

/// 기본적으로 모든 Request/Response body 가 JSON 타입이라고 가정하고 작동하는 Network 모듈입니다.
///
/// Request/Response body 가 JSON 이 아닐 시, Error 를 방출합니다.
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
    
    func getItem(path: String, token: Token) -> Observable<T> {
        guard var urlRequest: URLRequest = makeURLRequest(byPath: path) else {
            return .error(NetworkError.invalidURL)
        }
        
        urlRequest.setValue("Bearer \(token.value)", forHTTPHeaderField: "Authorization")
        
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
    
    func postItem(path: String, body: Encodable) -> Observable<T> {
        guard var urlRequest: URLRequest = makeURLRequest(byPath: path) else {
            return .error(NetworkError.invalidURL)
        }
        
        urlRequest.httpMethod = "POST"
        
        do {
            let jsonData = try JSONEncoder().encode(body)
            urlRequest.httpBody = jsonData
        } catch {
            fatalError("\(body) : 인코딩 실패")
        }
        
        return URLSession.shared.rx.data(request: urlRequest)
            .map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
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
        
        var urlRequest: URLRequest = .init(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: 10.0
        )
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
}
