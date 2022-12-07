//
//  ExhibitionDetailViewModel.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/01.
//

import RxSwift
import RxCocoa

final class ExhibitionDetailViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Signal<Void>
        let tapLikeButton: Signal<Void>
    }
    
    struct Output {
        let exhibition: Driver<Exhibition>
        let isLike: Driver<Bool>
        let didTapLikeButton: Signal<Void>
    }
    
    private let exhibition: Exhibition
    
    private let userRepository: UserRepositoryProtocol
    private let keychainRepository: KeychainRepository
    private let userDefaultsRepository: UserDefaultsRepository
    
    init(
        exhibition: Exhibition,
        userRepository: UserRepositoryProtocol,
        keychainRepository: KeychainRepository,
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.exhibition = exhibition
        self.userRepository = userRepository
        self.keychainRepository = keychainRepository
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func transform(input: Input) -> Output {
        let exhibition = input.viewWillAppear
            .flatMapLatest { _ in
                return Driver<Exhibition>.of(self.exhibition)
            }
        
        let isLike = input.viewWillAppear
            .flatMap { _ -> Driver<Bool> in
                guard LoginStatusManager.shared.isLoggedIn else {
                    return .of(false)
                }
                
                guard let id = self.userDefaultsRepository.getCurrentUserId(),
                      let token = self.keychainRepository.get(id: id)
                else {
                    return .of(false)
                }
                
                return self.userRepository.getLikedExhibitionIDs(by: token)
                    .map { ids -> Bool in
                        return ids.contains(self.exhibition.id)
                    }
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        let didTapLikeButton = input.tapLikeButton
            .flatMap { _ -> Signal<Void> in
                guard let id = self.userDefaultsRepository.getCurrentUserId(),
                      let token = self.keychainRepository.get(id: id)
                else {
                    // FIXME: 로그인 필요 메세지 출력
                    return .of(())
                }
                
                return self.userRepository.addWishExhibition(id: self.exhibition.id, token: token)
                    .asSignal(onErrorJustReturn: ())
            }
        
        return .init(
            exhibition: exhibition,
            isLike: isLike,
            didTapLikeButton: didTapLikeButton
        )
    }
}
