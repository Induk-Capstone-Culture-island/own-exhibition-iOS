//
//  HomeViewModel.swift
//  own-exhibition
//
//  Created by Jaewon on 2022/10/20.
//

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Signal<Void>
        let selection: Driver<IndexPath>
    }
    
    struct Output {
        let exhibitions: Driver<[Exhibition]>
        let selectedExhibition: Driver<Exhibition>
    }
    
    private let coordinator: HomeCoordinator
    private let exhibitionRepository: ExhibitionRepository
    
    init(coordinator: HomeCoordinator, exhibitionRepository: ExhibitionRepository) {
        self.coordinator = coordinator
        self.exhibitionRepository = exhibitionRepository
    }
    
    func transform(input: Input) -> Output {
        let exhibitions = input.viewWillAppear
            .flatMapLatest { _ in
                return self.exhibitionRepository.getExhibitions()
                    .asDriver(onErrorJustReturn: [])
            }
        let selectedExhibition = input.selection
            .withLatestFrom(exhibitions) { indexPath, exhibitions -> Exhibition in
                return exhibitions[indexPath.row]
            }
            .do(onNext: coordinator.toDetail)
        
        return .init(
            exhibitions: exhibitions,
            selectedExhibition: selectedExhibition
        )
    }
}
