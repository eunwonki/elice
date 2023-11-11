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
    private let pageSize = 10
    
    init(getCourseListUseCase: GetCourseListUseCase) {
        self.getCourseListUseCase = getCourseListUseCase
    }
}

// MARK: - Implement Reactor

extension HomeViewReactor: Reactor {
    var initialState: State {
        State()
    }
    
    struct State {
        var list: [Course] = .init()
    }
    
    enum Action {
        case none
        case viewDidAppear
    }
    
    enum Mutation {
        case none
        case courseListLoaded(list: [Course])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidAppear: 
            return onViewDidAppear()
        default:
            return .just(.none)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .courseListLoaded(list):
            print(list)
            state.list = list
        default: break
        }
        return state
    }
}

// MARK: - Private

extension HomeViewReactor {
    
    private func onViewDidAppear() -> Observable<Mutation> {
        Observable
            .merge(
                getCourseListUseCase.execute(
                    query: .recommend, offset: 0, size: pageSize),
                getCourseListUseCase.execute(
                    query: .free, offset: 0, size: pageSize),
                getCourseListUseCase.execute(
                    query: .registered, offset: 0, size: pageSize)
            )
            .map {
                return .courseListLoaded(list: $0)
            }
    }
    
}
