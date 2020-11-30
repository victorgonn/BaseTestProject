//
//  EnviromentUtils.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 30/11/20.
//

import Foundation

public enum EnvironmentType: String {
    case development
    case homologation
    case production
}

public enum EnvironmentUtils {
    enum PListKey: String {
        case enviroment         = "Enviroment"
        case baseUrl            = "BaseUrl"
        case httpScheme         = "HttpScheme"
    }

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    public static let enviroment: EnvironmentType = {
        let key = PListKey.enviroment.rawValue
        guard let value = EnvironmentUtils.infoDictionary[key] as? String else {
            fatalError("\(key) key not set in plist file.")
        }
        guard let environmentType = EnvironmentType(rawValue: value) else {
            return .development
        }
        return environmentType
    }()
    

    public static let baseUrl: String = {
        let key = PListKey.baseUrl.rawValue
        guard let value = EnvironmentUtils.infoDictionary[key] as? String else {
            fatalError("\(key) key not set in plist file.")
        }
        let httpSchemeKey = PListKey.httpScheme.rawValue
        guard let httpScheme = EnvironmentUtils.infoDictionary[httpSchemeKey] as? String else {
            fatalError("\(httpSchemeKey) key not set in plist file.")
        }
        return "\(httpScheme)://\(value)"
    }()
}
