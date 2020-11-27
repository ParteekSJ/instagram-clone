//
//  NotificationService.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/26/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct NotificationService {
    static func uploadNotification(toUid uid : String, fromUser user : User, type : NotificationType, post : Post? = nil) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUID else { return }
        
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        
        var data : [String : Any] = ["notificationID" : docRef.documentID,
                                     "timestamp" : Timestamp(date: Date()),
                                     "uid" : user.uid,
                                     "type" : type.rawValue,
                                     "profileImageUrl" : user.profileImageURL,
                                     "username" : user.username]
        if let post = post {
            data["postID"] = post.postID
            data["postImageUrl"] = post.imageUrl
        }
        docRef.setData(data)
    }
    
    static func fetchNotifications(completion : @escaping([Notification]) -> Void) {
        var notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").getDocuments { (snapshot, _) in
            guard let documents = snapshot?.documents else { return }
            documents.forEach { (document) in
                let notification = Notification(dictionary: document.data())
                notifications.append(notification)
            }
            completion(notifications)
        }
    }
}
