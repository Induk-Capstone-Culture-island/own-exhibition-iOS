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
        let searchWord: Driver<String>
        let lodingNextPage: Driver<Void>
    }
    
    struct Output {
        let exhibitions: Driver<[Exhibition]>
        let selectedExhibition: Driver<Exhibition>
    }
    
    private let coordinator: HomeCoordinator
    private let exhibitionRepository: ExhibitionRepository
    
    private var currentExhibitionPage: ExhibitionPage = .init(currentPage: 0, lastPage: 1, exhibitions: [])
    private var currentExhibitions: [Exhibition] = []
    
    init(coordinator: HomeCoordinator, exhibitionRepository: ExhibitionRepository) {
        self.coordinator = coordinator
        self.exhibitionRepository = exhibitionRepository
    }
    
    func transform(input: Input) -> Output {
        let refreshExhibitions = input.searchWord
            .flatMapLatest { searchWord in
                return self.exhibitionRepository.getExhibitions(page: 1, searchWord: searchWord)
                    .do(onNext: { exhibitionPage in
                        self.currentExhibitionPage = exhibitionPage
                        self.currentExhibitions = exhibitionPage.exhibitions
                    })
                    .map { $0.exhibitions }
                    .asDriver(onErrorJustReturn: [])
            }
        
        let updatedExhibitions = input.lodingNextPage
            .withLatestFrom(input.searchWord)
            .flatMap { searchWord in
                let nextPage = self.currentExhibitionPage.currentPage + 1
                
                if nextPage > self.currentExhibitionPage.lastPage {
                    return Driver<[Exhibition]>.of(self.currentExhibitions)
                }
                
                return self.exhibitionRepository.getExhibitions(page: nextPage, searchWord: searchWord)
                    .do(onNext: { exhibitionPage in
                        self.currentExhibitionPage = exhibitionPage
                        self.currentExhibitions += exhibitionPage.exhibitions
                    })
                    .flatMap { exhibitionPage in
                        return Driver<[Exhibition]>.of(self.currentExhibitions)
                    }
                    .asDriver(onErrorJustReturn: self.currentExhibitions)
            }
        
        let exhibitions = Driver.merge(refreshExhibitions, updatedExhibitions)
        
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
