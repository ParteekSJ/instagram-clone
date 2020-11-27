//
//  CommentInputAccessoryView.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/26/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

protocol CommentInputAccessoryViewDelegate : class {
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment  :String)
}

class CommentInputAccessoryView : UIView {
    
    //MARK: - Properties
    
    weak var delegate : CommentInputAccessoryViewDelegate?
    
    private let commentTextView : InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "Enter Comment.."
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        tv.placeholderShouldCenter = true
        return tv
    }()
    
    private let postButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleCommentUpload), for: .touchUpInside)
        button.setDimensions(width: 50, height: 50)
        return button
    }()
    
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame : frame)
        autoresizingMask = .flexibleHeight
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    //MARK: - Selectors
    @objc func handleCommentUpload() {
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
    }
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .systemBackground
        
        addSubview(postButton)
        postButton.anchor(top : topAnchor, right: rightAnchor, paddingRight: 8)
        
        addSubview(commentTextView)
        commentTextView.anchor(top : topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top : topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
    }
}
