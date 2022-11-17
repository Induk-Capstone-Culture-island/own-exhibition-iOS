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
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        let input = LoginViewModel.Input.init(
            login: loginButton.rx.tap.asSignal(),
            id: .of("").asDriver(),
            password: .of("").asDriver()
        )
        let output = viewModel.transform(input: input)
        
        output.isLoggedIn
            .drive(onNext: { isLoggedIn in
                if isLoggedIn == false {
                    print("아이디 혹은 비밀번호가 올바르지 않습니다.")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setViewModel(by viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    @IBAction func didTapDismissButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
}
