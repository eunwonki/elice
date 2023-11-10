//
//  AppFlowCoordinator.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation
import UIKit

final class AppFlowCoordinator {
    private let appDIContainer: AppDIContainer
    private let navigationController: UINavigationController
    
    init(
        appDIContainer: AppDIContainer,
        navigationController: UINavigationController
    ) {
        self.appDIContainer = appDIContainer
        self.navigationController = navigationController
    }
    
    func start() {
        let mainSceneDIContainer = appDIContainer.makeMainSceneDIContainer()
        let flow = mainSceneDIContainer.makeMainFlowCoordinator(
            navigationController: navigationController
        )
        flow.start()
    }
}
