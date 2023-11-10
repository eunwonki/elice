//
//  GetCourseListUseCase.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation
import RxSwift

protocol GetCourseListUseCase {
    func execute(
        query: CourseListQuery,
        offset: Int, size: Int
    ) -> Observable<[Course]>
}

final class DefaultGetCourseListUseCase: GetCourseListUseCase {
    private let repository: CourseRepository
    
    init(repository: CourseRepository) {
        self.repository = repository
    }
    
    func execute(
        query: CourseListQuery,
        offset: Int, size: Int
    ) -> Observable<[Course]> {
        repository.fetchCourseList(
            query: query, offset: offset, size: size
        )
        .map { result in
            switch result {
            case .success(let list):
                return list
            case .failure(let error):
                print(error)
                return nil
            }
        }
        .compactMap { $0 }
    }
}
