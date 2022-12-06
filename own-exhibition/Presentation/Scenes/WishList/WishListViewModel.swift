//
//  WishListViewModel.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/23.
//

import RxSwift
import RxCocoa

final class WishListViewModel: ViewModelType {
    
    private let disposeBag: DisposeBag = .init()
    
    struct Input {
        let viewWillAppear: Signal<Void>
        let selection: Driver<IndexPath>
        let lodingNextPage: Driver<Void>
    }
    
    struct Output {
        let exhibitions: Driver<[Exhibition]>
        let selectedExhibition: Driver<Exhibition>
    }
    
    private let coordinator: WishListCoordinator
    private let exhibitionRepository: ExhibitionRepository
    private let userRepository: UserRepositoryProtocol
    private let userDefaultsRepository: UserDefaultsRepository
    private let keychainRepository: KeychainRepository
    
    private var currentExhibitionPage: ExhibitionPage = .init(currentPage: 0, lastPage: 1, exhibitions: [])
    private var currentExhibitions: [Exhibition] = []
    
    init(
        coordinator: WishListCoordinator,
        exhibitionRepository: ExhibitionRepository,
        userRepository: UserRepositoryProtocol,
        userDefaultsRepository: UserDefaultsRepository,
        keychainRepository: KeychainRepository
    ) {
        self.coordinator = coordinator
        self.exhibitionRepository = exhibitionRepository
        self.userRepository = userRepository
        self.userDefaultsRepository = userDefaultsRepository
        self.keychainRepository = keychainRepository
    }
    
    func transform(input: Input) -> Output {
        let exhibitions = input.viewWillAppear
            .flatMapLatest { _ -> Driver<[Exhibition]> in
                guard let id = self.userDefaultsRepository.getCurrentUserId(),
                      let token = self.keychainRepository.get(id: id)
                else {
                    return .empty()
                }
                
                return self.userRepository.getLikedExhibitionIDs(by: token)
                    .flatMapLatest { ids -> Observable<[Exhibition]> in
                        return ids.map { self.exhibitionRepository.getExhibition(byID: $0) }
                            .reduce(Observable<Exhibition>.empty()) { partialResult, observable in
                                partialResult.concat(observable)
                            }
                            .reduce(Array<Exhibition>.init(), accumulator: { arr, exhibition in
                                var arr = arr
                                arr.append(exhibition)
                                return arr
                            })
                    }
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
