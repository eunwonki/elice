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
    
    init(
        courseId: String,
        getCourseUseCase: GetCourseUseCase,
        registerCourseUseCase: RegisterCourseUseCase
    ) {
        self.courseId = courseId
        self.getCourseUseCase = getCourseUseCase
        self.registerCourseUseCase = registerCourseUseCase
    }
}

extension CourseDetailViewReactor: Reactor {
    var initialState: State {
        State()
    }
    
    struct State {
        var isRegistered: Bool?
        var course: Course?
    }
    
    enum Action {
        case none
        case viewDidLoad
        case didRegisterClicked(query: CourseRegisterQuery)
    }
    
    enum Mutation {
        case none
        case didLoadCourse(course: Course)
        // didLoadLectures
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
                    Mutation.getRegistered(state: $0)
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
