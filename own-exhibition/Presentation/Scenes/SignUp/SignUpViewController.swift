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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        let input = SignUpViewModel.Input.init()
        let output = viewModel.transform(input: input)

        _ = output
    }
    
    func setViewModel(by viewModel: SignUpViewModel) {
        self.viewModel = viewModel
    }
}
