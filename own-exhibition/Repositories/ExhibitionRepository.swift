//
//  ExhibitionRepository.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/10/31.
//

import RxSwift

final class ExhibitionRepository {
    
    private let networkService: NetworkService<ExhibitionsResponseDTO> = .init()
    
    func getExhibitions() -> Observable<[Exhibition]> {
        let path: String = "exhibition"
        return networkService.getItem(byPath: path)
            .do(onNext: { exhibitionsResponseDTO in
                print(exhibitionsResponseDTO)
            },
                onError: { error in
                print(error)
            })
            .flatMapLatest { exhibitionsResponseDTO -> Observable<[Exhibition]> in
                return .of(exhibitionsResponseDTO.data.map { $0.toEntity() })
            }
    }
}
