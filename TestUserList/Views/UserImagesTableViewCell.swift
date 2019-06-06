//
//  UserImagesTableViewCell.swift
//  TestUserList
//
//  Created by Yushko Dmitry on 6/6/19.
//  Copyright © 2019 Yushko Dmitry. All rights reserved.
//

import UIKit
import SnapKit

class UserImagesTableViewCell: UITableViewCell {
    
    let avatarImageView = UIImageView(frame: .zero)
    let nameLabel = UILabel(frame: .zero)
    let imagesContainer = ImagesContainer(frame: .zero)
    static let avatarSize: CGFloat = 40
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        constructor()
    }
    
    func constructor() {
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(UserImagesTableViewCell.avatarSize)
            make.height.equalTo(UserImagesTableViewCell.avatarSize)
        }
        avatarImageView.layer.cornerRadius = UserImagesTableViewCell.avatarSize / 2
        avatarImageView.layer.masksToBounds = true
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalTo(avatarImageView.snp.centerY)
        }
        nameLabel.numberOfLines = 1
        
        contentView.addSubview(imagesContainer)
        imagesContainer.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(8)
        }
    }

}
