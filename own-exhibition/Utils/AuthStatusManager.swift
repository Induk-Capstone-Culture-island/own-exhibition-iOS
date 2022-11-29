//
//  AuthStatusManager.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/29.
//

import RxSwift

final class AuthStatusManager {
    
    /// 앱의 로그인 상태를 관리하는 싱글톤 객체 입니다.
    static let shared: AuthStatusManager = .init()
    
    private let userRepository: UserRepository
    private let keychainRepository: KeychainRepository
    private let userDefaultsRepository: UserDefaultsRepository
    
    private init() {
        self.userRepository = .init()
        self.keychainRepository = .init()
        self.userDefaultsRepository = .init()
    }
    
    /// 현재 사용자가 앱에 로그인 되어있음을 나타내는 Boolean 값입니다.
    ///
    /// UserDefaults 에 사용자 아이디가 저장되어 있고, Keychain 에 유효한 Token 이 저장되어 있는 상태를 의미합니다.
    var isLoggedIn: Observable<Bool> {
        guard let id = userDefaultsRepository.getCurrentUserId(),
              let token = keychainRepository.get(id: id)
        else {
            return .of(false)
        }
        
        return userRepository.verifyToken(token)
    }
    
    /// 사용자가 로그인했을 때 호출하는 함수입니다.
    func login(with token: Token) {
        userDefaultsRepository.saveCurrentUserId(token.id)
        keychainRepository.save(token: token)
    }
    
    /// 사용자가 로그아웃했을 때 호출하는 함수입니다.
    func logout() {
        if let id = userDefaultsRepository.getCurrentUserId() {
            keychainRepository.delete(id: id)
        }
        userDefaultsRepository.removeCurrentUserId()
    }
}
