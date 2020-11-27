//
//  UserService.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/23/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

typealias FireStoreCompletion = (Error?) -> Void

struct UserService {
    static func fetchUser(withuid uid : String, completion : @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            if let error = error {
                print("DEBUG : FailedToGetDocument - \(error.localizedDescription)")
                return
            }
        
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }

    
    static func fetchUsers(completion : @escaping([User]) -> Void) {
        var users = [User]()
        
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            snapshot.documents.forEach { document in
                let user = User(dictionary: document.data())
                users.append(user)
            }
            completion(users)
        }
    }
    
    /* Follow / Following Structure looks somewhat like this
     
     Drake - CurrentUser
     Conor - User
     
     Drake FOLLOWS Conor
        DrakeUID -> "user-following" -> ConorUID (list of every person currentUser follows)
        ConorUID -> "user-followers" -> DrakeUID (list of every followers this 'user' has)
     */
    
    static func follow(uid : String, completion : @escaping(FireStoreCompletion)) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUID).collection("user-following").document(uid).setData([:]) { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUID).setData([:], completion: completion)
        }
    }
    
    static func unfollow(uid : String, completion : @escaping(FireStoreCompletion)) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUID).collection("user-following").document(uid).delete { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUID).delete(completion: completion)
        }
    }
    
    static func checkIfUserIsFollowed(uid : String, completion : @escaping(Bool) -> Void) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUID).collection("user-following").document(uid).getDocument { (snapshot, error) in
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
    }
    
    static func fetchUserStats(uid : String, completion : @escaping(UserStats) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, _) in
            let followers = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { (snapshot, _) in
                let following = snapshot?.documents.count ?? 0
                
                COLLECTION_POSTS.whereField("owneruid", isEqualTo: uid).getDocuments { (snapshot, _) in
                    let posts = snapshot?.documents.count ?? 0
                    
                    let userStats = UserStats(followers: followers, following: following, posts: posts)
                    completion(userStats)
                }
            }
        }
    }
}
