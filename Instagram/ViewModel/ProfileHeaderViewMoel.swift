//
//  ProfileHeaderViewMoel.swift
//  Instagram
//
//  Created by Dan Hozan on 21.02.2024.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    init(user: User) {
        self.user = user
    }
    
}
