//
//  PostService.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/25/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

struct PostService {
    static func uploadPost(user : User, caption : String, image : UIImage, completion : @escaping(FireStoreCompletion)) {
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data : [String : Any] = ["owneruid" : user.uid,
                                         "caption" : caption,
                                         "timestamp" : Timestamp(date: Date()),
                                         "likes" : 0,
                                         "imageUrl" : imageUrl,
                                         "ownerImageUrl" : user.profileImageURL,
                                         "ownerUsername" : user.username]
            
            //AutomaticallyGeneratesUIDs
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchPosts(completion : @escaping([Post]) -> Void){
        var posts = [Post]()
        
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            snapshot.documents.forEach { document in
                let post = Post(postID: document.documentID, dictionary: document.data())
                posts.append(post)
            }
            completion(posts)
        }
    }
    
    static func fetchPosts(forUser uid : String, completion : @escaping([Post]) -> Void) {
        var userPosts = [Post]()
        
        let query = COLLECTION_POSTS.whereField("owneruid", isEqualTo: uid)
        query.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            snapshot.documents.forEach { document in
                let post = Post(postID: document.documentID, dictionary: document.data())
                userPosts.append(post)
            }
            //Sort
            userPosts.sort { (post1, post2) -> Bool in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            completion(userPosts)
        }
    }
    
    static func fetchPost(withPostId postID: String, completion : @escaping(Post) -> Void) {
        COLLECTION_POSTS.document(postID).getDocument { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            let post = Post(postID: snapshot.documentID, dictionary: data)
            completion(post)
        }
    }
    
    static func likePost(post : Post, completion : @escaping(FireStoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(post.postID).updateData(["likes" : post.likes + 1])
        
        COLLECTION_POSTS.document(post.postID).collection("post-likes").document(uid).setData([:]) { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(post : Post, completion : @escaping(FireStoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard post.likes > 0 else { return }
        
        COLLECTION_POSTS.document(post.postID).updateData(["likes" : post.likes - 1])
        
        COLLECTION_POSTS.document(post.postID).collection("post-likes").document(uid).delete { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).delete(completion: completion)
        }
    }
    
    static func checkIfUserLikedPost(post : Post, completion : @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).getDocument { (snapshot, error) in
            guard let isLiked = snapshot?.exists else { return }
            completion(isLiked)
        }
    }
}
