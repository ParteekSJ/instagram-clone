//
//  UserCell.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/24/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

class UserCell : UITableViewCell {
    //MARK: - Properties
    var user : User? {
        didSet {
            configureCellUser()
        }
    }
    
    private var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemPink
        iv.setDimensions(width: 44, height: 44)
        iv.layer.cornerRadius = 44 / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14.5)
        label.text = "username"
        return label
    }()
    
    private let fullnameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.5)
        label.text = "fullname"
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style : style, reuseIdentifier : reuseIdentifier)
        configureCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - API
    
    //MARK: - Selectors
    
    //MARK: - Helpers
    func configureCellUI() {
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self)
        profileImageView.anchor(left : leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: self)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
    }
    
    func configureCellUser() {
        guard let user = user else { return }
        let viewModel = UserCellViewModel(user: user)
        profileImageView.sd_setImage(with: URL(string: viewModel.profileImageURL))
        fullnameLabel.text = viewModel.fullName
        usernameLabel.text = viewModel.username
    }
}
