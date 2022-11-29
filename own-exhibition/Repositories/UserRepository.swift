//
//  MyPageRepository.swift
//  own-exhibition
//
//  Created by 소프트웨어컴퓨터 on 2022/11/13.
//

import RxSwift

final class UserRepository {
    
    func getPeronalInfo() -> Observable<PersonalInfo> {
        return .of(
            .makemock()
        )
    }
    
    func login(with requestDTO: LoginRequestDTO) -> Observable<Bool> {
        let networkService: NetworkService<LoginResponseDTO> = .init()
        return networkService.postItem(path: "login", body: requestDTO)
            .do(onNext: { response in
                // TODO: Token 저장
                _ = response.token
            })
            .map { $0.token.isEmpty ? false : true }
    }
}
