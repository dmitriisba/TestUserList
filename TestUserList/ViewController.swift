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
    var avaCache: [UIImage] = []
    let userCellIdentifier = "UserCell"

    override func loadView() {
        super.loadView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.register(UserImagesTableViewCell.self, forCellReuseIdentifier: userCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ApiClient.shared.getUsers(offset: 0, success: { [weak self] (response) in
            guard let userResponse = response as? UsersListResponse else { return }
            self?.userData = userResponse.users
            self?.tableView.reloadData()
        }, failure: { error in
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
        
        ImageDownloader.getImageFromWebPath(user.imagePath) { [weak cell] (image) in
            guard let _cell = cell, _cell.tag == indexPath.row else { return }
            cell?.avatarImageView.image = image
        }
        
        cell.tag = indexPath.row
        return cell
    }


}

