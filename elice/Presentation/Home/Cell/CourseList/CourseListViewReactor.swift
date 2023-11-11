//
//  CourseListViewReactor.swift
//  elice
//
//  Created by wonki on 11/11/23.
//

import Foundation
import ReactorKit

final class CourseListViewReactor {
    private let getCourseListUseCase: GetCourseListUseCase
    private let flowActions: MainFlowCoordinateActions?
    private let queryType: CourseListQuery
    private let pageSize: Int
    
    init(
        getCourseListUseCase: GetCourseListUseCase,
        flowActions: MainFlowCoordinateActions?,
        queryType: CourseListQuery,
        pageSize: Int = 10
    ) {
        self.getCourseListUseCase = getCourseListUseCase
        self.flowActions = flowActions
        self.queryType = queryType
        self.pageSize = pageSize
    }
}

extension CourseListViewReactor: Reactor {
    var initialState: State {
        State()
    }
    
    struct State {
        var courseSection: CourseListCell.SingleSection.CourseSectionModel = .init(model: 0, items: [])
        var offset: Int = 0
    }
    
    enum Action {
        case none
        case viewDidLoad
        case loadMorePage
        case selectItem(index: IndexPath)
    }
    
    enum Mutation {
        case none
        case courseListLoaded(list: [Course])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return loadCourses()
        case .loadMorePage:
            return loadCourses()
        case .selectItem(let index):
            print("select \(index.row)")
            flowActions?.showCourseDetail()
            return .just(.none)
        default:
            return .just(.none)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .courseListLoaded(list):
            state.offset += list.count
            state.courseSection.items.append(
                contentsOf: list.map {
                    CourseListCell.SingleSection.CourseItem.firstItem($0)
                }
            )
        default: break
        }
        return state
    }
}

// MARK: - Private

extension CourseListViewReactor {
    
    private func loadCourses() -> Observable<Mutation> {
        getCourseListUseCase.execute(
            query: queryType,
            offset: currentState.offset,
            size: pageSize
        )
        .map {
            return .courseListLoaded(list: $0)
        }
    }
    
}

