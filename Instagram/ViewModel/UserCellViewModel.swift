//
//  UserCellViewModel.swift
//  Instagram
//
//  Created by Dan Hozan on 21.02.2024.
//

import Foundation

struct UserCellViewModel{
    
    private let user: User
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var username: String {
        return user.username
    }
    
    var fullname: String {
        return user.fullname
    }
    
    init(user: User) {
        self.user = user
    }
    
}
