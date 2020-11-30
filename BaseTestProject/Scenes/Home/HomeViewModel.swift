//
//  HomeViewModel.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 30/11/20.
//

import Foundation
import Promises

class HomeViewModel {
    var searchString: String = ""
    var filtredData: [Enterprise] = []
    var searched: Bool = false
    
    func getEnterprises() -> Promise<EnterpriseIndexResponse> {
        let request = EnterpriseIndexRequest(type: "", name: self.searchString)
        return ServiceApiClient.getEnterpriseIndex(request: request)
    }
}
