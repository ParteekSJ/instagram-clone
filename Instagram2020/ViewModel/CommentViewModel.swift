//
//  CommentViewModel.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/26/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

struct CommentViewModel {
    //MARK: - Properties
    var comment : Comment
    
    var profileImageUrl : String {
        return comment.profileImageUrl
    }
    var commentText : String {
        return comment.commentText
    }
    var username : String {
        return comment.username
    }
    
    //MARK: - LifeCycle
    init(comment : Comment) {
        self.comment = comment
    }
    
    //MARK: - Helpers
    func createAtributedLabelText() ->  NSAttributedString {
        let attributedString = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(
            string: " \(commentText)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        return attributedString
    }
    
    func size(forWidth width : CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comment.commentText
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width: width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
