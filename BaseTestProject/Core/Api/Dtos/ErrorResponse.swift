//
//  ErrorResponse.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import Foundation

public class ErrorResponse: Codable, Error {
    public let code: Int
    public let message: String
    public let stackTrace: String
    
    public init(code: Int, message: String, stackTrace: String) {
        self.code = code
        self.message = message
        self.stackTrace = stackTrace
    }
}
