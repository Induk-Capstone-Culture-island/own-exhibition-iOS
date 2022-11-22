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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureNavigationBar()
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
        
        output.signUp
            .drive()
            .disposed(by: disposeBag)
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "회원가입"
    }
}
