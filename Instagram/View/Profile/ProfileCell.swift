//
//  ProfileCell.swift
//  Instagram
//
//  Created by Dan Hozan on 20.02.2024.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    //MARK: - Properties
    var viewModel: PostViewModel? {
        didSet { configure() }
    }
    
    private let postImageView: UIImageView = {
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
        addSubview(postImageView)
        postImageView.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        postImageView.sd_setImage(with: viewModel.imageUrl)
    }
    
}
