//
//  ProfileHeader.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/23/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

protocol ProfileHeaderDelegate : class {
    //user - User displayed in the ProfileHeader
    func header(_ profileHeader : ProfileHeader, didTapActionButtonFor user : User)
}

class ProfileHeader : UICollectionReusableView {
    
    //MARK: - Properties
    
    var user : User? {
        didSet { configureUser() }
    }
    
    weak var delegate : ProfileHeaderDelegate?
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        iv.setDimensions(width: 80, height: 80)
        iv.layer.cornerRadius = 80 / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var editProfileButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading..", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.75
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private lazy var postsLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStackText(value: "20", label: "Posts")
        return label
    }()
    
    private lazy var followersLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStackText(value: "125", label: "Followers")
        return label
    }()
    
    private lazy var followingLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStackText(value: "125", label: "Following")
        return label
    }()
    
    private let gridButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        return button
    }()
    
    private let listButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    private let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let topDivider : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.setHeight(height: 0.75)
        return view
    }()
    
    let bottomDivider : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.setHeight(height: 0.75)
        return view
    }()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame : frame)
        configureUI()
    }
    
    init(user : User) {
        super.init(frame : .zero)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - API
    
    //MARK: - Selectors
    @objc func handleEditProfileFollow() {
        guard let user = user else { return }
        delegate?.header(self, didTapActionButtonFor: user)
    }
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top : topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
            
        addSubview(nameLabel)
        nameLabel.anchor(top : profileImageView.bottomAnchor, left : leftAnchor, paddingTop: 13, paddingLeft: 13)
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top : nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 24, paddingRight: 24)
        
        let stack = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stack.distribution = .fillEqually
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left : profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12, height: 50)
        
        let buttonStack = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.setHeight(height: 50)
        
        let finalStack = UIStackView(arrangedSubviews: [topDivider, buttonStack, bottomDivider])
        addSubview(finalStack)
        finalStack.axis = .vertical
        finalStack.anchor(left : leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    func attributedStackText(value : String, label : String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)])
        attributedText.append(NSAttributedString(string: label, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12.5), NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        return attributedText
    }
    
    func configureUser() {
        guard let user = user else { return }
        let viewModel = ProfileHeaderViewModel(user: user)
        profileImageView.sd_setImage(with: URL(string: viewModel.profileImageURL), completed: nil)
        nameLabel.text = viewModel.fullname
        
        editProfileButton.setTitle(viewModel.followButtonText, for: .normal)
        editProfileButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        editProfileButton.backgroundColor = viewModel.followButtonBackgroundColor
        
        postsLabel.attributedText = viewModel.numberOfPosts
        followersLabel.attributedText = viewModel.followersCount
        followingLabel.attributedText = viewModel.followingCount
        
    }
    
    
}
