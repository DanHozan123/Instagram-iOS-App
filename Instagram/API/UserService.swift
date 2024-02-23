//
//  UserService.swift
//  Instagram
//
//  Created by Dan Hozan on 21.02.2024.
//

import Firebase

typealias FirestoreCompletion = (Error?) -> Void

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
    
    
    static func follow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard  let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) {error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func unfollow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard  let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
    
    
    static func checkFfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).getDocument{
            (snapshot, error) in
            guard let isFollow = snapshot?.exists else { return }
            completion(isFollow)
        }
    }
    
    
    static func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void){
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, _ in
            let followers =  snapshot?.documents.count ?? 0
          
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { snapshot, _ in
                let following = snapshot?.documents.count ?? 0
                
                COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, _ in
                    let posts = snapshot?.documents.count ?? 0
                    completion(UserStats(followers: followers, following: following, posts: posts))

                }
                
            }
        }
    }
    
}
