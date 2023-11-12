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
    
    init(
        courseId: String,
        getCourseUseCase: GetCourseUseCase
    ) {
        self.courseId = courseId
        self.getCourseUseCase = getCourseUseCase
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
        default:
            return .just(.none)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .didLoadCourse(let course):
            state.course = course
        default: break
        }
        return state
    }
}

// MARK: - Private

extension CourseDetailViewReactor {
    func onViewDidLoad() -> Observable<Mutation> {
//        Observable.merge {
//            
//        }
        
        getCourseUseCase.execute(id: courseId)
            .map {
                .didLoadCourse(course: $0)
            }
    }
}
