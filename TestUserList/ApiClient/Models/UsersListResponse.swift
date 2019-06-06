//
//  BaseResponse.swift
//  TestUserList
//
//  Created by Yushko Dmitry on 6/6/19.
//  Copyright © 2019 Yushko Dmitry. All rights reserved.
//

import Foundation

struct UsersListResponse: Decodable {
    var users: [User]
    var isAvailableMore: Bool
    
    enum CodingKeys: String, CodingKey {
        case users
        case isAvailableMore = "has_more"
    }
    
    init(from decoder: Decoder) throws {
        let baseContainer = try decoder.container(keyedBy: BaseResponse.CodingKeys.self)
        let userContainer = try baseContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        users = try userContainer.decode([User].self, forKey: .users)
        isAvailableMore = try userContainer.decode(Bool.self, forKey: .isAvailableMore)
    }
}
