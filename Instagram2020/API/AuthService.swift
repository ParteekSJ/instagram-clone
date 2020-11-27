//
//  AuthService.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/22/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct AuthCredentials {
    let email : String
    let password : String
    let fullname : String
    let username : String
    let profileImage : UIImage
}

struct AuthService {
        
    static func logUserIn(withEmail email : String, password : String, completion : ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials : AuthCredentials, completion : @escaping(Error?) -> Void) {
        //UploadingImage  & RetrievingImageURL
        ImageUploader.uploadImage(image: credentials.profileImage) { imageURL in
            //CreatingUser
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, err) in
                //HandlingError
                if let error = err {
                    print("DEBUG : FailedToRegister - \(error.localizedDescription)")
                    return
                }
                //SignedInUser'sUID
                guard let uid = result?.user.uid else { return }
                //CreatingTheUser'sDictionary-NSDictionary
                let userData : [String : Any] = ["username" : credentials.username,
                                                 "uid" : uid,
                                                 "fullname" : credentials.fullname,
                                                 "email" : credentials.email,
                                                 "profileImageURL" : imageURL]
                //AddingDataToFireStore
                COLLECTION_USERS.document(uid).setData(userData, completion: completion)
            }
        }
    }
}
