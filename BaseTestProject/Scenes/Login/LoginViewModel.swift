//
//  LoginViewModel.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import Foundation
import Promises

class LoginViewModel {
    var email: String = ""
    var password: String = ""
    
    func doLogin() -> Promise<Void> {
        let request = LoginRequest(email: self.email, password: self.password)
        return ServiceApiClient.doLogin(request: request)
    }
}
