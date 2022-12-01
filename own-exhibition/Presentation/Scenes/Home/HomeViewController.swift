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
    
    private var viewModel: HomeViewModel!
    
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
    
    func setViewModel(by viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Private Functions

private extension HomeViewController {
    
    func bindViewModel() {
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        let input = HomeViewModel.Input.init(
            viewWillAppear: viewWillAppear,
            selection: exhibitionTableView.rx.itemSelected.asDriver().throttle(.milliseconds(500), latest: false),
            searchWord: searchBar.rx.text.orEmpty.asDriver().debounce(.milliseconds(300)),
            lodingNextPage: exhibitionTableView.rx.didScrollToBottom.asDriver()
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
