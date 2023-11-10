//
//  DefaultCourseRepository.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation
import RxSwift

final class DefaultCourseRepository: CourseRepository {
    private let eliceApiService: DataTransferService
    
    init(eliceApiService: DataTransferService) {
        self.eliceApiService = eliceApiService
    }
    
    func fetchCourseList(
        query: CourseListQuery,
        offset: Int, size: Int
    ) -> Observable<Result<[Course], Error>> {
        let filterIsRecommended = query == .recommend ? true : nil
        let filterIsFree = query == .free ? true : nil
        var filterConditions: CourseListRequestDTO.ConditionsDTO?
        if query == .registered {
            // TODO: Core Data에서 요청하여 수강 신청했던 리스트 가져오기
        }
        
        let endpoint = APIEndpoints.getCourseList(
            with: .init(
                offset: offset, count: size,
                filterIsRecommended: filterIsRecommended,
                filterIsFree: filterIsFree,
                filterConditions: filterConditions)
        )
        
        return eliceApiService.request(with: endpoint)
            .map { result in
                switch result {
                case .success(let response):
                    if response.result.status == .ok {
                        return .success(response.courses.map { $0.toDomain() })
                    } else { // TODO: 실패하는 상황에 대한 Response Model spec을 확인하여 올바른 에러로 처리할 것.
                        return .failure(NSError(
                            domain: "status error", code: -1
                        ))
                    }
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
