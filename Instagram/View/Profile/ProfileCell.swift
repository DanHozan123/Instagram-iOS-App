//
//  ProfileCell.swift
//  Instagram
//
//  Created by Dan Hozan on 20.02.2024.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let postImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Daniel Day-Lewis1")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        addSubview(postImage)
        postImage.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
