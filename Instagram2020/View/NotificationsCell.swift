//
//  NotificationsCell.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/26/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

protocol NotificationCellDelegate : class {
    func cell(_ cell : NotificationsCell, wantsToFollow uid : String)
    func cell(_ cell : NotificationsCell, wantsToUnfollow uid : String)
    func cell(_ cell : NotificationsCell, wantsToViewPost postId : String)
}

class NotificationsCell : UITableViewCell {
    //MARK: - Properties
    var notification : Notification? {
        didSet { configureNotification() }
    }
    
    weak var delegate : NotificationCellDelegate?
    
    private var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemPink
        iv.setDimensions(width: 44, height: 44)
        iv.layer.cornerRadius = 44 / 2
        iv.clipsToBounds = true
        return iv
    }()

    private let infoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14.5)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var postImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGreen
        iv.setDimensions(width: 44, height: 44)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    private lazy var followButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading..", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.75
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        button.setDimensions(width: 88, height: 32)
        button.isHidden = true
        
        return button
    }()
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style : style, reuseIdentifier : reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self)
        profileImageView.anchor(left : leftAnchor, paddingLeft: 12)
        
        contentView.addSubview(postImageView)
        postImageView.anchor()
        postImageView.centerY(inView: self)
        postImageView.anchor(right : rightAnchor, paddingRight: 12)
    
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right : rightAnchor, paddingRight: 12)
        
        contentView.addSubview(infoLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - API
    
    //MARK: - Selectors
    @objc func handleFollowTapped() {
        guard let notification = notification else { return }
        if notification.userIsFollowed {
            delegate?.cell(self, wantsToUnfollow: notification.uid)
        } else {
            delegate?.cell(self, wantsToFollow: notification.uid)
        }
    }
    
    @objc func handlePostTapped() {
        guard let postID = notification?.postID else { return }
        delegate?.cell(self, wantsToViewPost: postID)
    }
    
    //MARK: - Helpers
    func configureNotification() {
        guard let notification = notification else { return }
        let viewModel = NotificationViewModel(notification: notification)
        
        profileImageView.sd_setImage(with: URL(string: viewModel.profileImageUrl))
        postImageView.sd_setImage(with: URL(string: viewModel.postImageURL))
        infoLabel.attributedText = viewModel.notificationMessage
        
        followButton.isHidden = !viewModel.shouldHidePostImage
        postImageView.isHidden = viewModel.shouldHidePostImage
        
        if notification.type == NotificationType.follow {
            infoLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
            infoLabel.anchor(right : followButton.leftAnchor, paddingRight: 4)
        } else {
            addSubview(infoLabel)
            infoLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
            infoLabel.anchor(right : postImageView.leftAnchor, paddingRight: 4)
        }
        
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBackgroundColor
        followButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
    }
}
