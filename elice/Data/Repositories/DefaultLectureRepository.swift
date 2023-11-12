//
//  DefaultLectureRepository.swift
//  elice
//
//  Created by wonki on 11/12/23.
//

import Foundation
import RxSwift

final class DefaultLectureRepository: LectureRepository {
    let eliceApiService: DataTransferService
    
    init(eliceApiService: DataTransferService) {
        self.eliceApiService = eliceApiService
    }
    
    func fetchLectureList(
        courseId: String,
        offset: Int, size: Int
    ) -> Observable<Result<[Lecture], Error>> {
        let endpoint = APIEndpoints.getLectureList(with: .init(
            offset: offset, count: size, courseId: courseId
        ))
        
        return eliceApiService.request(with: endpoint)
            .map { result in
                switch result {
                case .success(let response):
                    switch response.result.status {
                    case .ok: return .success(
                        response.lectures.map {
                            $0.toDomain()
                        })
                    case .fail: return .failure(
                        NSError(
                            domain: response.result.reason ?? "", code: -1
                        ))
                    }
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
