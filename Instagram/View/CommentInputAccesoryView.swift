//
//  CommentInputAccesoryView.swift
//  Instagram
//
//  Created by Dan Hozan on 26.02.2024.
//

import UIKit

protocol CommentInputAccesoryViewDelegate: AnyObject {
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String)
}

class CommentInputAccesoryView: UIView{
    
    // MARK: - Properties
    
    weak var delegate: CommentInputAccesoryViewDelegate?
    
    private let commentTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "Enter Comment"
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled =  false
        tv.placeholderShouldCenter = false
        return tv
    }()
    
    private lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: - Acrions
    
    @objc func handlePostTapped() {
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
    }
    
    // MARK: - Helpers
    func clearCommenttextView(){
        commentTextView.text =  nil
        commentTextView.placeholderLabel.isHidden = false
    }
    
    
    
}
