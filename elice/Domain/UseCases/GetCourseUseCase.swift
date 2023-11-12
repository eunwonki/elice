//
//  GetCourseUseCase.swift
//  elice
//
//  Created by wonki on 11/12/23.
//

import Foundation
import RxSwift

protocol GetCourseUseCase {
    func execute(
        id: String
    ) -> Observable<Course>
}

final class DefaultGetCourseUseCase: GetCourseUseCase {
    let repository: CourseRepository
    
    init(repository: CourseRepository) {
        self.repository = repository
    }
    
    func execute(id: String) -> Observable<Course> {
        repository.fetchCourse(
            id: id
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
