//
//  EnterpriseDto.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 30/11/20.
//

import Foundation

struct EnterpriseIndexRequest: Codable {
    var type: String
    var name: String
}

struct EnterpriseType: Codable {
    var id: Int
    var enterprise_type_name: String
}

struct EnterpriseIndexResponse: Codable {
    var enterprises: [Enterprise]
}

struct Enterprise: Codable {
    var id: Int
    var photo: String
    var description: String
    var phone: String?
    var share_price: Double?
    var enterprise_type: EnterpriseType?
    var linkedin: String?
    var value: Int
    var email_enterprise: String?
    var city: String?
    var enterprise_name: String?
    var facebook: String?
    var country: String?
    var twitter: String?
    var own_enterprise: Bool
}

struct EnterpriseResponse: Codable {
    var enterprise: Enterprise
    var success: Bool
}
