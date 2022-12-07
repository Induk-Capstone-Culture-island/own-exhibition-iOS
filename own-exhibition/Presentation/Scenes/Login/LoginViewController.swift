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
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    private let dismissButton: UIBarButtonItem = .init()
    @IBOutlet weak var signUpButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureNavigationBarButton()
        performKeyboardDelegate()
    }
    
    func setViewModel(by viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Private Functions

private extension LoginViewController {
    
    func bindViewModel() {
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        let input = LoginViewModel.Input.init(
            viewWillAppear: viewWillAppear,
            login: loginButton.rx.tap.asSignal(),
            id: idTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            signUp: signUpButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)
        
        [
            output.idValidation
                .drive(),
            output.passwordValidation
                .drive(),
            output.loginButtonEnable
                .drive(onNext: { [weak self] in self?.loginButton.isEnabled = $0 }),
            output.isLoggedIn
                .drive(onNext: { isLoggedIn in
                    if isLoggedIn == false {
                        print("아이디 혹은 비밀번호가 올바르지 않습니다.")
                    }
                }),
            output.signUp
                .drive(),
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }
    
    func configureNavigationBarButton() {
        dismissButton.primaryAction = .init(handler: { [weak self] _ in
            self?.dismiss(animated: false)
        })
        dismissButton.image = .init(named: "back_button")
        dismissButton.tintColor = .darkGray
        self.navigationItem.rightBarButtonItem = dismissButton
        self.navigationItem.backBarButtonItem = DefaultBackBarButtonItem.init()
    }
    
    @IBAction func didTapBackgroundView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

// MARK: - KeyboardDelegate

extension LoginViewController: KeyboardDelegate {
    
    func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height,
            let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)
        else { return }
        
        let spacing: CGFloat = 14
        
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.signUpButtonBottomConstraint.constant = keyboardHeight + spacing
            self.signUpButtonBottomConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)
        else { return }
        
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.signUpButtonBottomConstraint.isActive = false
            self.view.layoutIfNeeded()
        }
    }
}
