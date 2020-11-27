//
//  PostViewModel.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/25/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

struct PostViewModel {
    //MARK: - Properties
    var post : Post
    
    var postImageUrl : String { return post.imageUrl }
    var postCaption : String { return post.caption }
    var likes : Int { return post.likes }
    var username : String { return post.ownerUsername}
    var userProfileImageUrl : String { return post.ownerImageUrl}
    var likesLabelText : String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) like"
        }
    }
    var likeButtonTintColor : UIColor {
        return post.isLiked ? .red : .black
    }
    var likeButtonImage : UIImage? {
        let imageName = post.isLiked ? "like_selected" : "like_unselected"
        return UIImage(named: imageName)
    }

    
    //MARK: - LifeCycle
    init(post : Post) {
        self.post = post
    }
    //MARK: - Selectors
    
    //MARK: - Helpers
    func attributedCaption(username : String, caption : String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(username) ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "\(caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        return attributedText
    }
}
