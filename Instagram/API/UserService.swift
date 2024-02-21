//
//  UserService.swift
//  Instagram
//
//  Created by Dan Hozan on 21.02.2024.
//

import Firebase


struct UserService{
    
    static func fetchUser(compeletion: @escaping(User) -> Void){
        guard let uid =  Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            compeletion(user)
            
        }
    }
    
    static func fetchUsers(compeletion: @escaping([User]) -> Void){
        COLLECTION_USERS.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let users = snapshot.documents.map({ User(dictionary: $0.data()) })
            compeletion(users)
        }
    }
    
}
