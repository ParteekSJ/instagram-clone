//
//  FeedCell.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/22/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

protocol FeedCellDelegate : class {
    func cell(_ cell : FeedCell, wantsToShowCommentsFor post : Post)
    func cell(_ cell : FeedCell, didLike post : Post)
    func cell(_ cell : FeedCell, wantsToShowProfileFor uid : String)
}

class FeedCell : UICollectionViewCell {
    //MARK: - Properties
    var post : Post? {
        didSet { configurePost() }
    }
    
    weak var delegate : FeedCellDelegate?
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .systemPink
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        return iv
    }()
    
    private lazy var usernameButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(usernameTapped), for: .touchUpInside)
        return button
    }()
    
    private let postImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var likeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let likesLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private let captionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private let postTimeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "2 days ago"
        return label
    }()
    
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame : frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - API
    
    //MARK: - Selectors
    @objc func usernameTapped() {
        guard let post = post else { return }
        print("POSTTT - \(post)")
        delegate?.cell(self, wantsToShowProfileFor: post.owneruid)
        print("POST UID - \(post.owneruid)")
    }
    
    @objc func likeButtonTapped() {
        guard let post = post else { return }
        delegate?.cell(self, didLike: post)
    }
    
    @objc func commentButtonTapped() {
        guard let post = post else { return }
        delegate?.cell(self, wantsToShowCommentsFor: post)
    }
    
    @objc func shareButtonTapped() {
        print("DEBUG : ShareButtonTap...")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top : topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView)
        usernameButton.anchor(left : profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(postImageView)
        postImageView.anchor(top : profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        let actionStack = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        actionStack.axis = .horizontal
        actionStack.distribution = .fillEqually
        
        addSubview(actionStack)
        actionStack.anchor(top : postImageView.bottomAnchor, width: 120, height: 50)
        
        addSubview(likesLabel)
        likesLabel.anchor(top : actionStack.bottomAnchor, left: leftAnchor, paddingTop: -4, paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top : likesLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top : captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)

    }
    
    func configurePost() {
        guard let post = post else { return }
        let viewModel = PostViewModel(post: post)
        
        postImageView.sd_setImage(with: URL(string: viewModel.postImageUrl))
        captionLabel.attributedText = viewModel.attributedCaption(username: viewModel.username, caption: viewModel.postCaption)
        likesLabel.text = "\(viewModel.likesLabelText)"
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        usernameButton.setTitle(viewModel.username, for: .normal)
        profileImageView.sd_setImage(with: URL(string: viewModel.userProfileImageUrl))
    }
    

    

}
