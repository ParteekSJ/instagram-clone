//
//  CommentCell.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/25/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

class CommentCell : UICollectionViewCell {
    //MARK: - Properties
    var comment : Comment? {
        didSet { configureComment() }
    }
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        return iv
    }()
    
    private let commentLabel : UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "username", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: " comment test comment", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedString
        label.numberOfLines = 0
        return label
    }()
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame : frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - API
    
    //MARK: - Selectors
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self)
        profileImageView.anchor(left : leftAnchor, paddingLeft: 8)
        
        addSubview(commentLabel)
        commentLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        commentLabel.anchor(right :rightAnchor, paddingRight: 8)
        
    }
    

    
    func configureComment() {
        guard let comment = comment else { return }
        let viewModel = CommentViewModel(comment: comment)
        profileImageView.sd_setImage(with: URL(string: viewModel.profileImageUrl))
        commentLabel.attributedText = viewModel.createAtributedLabelText()
    }
}
