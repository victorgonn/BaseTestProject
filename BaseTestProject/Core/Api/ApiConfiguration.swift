//
//  ApiConfiguration.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import Foundation
import Alamofire

protocol ApiConfiguration: URLRequestConvertible {
    var baseUrl: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var httpBody: Data? { get }
    var headers: HTTPHeaders? { get }
}

extension ApiConfiguration where Self: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Common Headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let headers = headers {
            for entry in headers {
                urlRequest.setValue(entry.value, forHTTPHeaderField: entry.name)
            }
        }
        
        // Specific header values
//        urlRequest.setValue(DeviceStorage.shared.geo?.latitude ?? "0", forHTTPHeaderField: "Latitude")
//        urlRequest.setValue(DeviceStorage.shared.geo?.longitude ?? "0", forHTTPHeaderField: "Longitude")
//        urlRequest.setValue(DeviceStorage.shared.device.id, forHTTPHeaderField: "Device")

        // Parameters
        if let parameters = parameters {
            do {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        urlRequest.httpBody = self.httpBody
        
        return urlRequest
    }
}
