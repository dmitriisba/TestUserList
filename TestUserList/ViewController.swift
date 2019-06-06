//
//  ViewController.swift
//  TestUserList
//
//  Created by Yushko Dmitry on 6/6/19.
//  Copyright © 2019 Yushko Dmitry. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView = UITableView(frame: .zero)
    var userData: [User] = []
    let userCellIdentifier = "UserCell"
    var contentOffset = 0
    var isAvailableMore = false
    var infiniteScrollCoof = 3
    var isContentLoadingStarted = false
    
    // MARK: - UIViewConroller

    override func loadView() {
        super.loadView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.register(UserImagesTableViewCell.self, forCellReuseIdentifier: userCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UIScreen.main.bounds.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getUsersListWithOffset(contentOffset)
    }
    
    // MARK: - Requests
    
    func getUsersListWithOffset(_ offset: Int) {
        isContentLoadingStarted = true
        ApiClient.shared.getUsers(offset: offset, success: { [weak self] (response) in
            guard let _self = self, let userResponse = response as? UsersListResponse else { return }
            _self.isContentLoadingStarted = false
            _self.contentOffset += ApiClient.defaultLimit
            _self.isAvailableMore = userResponse.isAvailableMore
            if _self.userData.isEmpty {
                _self.userData = userResponse.users
            } else {
                _self.userData.append(contentsOf: userResponse.users)
            }
            _self.tableView.reloadData()
        }, failure: { [weak self] error in
            self?.isContentLoadingStarted = false
            print(error)
        })
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellIdentifier, for: indexPath) as! UserImagesTableViewCell
        
        let user = userData[indexPath.row]
        cell.nameLabel.text = user.name
        
        if let image = user.avaImage {
            cell.avatarImageView.image = image
        } else {
            ImageDownloader.getImageFromWebPath(user.avaImagePath) { [weak cell, weak self] (image) in
                guard let _self = self, indexPath.row <= _self.userData.count else { return }
                var user = _self.userData[indexPath.row]
                user.avaImage = image
                _self.userData[indexPath.row] = user
                guard let _cell = cell, _cell.tag == indexPath.row else { return }
                cell?.avatarImageView.image = image
            }
        }
        
        let containerHeight = calculateHeigthForContentSize(user.contentImagesPath.count)
        cell.imagesContainer.snp.updateConstraints { (update) in
            update.height.equalTo(containerHeight).priority(999)
        }
        
        let contentViews = cell.imagesContainer.configureContainerWithSize(user.contentImagesPath.count)
        
        for (index, item) in contentViews.enumerated() {
            if let image = user.contentImages[index] {
                item.image = image
            } else {
                let path = user.contentImagesPath[index]
                ImageDownloader.getImageFromWebPath(path) { [weak self, weak item] (image) in
                    guard let _self = self, indexPath.row <= _self.userData.count else { return }
                    var user = _self.userData[indexPath.row]
                    user.contentImages[index] = image
                    _self.userData[indexPath.row] = user
                    item?.image = image
                }
            }
        }
        
        cell.tag = indexPath.row
        cell.contentView.setNeedsLayout()
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isAvailableMore && !isContentLoadingStarted else { return }
        if indexPath.row == userData.count - infiniteScrollCoof {
            #if DEBUG
            print("Start load content more")
            #endif
            getUsersListWithOffset(contentOffset)
        }
    }

    // MARK: - Helpers
    
    func calculateHeigthForContentSize(_ size: Int) -> CGFloat {
        let isEven = (size % 2) == 0
        var result: CGFloat = 0
        let cellMargins: CGFloat = 16
        let rows = isEven ? Int(size / 2) : Int(size / 2) + 1
        let heightEvenRow = ((UIScreen.main.bounds.width - (cellMargins + ImagesContainer.defaultMargin)) / 2) + (ImagesContainer.defaultMargin * 2)
        let heightOddRow = UIScreen.main.bounds.width - cellMargins + (ImagesContainer.defaultMargin * 2)
        if isEven {
            result = CGFloat(rows) * heightEvenRow
        } else {
            result = (CGFloat(rows - 1) * heightEvenRow) + heightOddRow
        }
        return result
    }

}

