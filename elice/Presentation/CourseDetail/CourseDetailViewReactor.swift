//
//  CourseDetailViewReactor.swift
//  elice
//
//  Created by wonki on 11/12/23.
//

import Foundation
import ReactorKit

final class CourseDetailViewReactor {
    let courseId: String
    let getCourseUseCase: GetCourseUseCase
    let registerCourseUseCase: RegisterCourseUseCase
    let getLectureListUseCase: GetLectureListUseCase
    
    let lectureFetchSize = 10
    
    init(
        courseId: String,
        getCourseUseCase: GetCourseUseCase,
        registerCourseUseCase: RegisterCourseUseCase,
        getLectureListUseCase: GetLectureListUseCase
    ) {
        self.courseId = courseId
        self.getCourseUseCase = getCourseUseCase
        self.registerCourseUseCase = registerCourseUseCase
        self.getLectureListUseCase = getLectureListUseCase
    }
}

extension CourseDetailViewReactor: Reactor {
    var initialState: State {
        State()
    }
    
    struct State {
        var isRegistered: Bool?
        var course: Course?
        var lectures: [Lecture] = []
        var lectureOffset: Int = 0
    }
    
    enum Action {
        case none
        case viewDidLoad
        case didRegisterClicked(query: CourseRegisterQuery)
    }
    
    enum Mutation {
        case none
        case didLoadCourse(course: Course)
        case didLoadLectures(lectures: [Lecture])
        case getRegistered(state: Bool)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return onViewDidLoad()
        case .didRegisterClicked(let query):
            return onRegisterClick(query: query)
        default:
            return .just(.none)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .didLoadCourse(let course):
            state.course = course
        case .getRegistered(let isRegistered):
            state.isRegistered = isRegistered
        case .didLoadLectures(let lectures):
            state.lectures.append(contentsOf: lectures)
            state.lectureOffset += lectures.count
        default: break
        }
        return state
    }
}

// MARK: - Private

extension CourseDetailViewReactor {
    func onViewDidLoad() -> Observable<Mutation> {
        Observable.merge (
            getCourseUseCase.execute(id: courseId)
                .map {
                    .didLoadCourse(course: $0)
                },
            
            registerCourseUseCase.checkRegistered(id: courseId)
                .map {
                    .getRegistered(state: $0)
                },
            
            getLectureListUseCase.execute(
                courseId: courseId,
                offset: currentState.lectureOffset,
                size: lectureFetchSize
            )
            .map {
                .didLoadLectures(lectures: $0)
            }
        )
    }
    
    func onRegisterClick(
        query: CourseRegisterQuery
    ) -> Observable<Mutation> {
        registerCourseUseCase.execute(
            query: query, id: courseId
        ).map { Mutation.getRegistered(
            state: query == .register
        ) }
    }
}
