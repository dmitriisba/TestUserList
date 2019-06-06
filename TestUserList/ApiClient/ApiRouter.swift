//
//  ApiRouter.swift
//  TestUserList
//
//  Created by Yushko Dmitry on 6/6/19.
//  Copyright © 2019 Yushko Dmitry. All rights reserved.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    static let baseURL = "http://sd2-hiring.herokuapp.com/api/"
    
    case getUsers(_ offset: Int, limit: Int)
    
    var method: HTTPMethod {
        switch self {
        case .getUsers:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return "users"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try ApiRouter.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .getUsers(let offset, let limit):
            let parametrs = [
                "offset": offset,
                "limit": limit
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametrs)

        }
        
        return urlRequest
    }
    
}
