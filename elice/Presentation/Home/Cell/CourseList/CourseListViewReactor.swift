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
        case refresh
        case loadMorePage
        case selectItem(index: IndexPath)
    }
    
    enum Mutation {
        case none
        case refreshed
        case courseListLoaded(list: [Course], offset: Int)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return loadCourses(offset: 0)
        case .loadMorePage:
            return loadCourses(offset: currentState.offset)
        case .selectItem(let index):
            if case .firstItem(let course) = currentState.courseSection.items[index.row] {
                flowActions?.showCourseDetail(course.id)
            }
            return .just(.none)
        default:
            return .just(.none)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .courseListLoaded(list, offset):
            state.offset = offset + list.count
            if offset == 0 {
                state.courseSection = .init(model: 0, items: [])
            }
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
    
    private func loadCourses(offset: Int) -> Observable<Mutation> {
        getCourseListUseCase.execute(
            query: queryType,
            offset: offset,
            size: pageSize
        )
        .map {
            return .courseListLoaded(list: $0, offset: offset)
        }
    }
    
}

