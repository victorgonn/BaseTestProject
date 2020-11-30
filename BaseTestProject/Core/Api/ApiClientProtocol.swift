//
//  ApiClient.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 26/11/20.
//

import Alamofire
import Promises

protocol ApiClient { }

extension ApiClient {
    @discardableResult
    public static func performRequest<T: Decodable>(
        route: URLRequestConvertible,
        decoder: JSONDecoder = JSONDecoder(),
        completion: @escaping (Result<T, ErrorResponse>) -> Void) -> DataRequest {

        return AF.request(route)
            .validate(statusCode: 200..<300)
            .responseDecodable(decoder: decoder) { (response: DataResponse<T, AFError>) in
                let result = response.result.mapError( { error -> ErrorResponse in

                    guard let data = response.data else {
                        return ErrorResponse(code: 0, message: "Parse error", stackTrace: "Generic error")
                    }

                    let decoder = JSONDecoder()
                    guard let error = try? decoder.decode(ErrorResponse.self, from: data) else {
                        return ErrorResponse(code: 0, message: "Parse error", stackTrace: "Generic error")
                    }

                    return error
                })

                Self.updateUserData(headerData: response.response?.allHeaderFields)
                completion(result)
        }
    }

    public static func performRequestAsync<T: Decodable>(route: URLRequestConvertible,
                                                         decoder: JSONDecoder = JSONDecoder()) -> Promise<T> {
        return Promise<T> { fulfill, reject in
            AF.request(route)
                .validate(statusCode: 200..<300)
                .responseDecodable(decoder: decoder) { (response: DataResponse<T, AFError>) in
                    let result = response.result.mapError( { error -> ErrorResponse in
                        
                        guard let data = response.data else {
                            return ErrorResponse(code: 0, message: "Parse error", stackTrace: "Generic error")
                        }
                        
                        let decoder = JSONDecoder()
                        guard let error = try? decoder.decode(ErrorResponse.self, from: data) else {
                            return ErrorResponse(code: 0, message: "Parse error", stackTrace: "Generic error")
                        }
                        
                        return error
                    })

                    Self.updateUserData(headerData: response.response?.allHeaderFields)
                    switch result {
                    case .success(let data):
                        fulfill(data)
                    case .failure(let error):
                        reject(error)
                    }
            }
        }
    }
    
    public static func performRequestAsync(route: URLRequestConvertible) -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            AF.request(route)
                .validate(statusCode: 200..<300)
                .response { (response: DataResponse<Data?, AFError>) in
                    let result = response.result.mapError( { error -> ErrorResponse in

                        guard let data = response.data else {
                            return ErrorResponse(code: 0, message: "Parse error", stackTrace: "Generic error")
                        }
                        let decoder = JSONDecoder()
                        guard let error = try? decoder.decode(ErrorResponse.self, from: data) else {
                            return ErrorResponse(code: 0, message: "Parse error", stackTrace: "Generic error")
                        }

                        return error
                    })
                    Self.updateUserData(headerData: response.response?.allHeaderFields)
                    switch result {
                    case .success:
                        fulfill(Void())
                    case .failure(let error):
                        reject(error)
                    }
                    
            }
        }
    }
    
    
    public static func updateUserData(headerData: [AnyHashable : Any]?) {
        if let header = headerData as? [String: Any] {
            for (key, value) in header {
                switch key {
                case "access-token":
                    debugPrint("token:", value)
                    if let token = value as? String {
                        UserDefaultsUtils.saveAccessToken(value: token)
                    }
                case "uid":
                    debugPrint("uid:", value)
                    if let uid = value as? String {
                        UserDefaultsUtils.saveUid(value: uid)
                    }
                case "client":
                    debugPrint("client:", value)
                    if let client = value as? String {
                        UserDefaultsUtils.saveClient(value: client)
                    }
                default:
                    break
                }
            }
        }
    }
}
