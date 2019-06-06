//
//  ImagesContainer.swift
//  TestUserList
//
//  Created by Yushko Dmitry on 6/6/19.
//  Copyright © 2019 Yushko Dmitry. All rights reserved.
//

import UIKit

class ImagesContainer: UIView {
    
    static let defaultMargin: CGFloat = 8
    
    func configureContainerWithSize(_ totalImages: Int) -> [UIImageView] {
        if subviews.count != 0 {
            resetContainer()
        }
        
        let isEven = (totalImages % 2) == 0
        var lastItem: UIView = self
        var contentViews: [UIImageView] = []
        
        for index in 0..<totalImages {
            
            let imageView = UIImageView()
            imageView.backgroundColor = .lightGray
            addSubview(imageView)
            var isIndexEven = (index % 2) == 0
            
            if index == 0 {
                if !isEven {
                    imageView.snp.makeConstraints { (make) in
                        make.leading.equalToSuperview()
                        make.trailing.equalToSuperview()
                        make.height.equalTo(imageView.snp.width)
                        make.top.equalToSuperview().offset(ImagesContainer.defaultMargin)
                    }
                } else {
                    imageView.snp.makeConstraints { (make) in
                        make.leading.equalToSuperview()
                        make.width.equalToSuperview().multipliedBy(0.5).offset(-(ImagesContainer.defaultMargin / 2))
                        make.height.equalTo(imageView.snp.width)
                        make.top.equalToSuperview().offset(ImagesContainer.defaultMargin)
                    }
                }
                
            } else {
                
                if !isEven {
                    isIndexEven = !isIndexEven
                }
                
                var leadingOffset: CGFloat = 0
                var leadingItem = self.snp.leading
                if !isIndexEven {
                    leadingOffset = ImagesContainer.defaultMargin
                    leadingItem = lastItem.snp.trailing
                }
                
                imageView.snp.makeConstraints { (make) in
                    make.leading.equalTo(leadingItem).offset(leadingOffset)
                    make.width.equalToSuperview().multipliedBy(0.5).offset(-4)
                    make.height.equalTo(imageView.snp.width)
                    if isIndexEven {
                        make.top.equalTo(lastItem.snp.bottom).offset(ImagesContainer.defaultMargin)
                    } else {
                        make.centerY.equalTo(lastItem.snp.centerY)
                    }
                }
            }
            lastItem = imageView
            contentViews.append(imageView)
        }
        
        return contentViews
    }
    
    func resetContainer() {
        subviews.forEach({ $0.removeFromSuperview() })
    }

}
