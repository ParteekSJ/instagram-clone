//
//  User.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/23/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

struct User {
    var email : String
    var fullname : String
    var profileImageURL : String
    var uid : String
    var username : String
    
    var isFollowed = false
    var isCurrentUser : Bool { return Auth.auth().currentUser?.uid == uid }
    var userStats : UserStats
    
    init(dictionary : [String:Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.userStats = UserStats(followers: 0, following: 0, posts: 0)
    }
}

struct UserStats {
    let followers : Int
    let following : Int
    let posts : Int
}
