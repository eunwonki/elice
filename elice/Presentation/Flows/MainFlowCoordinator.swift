//
//  MainFlowCoordinator.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation
import UIKit

protocol MainFlowCoordinatorDependencies {
    func makeHomeViewController(
        flowActions: MainFlowCoordinateActions
    ) -> HomeViewController
    func makeCourseDetailViewController(
        id: String
    ) -> CourseDetailViewController
}

final class MainFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MainFlowCoordinatorDependencies
    private var flowActions: MainFlowCoordinateActions!
    
    private weak var homeView: HomeViewController?
    
    init(
        navigationController: UINavigationController?,
        dependencies: MainFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        flowActions = MainFlowCoordinateActions(
            showCourseDetail: showCourseDetailView
        )
        
        let vc = dependencies.makeHomeViewController(
            flowActions: flowActions
        )
        navigationController?.pushViewController(vc, animated: false)
        navigationController?.navigationBar.isHidden = true
        homeView = vc
    }
    
    func showCourseDetailView(courseId: String) {
        let view = dependencies.makeCourseDetailViewController(id: courseId)
        navigationController?.pushViewController(view, animated: true)
    }
}
