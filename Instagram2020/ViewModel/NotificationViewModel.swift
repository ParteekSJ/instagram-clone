//
//  NotificationViewModel.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/26/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

struct NotificationViewModel {
    //MARK: - Properties
    private var notification : Notification
    
    var postImageURL : String {
        return notification.postImageUrl ?? ""
    }
    var profileImageUrl : String {
        return notification.profileImageUrl
    }
    var username : String {
        return notification.username
    }
    var notificationMessage : NSAttributedString {
        let username = notification.username
        let message = notification.type.description
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message, attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: " 2m", attributes: [.font : UIFont.systemFont(ofSize: 12), .foregroundColor : UIColor.lightGray]))

        return attributedText
    }
    
    var shouldHidePostImage : Bool {
        return self.notification.type == .follow
    }
    var followButtonText : String {
        return notification.userIsFollowed ? "Following" : "Follow"
    }
    var followButtonBackgroundColor : UIColor {
        return notification.userIsFollowed ? .white : .systemBlue
    }
    var followButtonTextColor : UIColor {
        return notification.userIsFollowed ? .black : .white

    }
    
    //MARK: - LifeCycle
    init(notification : Notification) {
        self.notification = notification
    }
    //MARK: - API
    
    //MARK: - Selectors
    
    //MARK: - Helpers
}
