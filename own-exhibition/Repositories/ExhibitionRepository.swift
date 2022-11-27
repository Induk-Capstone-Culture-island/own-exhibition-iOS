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
            .flatMapLatest { exhibitionsResponseDTO -> Observable<[Exhibition]> in
                return .of(exhibitionsResponseDTO.data.map { $0.toEntity() })
            }
    }
    
    func getExhibitions(bySearchWord searchWord: String) -> Observable<[Exhibition]> {
        // TODO: 서버 검색 API 구현되면 호출해서 검색결과 반환
        return .of([.makeMock1(), .makeMock2()])
    }
}
