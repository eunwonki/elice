//
//  RegisterCourseUseCase.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation
import RxSwift

protocol RegisterCourseUseCase {
    func execute(
        query: CourseRegisterQuery,
        id: String
    )
}

final class DefaultRegisterCourseUseCase: RegisterCourseUseCase {
    private let repository: CourseRepository
    
    init(repository: CourseRepository) {
        self.repository = repository
    }
    
    func execute(query: CourseRegisterQuery, id: String) {
        repository.registerCourse(query: query, id: id)
    }
}
