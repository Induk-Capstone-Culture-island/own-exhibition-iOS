//
//  ExhibitionDetailViewController.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/01.
//

import RxSwift

final class ExhibitionDetailViewController: UIViewController {
    
    private let disposeBag = DisposeBag.init()
    
    var viewModel: ExhibitionDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = ExhibitionDetailViewModel.Input.init()
        let output = viewModel.transform(input: input)
    }
}
