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
}
