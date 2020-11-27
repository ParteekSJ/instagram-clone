//
//  ImageUploader.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/22/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import FirebaseStorage

struct ImageUploader {
    static func uploadImage(image : UIImage, completion : @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let customFileName = NSUUID().uuidString //UniqueIdentifier
        let ref = Storage.storage().reference(withPath: "/profileImages/\(customFileName)")
        
        //AddingImageToFirebase
        ref.putData(imageData, metadata: nil) { (meta, err) in
            if let error = err {
                print("DEBUG : FailedToUploadImage \(error.localizedDescription)")
                return
            }
            //RetrievingDownloadURL
            ref.downloadURL { (url, err) in
                guard let imageURL = url?.absoluteString else { return }
                completion(imageURL)
            }
        }
    }
}
