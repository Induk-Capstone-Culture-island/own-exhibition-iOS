//
//  ChangePasswordViewController.swift
//  own-exhibition
//
//  Created by 소프트웨어컴퓨터 on 2022/11/27.
//

import UIKit
import RxSwift

final class ChangePasswordViewController: UIViewController {

    private let disposeBag = DisposeBag.init()
    
    private var viewModel: ChangePasswordViewModel!

    @IBOutlet weak var currentPasswordTextField: UITextField! {
        didSet {
            currentPasswordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var newPasswordTextField: UITextField! {
        didSet {
            newPasswordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var newRepasswordTextField: UITextField! {
        didSet {
            newRepasswordTextField.isSecureTextEntry = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    @IBAction func didTapBackgroundView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func bindViewModel() {
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        let input = ChangePasswordViewModel.Input.init(viewWillAppear: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.userInfo
            .drive()
            .disposed(by: disposeBag)
    }
    
    func setViewModel(by viewModel: ChangePasswordViewModel) {
        self.viewModel = viewModel
    }

}
