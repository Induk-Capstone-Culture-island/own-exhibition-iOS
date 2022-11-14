//
//  ExhibitionDetailViewController.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/01.
//

import RxSwift

final class ExhibitionDetailViewController: UIViewController {
    
    private let disposeBag = DisposeBag.init()
    
    private var viewModel: ExhibitionDetailViewModel!
    
    // MARK: - UI Components
    
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        let input = ExhibitionDetailViewModel.Input.init(
            viewWillAppear: viewWillAppear
        )
        let output = viewModel.transform(input: input)
        
        output.exhibition
            .drive(exhibitionBinding)
            .disposed(by: disposeBag)
    }
    
    private var exhibitionBinding: Binder<Exhibition> {
        return .init(self, binding: { vc, exhibition in
            ImageLoader.patch(exhibition.thumbnailUrl) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        vc.originalImageView.image = image
                    case .failure(let error):
                        _ = error
                        vc.originalImageView.image = .defaultThumbnail
                    }
                }
            }
            vc.periodLabel.text = {
                let formatter: DateFormatter = .init()
                formatter.dateFormat = "yyyy.MM.dd"
                let startDate = formatter.string(from: exhibition.startDate)
                let endDate = formatter.string(from: exhibition.endDate)
                return "기간 : \(startDate)~\(endDate)"
            }()
            vc.placeLabel.text = "장소 : \(exhibition.place)"
            vc.descriptionLabel.text = exhibition.description
        })
    }
    
    func setViewModel(by viewModel: ExhibitionDetailViewModel) {
        self.viewModel = viewModel
    }
}
