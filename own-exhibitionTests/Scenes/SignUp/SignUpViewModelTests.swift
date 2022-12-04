//
//  SignUpViewModelTests.swift
//  own-exhibitionTests
//
//  Created by Jaewon Yun on 2022/12/04.
//

import XCTest
import RxSwift
@testable import own_exhibition

final class SignUpViewModelTests: XCTestCase {

    var userRepository: MockUserRepository!
    var coordinator: MockSignUpCoordinator!
    
    var viewModel: SignUpViewModel!
    
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        
        userRepository = .init()
        coordinator = .init()
        
        viewModel = .init(signUpCoordinator: coordinator, userRepository: userRepository)
        
        disposeBag = .init()
        
        LoginStatusManager.shared.logout()
    }

    func test_올바른_정보_입력_후_회원가입_성공() {
        // Arrange
        var isSignUpSuccess = true
        
        let input = SignUpViewModel.Input.init(
            id: .of("test1234@naver.com"),
            password: .of("test1234"),
            repassword: .of("test1234"),
            userName: .of("홍길동"),
            birthday: .of({
                let dateFormatter: DateFormatter = .init()
                dateFormatter.dateFormat = "yyyyMMdd"
                return dateFormatter.date(from: "19990101")!
            }()),
            phoneNumber: .of("01012341234"),
            signUp: .of(())
        )
        let output = viewModel.transform(input: input)
        
        // Act
        [
            output.idValidation
                .drive(onNext: {
                    isSignUpSuccess = (isSignUpSuccess && $0)
                }),
            output.nameValidation
                .drive(onNext: {
                    isSignUpSuccess = (isSignUpSuccess && $0)
                }),
            output.passwordValidation
                .drive(onNext: {
                    isSignUpSuccess = (isSignUpSuccess && $0)
                }),
            output.phoneNumberValidation
                .drive(onNext: {
                    isSignUpSuccess = (isSignUpSuccess && $0)
                }),
            output.signUpButtonEnable
                .drive(onNext: {
                    isSignUpSuccess = (isSignUpSuccess && $0)
                }),
            output.signUp
                .drive(onNext: {
                    isSignUpSuccess = (isSignUpSuccess && true)
                }),
        ]
            .forEach { $0.disposed(by: disposeBag) }
        
        // Assert
        XCTAssertTrue(isSignUpSuccess)
    }
}
