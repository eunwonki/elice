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
    
    // MARK: - Home
    
    func makeHomeViewController() -> HomeViewController {
        HomeViewController.create(with: makeHomeViewReactor())
    }
    
    func makeHomeViewReactor() -> HomeViewReactor {
        HomeViewReactor(getCourseListUseCase: makeGetCourseListUseCase())
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
