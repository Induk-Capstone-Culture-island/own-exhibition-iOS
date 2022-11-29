//
//  ChangeInfoViewController.swift
//  own-exhibition
//
//  Created by 소프트웨어컴퓨터 on 2022/11/13.
//

import UIKit
import RxSwift

final class ChangeInfoViewController: UIViewController {
    
    private let disposeBag = DisposeBag.init()
    
    private var viewModel: ChangeInfoViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        let input = ChangeInfoViewModel.Input.init(viewWillAppear: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.userInfo
            .drive()
            .disposed(by: disposeBag)
    }
    
    func setViewModel(by viewModel: ChangeInfoViewModel) {
        self.viewModel = viewModel
    }
}
