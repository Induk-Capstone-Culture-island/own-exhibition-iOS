//
//  HomeViewController.swift
//  own-exhibition
//
//  Created by Jaewon on 2022/10/04.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    
    private let disposeBag = DisposeBag.init()
    
    @IBOutlet weak var exhibitionTableView: UITableView!
    
    private var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        registerCell()
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input.init()
        let output = viewModel.transform(input: input)
        
        output.exhibitions
            .drive(
                exhibitionTableView.rx.items(
                    cellIdentifier: ExhibitionTableViewCell.id,
                    cellType: ExhibitionTableViewCell.self
                )
            ) { index, exhibition, cell in
                cell.bind(by: exhibition)
            }
            .disposed(by: disposeBag)
    }
    
    private func registerCell() {
        let nibName = ExhibitionTableViewCell.id
        let nib = UINib.init(nibName: nibName, bundle: nil)
        exhibitionTableView.register(nib, forCellReuseIdentifier: nibName)
    }
    
    func setViewModel(by viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
}
