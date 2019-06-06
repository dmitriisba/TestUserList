//
//  ApiClient.swift
//  TestUserList
//
//  Created by Yushko Dmitry on 6/6/19.
//  Copyright © 2019 Yushko Dmitry. All rights reserved.
//

import UIKit
import Alamofire

class ApiClient {

    static let shared = ApiClient()
    static let defaultLimit = 10
    private let baseDecoder = JSONDecoder()
    
    func getUsers(offset: Int, limit: Int = ApiClient.defaultLimit,
                  success: @escaping (_ response: Any?) -> Void,
                  failure: @escaping (_ error: Error) -> Void) {
        let request = ApiRouter.getUsers(offset, limit: limit)
        sendRequest(request, success: success, failure: failure)
    }
    
    private func sendRequest(_ request: ApiRouter, success: @escaping (_ responseData: Any?) -> Void, failure: @escaping (_ error: Error) -> Void) {
        
        AF.request(request).validate(statusCode: 200..<300).responseData { [weak self] (response) in
            guard let _self = self else { return }
            switch(response.result) {
            case .success(let data):
                
                #if DEBUG
                print(String(data: data, encoding: .utf8) ?? "")
                #endif
                
                var result: Any?
                
                do {
                    let base = try _self.baseDecoder.decode(BaseResponse.self, from: data)
                    guard base.status else { throw ApiClientError.failureResponse }
                    
                    switch request {
                    case .getUsers:
                        let usersList = try _self.baseDecoder.decode(UsersListResponse.self, from: data)
                        result = usersList
                    }
                    success(result)
                } catch let error as ApiClientError {
                    failure(error)
                } catch {
                    failure(ApiClientError.failureResponse)
                }
        
            case .failure:
                failure(ApiClientError.failureResponse)
            }
        }
    }
}
