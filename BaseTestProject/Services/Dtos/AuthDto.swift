//
//  AuthDto.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 30/11/20.
//

import Foundation

struct LoginRequest: Codable {
    var email: String
    var password: String
}
