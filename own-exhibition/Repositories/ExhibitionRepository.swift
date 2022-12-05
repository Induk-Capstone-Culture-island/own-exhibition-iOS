//
//  ExhibitionRepository.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/10/31.
//

import RxSwift

final class ExhibitionRepository {
    
    static let shared: ExhibitionRepository = .init()
    
    private init() {}
    
    private let networkService: NetworkService<ExhibitionPageResponseDTO> = .init()
    
    // TODO: 서버 검색 API 구현되면 검색어 쿼리 추가
    func getExhibitions(page: Int, searchWord: String) -> Observable<ExhibitionPage> {
        let path: String = "exhibition?page=\(page)"
        return networkService.getItem(byPath: path)
            .flatMapLatest { exhibitionPageResponseDTO -> Observable<ExhibitionPage> in
                return .of(exhibitionPageResponseDTO.toEntity())
            }
    }
}
