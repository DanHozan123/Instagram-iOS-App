//
//  NotificationViewModel.swift
//  Instagram
//
//  Created by Dan Hozan on 27.02.2024.
//

import UIKit

struct NotificationViewModel {
    
    var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    var postImageUrl: URL? { return URL(string: notification.postImageUrl ?? "") }
    
    var profileImageUrl: URL? { return URL(string: notification.userProfileImageUrl) }
    
    var timestampString: String? {
        let formatter  = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notification.timestamp.dateValue(), to: Date())
    }
    
    func notificationMessage() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: notification.username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: notification.type.notificationMessage, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        attributedString.append(NSAttributedString(string: "  \(timestampString ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        return attributedString
    }
    
    
    var shouldHidePostImage: Bool { return self.notification.type == .follow }
    
    var followButtonText: String { return notification.userIsFolllowed ? "Following" : "Follow" }
    
    var followButtonBackgroundColor: UIColor {
        return notification.userIsFolllowed ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return notification.userIsFolllowed ? .black : .white
    }
    
}
