//
//  MyPageRepository.swift
//  own-exhibition
//
//  Created by 소프트웨어컴퓨터 on 2022/11/13.
//

import RxSwift

protocol UserRepositoryProtocol {
    func getUserInfo(by token: Token) -> Observable<UserInfo>
    func getToken(with requestDTO: LoginRequestDTO) -> Observable<Token>
    func verifyToken(_ token: Token) -> Observable<Bool>
    func createUser(with requestDTO: SignUpRequestDTO) -> Observable<Token>
}

final class UserRepository: UserRepositoryProtocol {
    
    func getUserInfo(by token: Token) -> Observable<UserInfo> {
        let networkService: NetworkService<UserInfoResponseDTO> = .init()
        return networkService.getItem(path: "userinfo", token: token)
            .map { $0.user.toEntity() }
    }
    
    func getToken(with requestDTO: LoginRequestDTO) -> Observable<Token> {
        let networkService: NetworkService<LoginResponseDTO> = .init()
        return networkService.postItem(path: "login", body: requestDTO)
            .map { responseDTO in
                return .init(id: requestDTO.email, value: responseDTO.token)
            }
    }
    
    func verifyToken(_ token: Token) -> Observable<Bool> {
        return getUserInfo(by: token)
            .map { _ in true }
    }
    
    func createUser(with requestDTO: SignUpRequestDTO) -> Observable<Token> {
        let networkService: NetworkService<SignUpResponseDTO> = .init()
        return networkService.postItem(path: "register", body: requestDTO)
            .map { responseDTO in
                return .init(id: responseDTO.user.email, value: responseDTO.token)
            }
    }
}
