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
    private let persistentStore: RegisteredCourseStorage
    
    init(
        eliceApiService: DataTransferService,
        persistentStore: RegisteredCourseStorage
    ) {
        self.eliceApiService = eliceApiService
        self.persistentStore = persistentStore
    }
    
    func registerCourse(query: CourseRegisterQuery, id: String) {
        persistentStore.request(query: query, id: id)
    }
    
    func checkRegistered(id: String) -> Observable<Result<Bool, Error>> {
        persistentStore.fetchRegisterCoursesIds()
            .map { result in
                switch result {
                case .success(let list):
                    return .success(list.contains { $0 == id })
                case.failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchCourse(
        id: String
    ) -> Observable<Result<Course, Error>> {
        let endpoint = APIEndpoints.getCourse(with: .init(courseId: id))
        return eliceApiService.request(with: endpoint)
            .map { result in
                switch result {
                case .success(let response):
                    switch response.result.status {
                    case .ok:
                        return .success(response.course.toDomain())
                    case .fail:
                        return .failure(NSError(
                            domain: response.result.reason ?? "",
                            code: -1
                        ))
                    }
                case .failure(let error): return .failure(error)
                }
            }
    }
    
    func fetchCourseList(
        query: CourseListQuery,
        offset: Int, size: Int
    ) -> Observable<Result<[Course], Error>> {
        Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            _ = courseListEndPoint(
                query: query, offset: offset, size: size
            ).subscribe { endpoint in
                _ = self.fetchCoursesFromNetwork(with: endpoint)
                    .subscribe {
                        observer.onNext($0)
                        observer.onCompleted()
                    }
            }
            
            return Disposables.create()
        }
    }
    
    // MARK: - Private
    
    private func fetchCoursesFromNetwork(
        with endpoint: Endpoint<CourseListResponseDTO>
    ) -> Observable<Result<[Course], Error>> {
        // TODO: Course List 가져오는 API의 실패하는 상황에 대한 Response Model spec을 확인하여 올바른 에러로 처리할 것.
        
        eliceApiService.request(with: endpoint)
            .map { result in
                switch result {
                case .success(let response):
                    if response.result.status == .ok {
                        return .success(response.courses.map { $0.toDomain() })
                    } else {
                        return .failure(NSError(
                            domain: "status error", code: -1
                        ))
                    }
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    private func courseListEndPoint(
        query: CourseListQuery,
        offset: Int, size: Int
    ) -> Observable<Endpoint<CourseListResponseDTO>> {
        Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            if query == .registered {
                return fetchRegisteredList()
                    .subscribe { registered in
                        observer.onNext(APIEndpoints.getCourseList(
                            with: .init(offset: offset,
                                        count: size,
                                        filterIsRecommended: nil,
                                        filterIsFree: nil,
                                        filterConditions: .init(courseIds: registered))))
                        observer.onCompleted()
                    }
            } else {
                observer.onNext(APIEndpoints.getCourseList(
                    with: .init(offset: offset,
                                count: size,
                                filterIsRecommended: query == .recommend ? "true" : nil,
                                filterIsFree: query == .free ? "true" : nil,
                                filterConditions: nil)))
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    private func fetchRegisteredList() -> Observable<[String]> {
        persistentStore
            .fetchRegisterCoursesIds()
            .map { result in
                switch result {
                case .success(let list): return list
                case .failure: return []
                }
            }
    }
}
