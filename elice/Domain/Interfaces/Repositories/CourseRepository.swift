//
//  CourseRepository.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation
import RxSwift

protocol CourseRepository {
    func fetchCourseList(
        query: CourseListQuery,
        offset: Int, size: Int
    ) -> Observable<Result<[Course], Error>>
    
    func fetchCourse(
        id: String
    ) -> Observable<Result<Course, Error>>
    
    func registerCourse(
        query: CourseRegisterQuery, id: String
    )
    
    func checkRegistered(id: String) -> Observable<Result<Bool, Error>>
}
