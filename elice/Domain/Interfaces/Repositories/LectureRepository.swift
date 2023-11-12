//
//  LectureRepository.swift
//  elice
//
//  Created by wonki on 11/12/23.
//

import Foundation
import RxSwift

protocol LectureRepository {
    func fetchLectureList(
        courseId: String,
        offset: Int, size: Int
    ) -> Observable<Result<[Lecture], Error>>
}
