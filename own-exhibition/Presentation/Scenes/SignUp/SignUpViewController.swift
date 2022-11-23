//
//  SignUpViewController.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/22.
//

import UIKit
import RxSwift

final class SignUpViewController: UIViewController {
    
    private var disposeBag: DisposeBag = .init()
    
    private var viewModel: SignUpViewModel!
    
    // MARK: - UI Components
    
    @IBOutlet weak var inputFormStackView: UIStackView! {
        didSet {
            inputFormStackView.arrangedSubviews.forEach { view in
                view.layer.addBorder([.bottom], color: .systemGray4, width: 1.0)
            }
        }
    }
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet { passwordTextField.isSecureTextEntry = true }
    }
    @IBOutlet weak var repasswordTextField: UITextField! {
        didSet { repasswordTextField.isSecureTextEntry = true }
    }
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureNavigationBar()
        addObserversForKeyboard()
    }
    
    func setViewModel(by viewModel: SignUpViewModel) {
        self.viewModel = viewModel
    }
}

private extension SignUpViewController {
    
    func bindViewModel() {
        let input = SignUpViewModel.Input.init(
            id: idTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            repassword: repasswordTextField.rx.text.orEmpty.asDriver(),
            userName: nameTextField.rx.text.orEmpty.asDriver(),
            birthday: birthdayDatePicker.rx.date.asDriver(),
            phoneNumber: phoneNumberTextField.rx.text.orEmpty.asDriver(),
            signUp: signUpButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)
        
        [
            output.idValidation
                .drive(),
            output.passwordValidation
                .drive(),
            output.nameValidation
                .drive(),
            output.phoneNumberValidation
                .drive(),
            output.signUpButtonEnable
                .drive(onNext: { self.signUpButton.isEnabled = $0 }),
            output.signUp
                .drive(),
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "회원가입"
    }
    
    func addObserversForKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height,
            let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)
        else { return }
        
        let spacing: CGFloat = 12
        
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.signUpButtonBottomConstraint.constant = keyboardHeight + spacing
            self.signUpButtonBottomConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
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
