//
//  AppDIContainer.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network Service
    
    lazy var eliceDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.eliceApiBaseUrl)!
        )
        return DefaultDataTransferService(with: config)
    }()
    
    // MARK: - DIContainers of scenes
    
    func makeMainSceneDIContainer() -> MainSceneDIContainer {
        MainSceneDIContainer(
            dependencies: .init(
                eliceApiService: eliceDataTransferService
            )
        )
    }
    
}
