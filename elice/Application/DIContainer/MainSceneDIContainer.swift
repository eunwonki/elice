//
//  MainSceneDIContainer.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation
import UIKit

final class MainSceneDIContainer: MainFlowCoordinatorDependencies {
    struct Dependencies {}
    
    // MARK: - Home
    
    func makeHomeViewController() -> HomeViewController {
        HomeViewController.create()
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
