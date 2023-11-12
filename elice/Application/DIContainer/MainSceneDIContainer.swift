//
//  MainSceneDIContainer.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation
import UIKit

final class MainSceneDIContainer: MainFlowCoordinatorDependencies {
    struct Dependencies {
        let eliceApiService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    
    lazy var courseStorage: RegisteredCourseStorage = CoreDataRegisteredCourseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repository
    
    func makeCourseRepository() -> CourseRepository {
        DefaultCourseRepository(
            eliceApiService: dependencies.eliceApiService,
            persistentStore: courseStorage
        )
    }
    
    // MARK: - UseCase
    
    func makeGetCourseListUseCase() -> GetCourseListUseCase {
        DefaultGetCourseListUseCase(repository: makeCourseRepository())
    }
    
    func makeGetCourseUseCase() -> GetCourseUseCase {
        DefaultGetCourseUseCase(repository: makeCourseRepository())
    }
    
    func makeRegisterCourseUseCase() -> RegisterCourseUseCase {
        DefaultRegisterCourseUseCase(repository: makeCourseRepository())
    }
    
    // MARK: - Home
    
    func makeHomeViewController(
        flowActions: MainFlowCoordinateActions
    ) -> HomeViewController {
        HomeViewController.create(
            with: makeHomeViewReactor(
                flowActions: flowActions
            )
        )
    }
    
    func makeHomeViewReactor(
        flowActions: MainFlowCoordinateActions
    ) -> HomeViewReactor {
        HomeViewReactor(
            getCourseListUseCase: makeGetCourseListUseCase(),
            flowActions: flowActions
        )
    }
    
    // MARK: - Cours Detail
    
    func makeCourseDetailViewController(
        id: String
    ) -> CourseDetailViewController {
        CourseDetailViewController.create(
            with: makeCourseDetailViewReactor(id: id)
        )
    }
    
    func makeCourseDetailViewReactor(
        id: String
    ) -> CourseDetailViewReactor {
        CourseDetailViewReactor(
            courseId: id,
            getCourseUseCase: makeGetCourseUseCase(),
            registerCourseUseCase: makeRegisterCourseUseCase()
        )
    }
    
    // MARK: - Flows
    
    func makeMainFlowCoordinator(
        navigationController: UINavigationController
    ) -> MainFlowCoordinator {
        MainFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
