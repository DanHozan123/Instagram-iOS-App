//
//  ImageUploader.swift
//  Instagram
//
//  Created by Dan Hozan on 20.02.2024.
//

import FirebaseStorage

struct imageUploader {
    static func uploadImage(image: UIImage, compeletion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref =  Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData) { _, error in
            if let error = error{
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                compeletion(imageUrl)
            }
            
        }
    }
    
}
