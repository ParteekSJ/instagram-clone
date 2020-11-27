//
//  ProfileCell.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/23/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

class ProfileCell : UICollectionViewCell {
    //MARK: - Properties
    var post : Post? {
        didSet { configurePost() }
    }
    
    private let postImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.clipsToBounds = true
        return iv
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
        addSubview(postImageView)
        postImageView.addConstraintsToFillView(self)
        
    }
    
    func configurePost() {
        guard let post = post else { return }
        let viewModel = PostViewModel(post: post)
        postImageView.sd_setImage(with: URL(string: viewModel.postImageUrl))
    }
}
