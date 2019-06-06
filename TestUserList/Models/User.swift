//
//  User.swift
//  TestUserList
//
//  Created by Yushko Dmitry on 6/6/19.
//  Copyright © 2019 Yushko Dmitry. All rights reserved.
//

import Foundation

struct User: Decodable {
    var name: String
    var imagePath: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case imagePath = "image"
    }
}
