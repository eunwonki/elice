//
//  GetLectureListUseCase.swift
//  elice
//
//  Created by wonki on 11/12/23.
//

import Foundation
import RxSwift

protocol GetLectureListUseCase {
    func execute(
        courseId: String, offset: Int, size: Int
    ) -> Observable<[Lecture]>
}

final class DefaultGetLectureListUseCase: GetLectureListUseCase {
    let repository: LectureRepository
    
    init(repository: LectureRepository) {
        self.repository = repository
    }
    
    func execute(
        courseId: String, offset: Int, size: Int
    ) -> Observable<[Lecture]> {
        repository.fetchLectureList(
            courseId: courseId, offset: offset, size: size
        ).map { result in
            switch result {
            case .success(let list): return list
            case .failure: return nil
            }
        }.compactMap { $0 }
    }
}
