//
//  AuthService.swift
//  Instagram
//
//  Created by Dan Hozan on 20.02.2024.
//
import UIKit
import Firebase

struct AuthCredentials{
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService{
    
    static func signInUser(withEmail email: String, password: String, complition: @escaping(Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            complition(error)
        }
        
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials, complition: @escaping(Error?) -> Void){
        ImageUploader.uploadImage(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password){ result, error in
                if let error = error {
                    print("DEBUG: Failed to register user \(error.localizedDescription)")
                    return
                }
                guard let uid = result?.user.uid else { return }
                let data : [String: Any] = ["email": credentials.email,
                                            "fullname": credentials.fullname,
                                            "profileImageUrl": imageUrl,
                                            "uid": uid,
                                            "username": credentials.username]
                Firestore.firestore().collection("users").document(uid).setData(data, completion: complition)
                
            }
        }
    }
    
    
}
