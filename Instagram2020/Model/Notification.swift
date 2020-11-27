//
//  Notification.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/26/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

enum NotificationType : Int {
    case like
    case follow
    case comment
    
    var description : String {
        switch self {
        case .like:
            return " liked your post."
        case .follow:
            return " started following you."
        case .comment:
            return " commented on your post."
        }
    }
}

struct Notification {
    let notificationID : String
    let uid : String
    var postImageUrl : String?
    var postID : String?
    let timestamp : Timestamp
    let type : NotificationType
    let profileImageUrl : String
    let username : String
    
    var userIsFollowed = false
    
    init(dictionary : [String : Any]) {
        self.notificationID = dictionary["notificationID"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.postID = dictionary["postID"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.username = dictionary["username"] as? String ?? ""

        
    }
}

