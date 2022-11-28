//
//  WishListViewController.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/23.
//

import UIKit
import RxSwift

final class WishListViewController: UIViewController {
    
    private let disposeBag = DisposeBag.init()
    
    private var viewModel: WishListViewModel!

    // MARK: - UI Components
    
    @IBOutlet weak var searchBar: ExhibitionSearchBar!
    @IBOutlet weak var exhibitionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    func setViewModel(by viewModel: WishListViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Private Functions

private extension WishListViewController {
    
    func bindViewModel() {
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map { _ in }
        
        let input = WishListViewModel.Input.init(
            viewWillAppear: viewWillAppear.asSignal(onErrorSignalWith: .empty()),
            selection: exhibitionTableView.rx.itemSelected.asDriver().throttle(.milliseconds(500), latest: false),
            searchWord: searchBar.rx.text.orEmpty.asDriver().debounce(.milliseconds(300))
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
    
    func registerCell() {
        let nibName = ExhibitionTableViewCell.id
        let nib = UINib.init(nibName: nibName, bundle: nil)
        exhibitionTableView.register(nib, forCellReuseIdentifier: nibName)
    }
    
    func configureNavigationBar() {
        self.navigationItem.backBarButtonItem = DefaultBackBarButtonItem.init()
        self.navigationController?.isNavigationBarHidden = true
    }
}
