//
//  ExhibitionDetailViewController.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/01.
//

import RxSwift
import MapKit

final class ExhibitionDetailViewController: UIViewController {
    
    private let disposeBag = DisposeBag.init()
    
    private var viewModel: ExhibitionDetailViewModel!
    
    // MARK: - UI Components
    
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationMapView: MKMapView!
    private let likeButton: UIBarButtonItem = .init(image: .init(systemName: "heart"))
    
    private var isLike: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureNavigationBar()
    }
    
    func setViewModel(by viewModel: ExhibitionDetailViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Private Functions

private extension ExhibitionDetailViewController {
    
    func bindViewModel() {
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        let input = ExhibitionDetailViewModel.Input.init(
            viewWillAppear: viewWillAppear,
            tapLikeButton: likeButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)
        
        output.exhibition
            .drive(exhibitionBinding)
            .disposed(by: disposeBag)
        
        output.isLike
            .drive(onNext: { [weak self] isLike in
                self?.isLike = isLike
                if isLike {
                    self?.likeButton.image = UIImage.init(systemName: "heart.fill")
                } else {
                    self?.likeButton.image = UIImage.init(systemName: "heart")
                }
            })
            .disposed(by: disposeBag)
        
        output.didTapLikeButton
            .emit(onNext: { [weak self] in self?.toggleLikeButton() })
            .disposed(by: disposeBag)
    }
    
    var exhibitionBinding: Binder<Exhibition> {
        return .init(self, binding: { [weak self] vc, exhibition in
            ImageLoader.shared.patch(exhibition.thumbnailUrl) { result in
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
                return "?????? : \(startDate)~\(endDate)"
            }()
            vc.placeLabel.text = "?????? : \(exhibition.place)"
            vc.descriptionLabel.text = exhibition.description
            self?.initializeMapView(exhibition.location)
            self?.navigationItem.title = exhibition.title
        })
    }
    
    func initializeMapView(_ geo: GeoCoordinate) {
        let delta: CLLocationDegrees = 0.01
        let span: MKCoordinateSpan = .init(latitudeDelta: delta, longitudeDelta: delta)
        let center: CLLocationCoordinate2D = .init(latitude: geo.lat, longitude: geo.lon)
        let region: MKCoordinateRegion = .init(center: center, span: span)
        locationMapView.setRegion(region, animated: false)
    }
    
    func toggleLikeButton() {
        if isLike {
            self.likeButton.image = UIImage.init(systemName: "heart")
        } else {
            self.likeButton.image = UIImage.init(systemName: "heart.fill")
        }
        isLike.toggle()
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "."
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.rightBarButtonItem = likeButton
    }
}
