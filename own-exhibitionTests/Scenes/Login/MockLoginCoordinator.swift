//
//  MockLoginCoordinator.swift
//  own-exhibitionTests
//
//  Created by Jaewon Yun on 2022/11/30.
//

import Foundation
@testable import own_exhibition

final class MockLoginCoordinator: LoginCoordinatorProtocol {
    
    var toTargetViewControllerCalled: Bool = false
    var toSignUpCalled: Bool = false
    
    func start() {
    }
    
    func toTargetViewController() {
        toTargetViewControllerCalled = true
    }
    
    func toSignUp() {
        toSignUpCalled = true
    }
}
