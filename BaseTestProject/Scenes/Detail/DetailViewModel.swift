//
//  DetailViewModel.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 30/11/20.
//

import Foundation
import Promises

class DetailViewModel {
    var enterpriseId: Int = 0
    var headerColor: UIColor?
    var enterprise: Enterprise?
    
    func getEnterpriseData() -> Promise<EnterpriseResponse> {
        return ServiceApiClient.getEnterprise(request: enterpriseId)
    }
}
