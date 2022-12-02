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

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
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
