//
//  User.swift
//  TestUserList
//
//  Created by Yushko Dmitry on 6/6/19.
//  Copyright © 2019 Yushko Dmitry. All rights reserved.
//

import UIKit

struct User: Decodable {
    var name: String
    var avaImagePath: String
    var avaImage: UIImage?
    var contentImagesPath: [String]
    var contentImages: [UIImage?]
    
    enum CodingKeys: String, CodingKey {
        case name
        case avaImagePath = "image"
        case contentImagePaths = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        avaImagePath = try container.decode(String.self, forKey: .avaImagePath)
        contentImagesPath = try container.decode([String].self, forKey: .contentImagePaths)
        contentImages = Array<UIImage?>(repeating: nil, count: contentImagesPath.count)
    }
}
