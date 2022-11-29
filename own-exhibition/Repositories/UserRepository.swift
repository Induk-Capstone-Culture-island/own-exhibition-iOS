//
//  MyPageRepository.swift
//  own-exhibition
//
//  Created by 소프트웨어컴퓨터 on 2022/11/13.
//

import RxSwift

final class UserRepository {
    
    func getUserInfo(by token: Token) -> Observable<UserInfo> {
        let networkService: NetworkService<UserInfoResponseDTO> = .init()
        return networkService.getItem(path: "userinfo", token: token)
            .map { $0.user.toEntity() }
    }
    
    func login(with requestDTO: LoginRequestDTO) -> Observable<Token> {
        let networkService: NetworkService<LoginResponseDTO> = .init()
        return networkService.postItem(path: "login", body: requestDTO)
            .map { responseDTO in
                return .init(id: requestDTO.email, value: responseDTO.token)
            }
    }
}
