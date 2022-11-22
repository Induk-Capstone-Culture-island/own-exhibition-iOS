//
//  LoginViewController.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/15.
//

import UIKit
import RxSwift

final class LoginViewController: UIViewController {
    
    private var disposeBag: DisposeBag = .init()
    
    private var viewModel: LoginViewModel!
    
    // MARK: - UI Components
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    private let dismissButton: UIBarButtonItem = {
        let button: UIBarButtonItem = .init()
        button.tintColor = .systemGray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureNavigationBarButton()
    }
    
    func setViewModel(by viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
}

private extension LoginViewController {
    
    func bindViewModel() {
        let input = LoginViewModel.Input.init(
            login: loginButton.rx.tap.asSignal(),
            id: idTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            signUp: signUpButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)
        
        output.isLoggedIn
            .drive(onNext: { isLoggedIn in
                if isLoggedIn == false {
                    print("아이디 혹은 비밀번호가 올바르지 않습니다.")
                }
            })
            .disposed(by: disposeBag)
        
        output.signUp
            .drive()
            .disposed(by: disposeBag)
    }
    
    func configureNavigationBarButton() {
        dismissButton.primaryAction = .init(handler: { _ in
            self.dismiss(animated: false)
        })
        dismissButton.title = "X"
        self.navigationItem.rightBarButtonItem = dismissButton
        self.navigationItem.backBarButtonItem = DefaultBackBarButtonItem.init()
    }
}
