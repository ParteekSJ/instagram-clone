//
//  UserViewModel.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/23/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

struct ProfileHeaderViewModel {
    //MARK: - Properties
    var user : User
    var profileImageURL : String {
        return user.profileImageURL
    }
    var fullname : String {
        return user.fullname
    }
    var username : String {
        return user.username
    }
    
    var followButtonText : String {
        if user.isCurrentUser {
            return "Edit Profile"
        } else if user.isFollowed {
            return "Following"
        } else {
            return "Follow"
        }
    }
    
    var followButtonBackgroundColor : UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }
    var followButtonTextColor : UIColor {
        return user.isCurrentUser ? .black : .white
    }
    var followersCount : NSAttributedString {
        return attributedStatText(value: user.userStats.followers, label: "Followers")
    }
    var followingCount : NSAttributedString {
        return attributedStatText(value: user.userStats.following, label: "Following")
    }
    var numberOfPosts : NSAttributedString {
        return attributedStatText(value: user.userStats.posts, label: "Posts")
    }
    
    //MARK: - LifeCycle
    init(user : User) {
        self.user = user
    }
        
    //MARK: - Helpers
    func attributedStatText(value : Int, label : String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        return attributedText
    }


}
