//
//  HomeViewReactor.swift
//  elice
//
//  Created by wonki on 11/11/23.
//

import Foundation
import ReactorKit

// MARK: - Init

final class HomeViewReactor {
    private let getCourseListUseCase: GetCourseListUseCase
    private let flowActions: MainFlowCoordinateActions?
    private let pageSize = 10
    
    lazy var recommendListReactor: CourseListViewReactor = {
        .init(
            getCourseListUseCase: self.getCourseListUseCase, 
            flowActions: self.flowActions,
            queryType: .recommend
        )
    }()
    
    lazy var freeListReactor: CourseListViewReactor = {
        .init(
            getCourseListUseCase: self.getCourseListUseCase,
            flowActions: self.flowActions,
            queryType: .free
        )
    }()
    
    lazy var registeredListReactor: CourseListViewReactor = {
        .init(
            getCourseListUseCase: self.getCourseListUseCase,
            flowActions: self.flowActions,
            queryType: .registered
        )
    }()
    
    init(
        getCourseListUseCase: GetCourseListUseCase,
        flowActions: MainFlowCoordinateActions? = nil
    ) {
        self.getCourseListUseCase = getCourseListUseCase
        self.flowActions = flowActions
    }
}

// MARK: - Implement Reactor

extension HomeViewReactor: Reactor {
    var initialState: State {
        State()
    }
    
    struct State {}
    
    enum Action {
        case none
        case viewDidLoad
    }
    
    enum Mutation {
        case none
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad: 
            self.recommendListReactor.action.onNext(.viewDidLoad)
            self.freeListReactor.action.onNext(.viewDidLoad)
            self.registeredListReactor.action.onNext(.viewDidLoad)
            return .just(.none)
        default:
            return .just(.none)
        }
    }
}
