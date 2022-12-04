//
//  LoginViewModelTests.swift
//  own-exhibitionTests
//
//  Created by Jaewon Yun on 2022/11/30.
//

import XCTest
import RxSwift
@testable import own_exhibition

final class LoginViewModelTests: XCTestCase {
    
    var userRepository: MockUserRepository!
    var coordinator: MockLoginCoordinator!
    
    var viewModel: LoginViewModel!
    
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        
        userRepository = .init()
        coordinator = .init()
        
        viewModel = .init(coordinator: coordinator, userRepository: userRepository)
        
        disposeBag = .init()
        
        LoginStatusManager.shared.logout()
    }
    
    func test_올바른형식의_아이디_비밀번호_입력_후_로그인() {
        // Arrange
        var isLoggedIn: Bool = false
        
        let input = LoginViewModel.Input.init(
            viewWillAppear: .of(()),
            login: .of(()),
            id: .of("test1234@naver.com"),
            password: .of("test1234"),
            signUp: .never()
        )
        let output = viewModel.transform(input: input)
        
        // Act
        output.isLoggedIn
            .drive(onNext: {
                isLoggedIn = $0
            })
            .disposed(by: disposeBag)
        
        // Assert
        XCTAssertTrue(isLoggedIn)
        XCTAssertTrue(LoginStatusManager.shared.isLoggedIn)
        XCTAssertTrue(coordinator.toTargetViewControllerCalled)
    }
    
    func test_회원가입_버튼_터치_시_화면이동() {
        // Arrange
        let input = LoginViewModel.Input.init(
            viewWillAppear: .of(()),
            login: .never(),
            id: .never(),
            password: .never(),
            signUp: .of(())
        )
        let output = viewModel.transform(input: input)
        
        // Act
        output.signUp
            .drive()
            .disposed(by: disposeBag)
        
        // Assert
        XCTAssertTrue(coordinator.toSignUpCalled)
    }
}
