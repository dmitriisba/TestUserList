//
//  ImageDownloader.swift
//  TestUserList
//
//  Created by Yushko Dmitry on 6/6/19.
//  Copyright © 2019 Yushko Dmitry. All rights reserved.
//

import UIKit
import Alamofire

class ImageDownloader {
    
    static func getImageFromWebPath(_ webPath: String, completion: @escaping (_ image: UIImage?) -> Void) {
        AF.request(webPath).responseData { response in
            switch(response.result) {
            case .success(let data):
                let image = UIImage(data: data)
                completion(image)
                
            case .failure(_):
                completion(nil)
            }
        }
        
    }
    
}
