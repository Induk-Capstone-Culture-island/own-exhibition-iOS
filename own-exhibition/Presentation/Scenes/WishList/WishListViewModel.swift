//
//  WishListViewModel.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/23.
//

import RxSwift
import RxCocoa

final class WishListViewModel: ViewModelType {
    
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
    
    private let coordinator: WishListCoordinator
    private let exhibitionRepository: ExhibitionRepository
    
    private var currentExhibitionPage: ExhibitionPage = .init(currentPage: 0, lastPage: 1, exhibitions: [])
    private var currentExhibitions: [Exhibition] = []
    
    init(coordinator: WishListCoordinator, exhibitionRepository: ExhibitionRepository) {
        self.coordinator = coordinator
        self.exhibitionRepository = exhibitionRepository
    }
    
    func transform(input: Input) -> Output {
        let refreshExhibitions = input.searchWord
            .flatMapLatest { searchWord in
                // FIXME: 특정 유저의 찜 목록 가져오는 함수로 변경
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
                
                // FIXME: 특정 유저의 찜 목록 가져오는 함수로 변경
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
