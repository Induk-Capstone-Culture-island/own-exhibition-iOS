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
    }
    
    struct Output {
        let exhibitions: Driver<[Exhibition]>
        let selectedExhibition: Driver<Exhibition>
    }
    
    private let coordinator: WishListCoordinator
    private let exhibitionRepository: ExhibitionRepository
    
    init(coordinator: WishListCoordinator, exhibitionRepository: ExhibitionRepository) {
        self.coordinator = coordinator
        self.exhibitionRepository = exhibitionRepository
    }
    
    func transform(input: Input) -> Output {
        let exhibitions = Driver.combineLatest(input.viewWillAppear.asDriver(onErrorDriveWith: .empty()), input.searchWord)
            .flatMapLatest { _, searchWord in
                if searchWord.isEmpty {
                    // FIXME: 특정 유저의 찜 목록 가져오는 로직으로 변경
                    return self.exhibitionRepository.getExhibitions()
                        .asDriver(onErrorJustReturn: [])
                } else {
                    // FIXME: 특정 유저의 찜 목록에서 검색하는 로직으로 변경
                    return self.exhibitionRepository.getExhibitions(bySearchWord: searchWord)
                        .asDriver(onErrorJustReturn: [])
                }
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
