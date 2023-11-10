//
//  MainFlowCoordinator.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation
import UIKit

protocol MainFlowCoordinatorDependencies {
    func makeHomeViewController() -> HomeViewController
}

final class MainFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MainFlowCoordinatorDependencies
    
    private weak var homeView: HomeViewController?
    
    init(
        navigationController: UINavigationController?,
        dependencies: MainFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeHomeViewController()
        navigationController?.pushViewController(vc, animated: false)
        navigationController?.navigationBar.isHidden = true
        homeView = vc
    }
}
