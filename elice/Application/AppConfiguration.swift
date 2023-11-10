//
//  AppConfiguration.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation

final class AppConfiguration {
    lazy var eliceApiBaseUrl: String = {
        guard let eliceApiBaseUrl = Bundle.main.object(forInfoDictionaryKey: "EliceApiBaseUrl") as? String else {
            fatalError("Aqicn Api Base Url Key must not be empty in plist")
        }
        return eliceApiBaseUrl
    }()
}
