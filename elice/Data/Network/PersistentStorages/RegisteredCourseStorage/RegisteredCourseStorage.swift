//
//  RegisteredCourseStorage.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation
import RxSwift

protocol RegisteredCourseStorage {
    func fetchRegisterCoursesIds() -> Observable<Result<[String], Error>>
    func request(
        query: CourseRegisterQuery, id: String
    ) // TODO: 지금은 모두 성공으로 처리하지만 요구사항에 적혀 있다면 실패 처리 구현.
}
