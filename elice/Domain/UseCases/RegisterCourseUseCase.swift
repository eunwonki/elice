//
//  RegisterCourseUseCase.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation
import RxSwift

protocol RegisterCourseUseCase {
    /// return: true - 신청된 상태, false - 신청하지 않은 상태
    func checkRegistered(
        id: String
    ) -> Observable<Bool>
    
    func execute(
        query: CourseRegisterQuery,
        id: String
    ) -> Observable<Void>
}

final class DefaultRegisterCourseUseCase: RegisterCourseUseCase {
    private let repository: CourseRepository
    
    init(repository: CourseRepository) {
        self.repository = repository
    }
    
    func execute(
        query: CourseRegisterQuery, id: String
    ) -> Observable<Void> {
        repository.registerCourse(query: query, id: id)
        return .just(())
    }
    
    func checkRegistered(id: String) -> Observable<Bool> {
        repository.checkRegistered(id: id)
            .observe(on: MainScheduler.instance)
            .map { result in
                switch result {
                case .success(let result):
                    return result
                case .failure:
                    return nil
                }
            }
            .compactMap { $0 }
    }
}
