//
//  Post.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/25/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

struct Post {
    let owneruid : String
    var caption : String
    var likes : Int
    let imageUrl : String
    let timestamp : Timestamp
    let postID : String
    let ownerImageUrl : String
    let ownerUsername : String
    
    var isLiked = false
    
    init(postID : String, dictionary : [String:Any]) {
        self.postID = postID
        self.owneruid = dictionary["owneruid"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""

    }
}
