//
//  MockUserRepository.swift
//  own-exhibitionTests
//
//  Created by Jaewon Yun on 2022/11/30.
//

import RxSwift
@testable import own_exhibition

final class MockUserRepository: UserRepositoryProtocol {
    
    func getUserInfo(by token: own_exhibition.Token) -> RxSwift.Observable<own_exhibition.UserInfo> {
        return .of(.makeMock())
    }
    
    func getToken(with requestDTO: own_exhibition.LoginRequestDTO) -> RxSwift.Observable<own_exhibition.Token> {
        return .of(.makeMock())
    }
    
    func verifyToken(_ token: own_exhibition.Token) -> RxSwift.Observable<Bool> {
        return .of(true)
    }
    
    func createUser(with requestDTO: own_exhibition.SignUpRequestDTO) -> RxSwift.Observable<own_exhibition.Token> {
        return .of(.makeMock())
    }
}
