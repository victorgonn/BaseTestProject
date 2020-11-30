//
//  ServiceApiClient.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 30/11/20.
//

import Foundation
import Promises
import Alamofire

class ServiceApiClient: ApiClient {
    static func doLogin(request: LoginRequest) -> Promise<Void> {
        return performRequestAsync(route: ServiceEndpoint.login(request: request))
    }
    
    static func getEnterpriseIndex(request: EnterpriseIndexRequest) -> Promise<EnterpriseIndexResponse> {
        return performRequestAsync(route: ServiceEndpoint.enterpriseIndex(request: request))
    }
    
    static func getEnterprise(request: Int) -> Promise<EnterpriseResponse> {
        return performRequestAsync(route: ServiceEndpoint.enterprise(request: request))
    }
}

