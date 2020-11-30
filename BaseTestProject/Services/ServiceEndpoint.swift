//
//  ServicesEndPoints.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 30/11/20.
//

import Foundation
import Alamofire

enum ServiceEndpoint: ApiConfiguration {
    case login(request: LoginRequest)
    case enterpriseIndex(request: EnterpriseIndexRequest)
    case enterprise(request: Int)

    
    var baseUrl: String {
        return EnvironmentUtils.baseUrl
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .enterpriseIndex, .enterprise:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/v1/users/auth/sign_in"
        case .enterpriseIndex:
            return "/api/v1/enterprises"
        case .enterprise(let id):
            return "/api/v1/enterprises/\(id)"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .enterpriseIndex(let request):
            var paramenters : [String : Any] = [String : Any]()
            if !request.type.isEmpty {
                paramenters.updateValue(request.type, forKey: "enterprise_types")
            }
            if !request.name.isEmpty {
                paramenters.updateValue(request.name, forKey: "name")
            }
            return paramenters
        default:
            return nil
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .login(let request):
            return try? JSONEncoder().encode(request)
        default:
            return nil
        }
        
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .enterpriseIndex, .enterprise:
            return ["access-token": UserDefaultsUtils.getAccessToken() ?? "",
                    "client" : UserDefaultsUtils.getClient() ?? "",
                    "uid" : UserDefaultsUtils.getUid() ?? ""]
        default:
            return nil
        }
    }
}
