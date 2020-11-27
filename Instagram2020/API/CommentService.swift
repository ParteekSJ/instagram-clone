//
//  CommentService.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/26/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

struct CommentService {
    static func uploadComment(comment : String, postID : String, user : User, completion : @escaping(FireStoreCompletion)) {
        let data : [String : Any] = ["uid" : user.uid,
                                     "comment" : comment,
                                     "timestamp" : Timestamp(date: Date()),
                                     "username" : user.username,
                                     "profileImageUrl" : user.profileImageURL]
        
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data, completion: completion)
    }
    
    static func fetchComments(postID : String, completion : @escaping([Comment]) -> Void ){
        var comments = [Comment]()
        let query = COLLECTION_POSTS.document(postID).collection("comments").order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    comments.append(comment)
                }
            })
            completion(comments)
        }
    }
}
