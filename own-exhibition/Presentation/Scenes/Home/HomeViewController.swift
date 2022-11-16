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
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map { _ in }
        
        let input = HomeViewModel.Input.init(
            viewWillAppear: viewWillAppear.asSignal(onErrorSignalWith: .empty()),
            selection: exhibitionTableView.rx.itemSelected.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        output.exhibitions
            .drive(
                exhibitionTableView.rx.items(
                    cellIdentifier: ExhibitionTableViewCell.id,
                    cellType: ExhibitionTableViewCell.self
                )
            ) { index, exhibition, cell in
                let indexPath: IndexPath = .init(row: index, section: 0)
                cell.initializeCell()
                cell.bind(exhibition, withFetchedImage: { [indexPath] thumbnailImage in
                    DispatchQueue.main.async {
                        let currentCell = self.exhibitionTableView.cellForRow(at: indexPath) as? ExhibitionTableViewCell
                        currentCell?.setThumbnailImage(thumbnailImage)
                    }
                })
            }
            .disposed(by: disposeBag)
        
        output.selectedExhibition
            .drive()
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
