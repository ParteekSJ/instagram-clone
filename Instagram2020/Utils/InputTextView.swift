//
//  InputTextView.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/25/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

class InputTextView : UITextView {
    //MARK: - Properties
    
    var placeholderText : String? {
        didSet { placeholderLabel.text = placeholderText }
    }
    
    let placeholderLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    var placeholderShouldCenter = true {
        didSet {
            if placeholderShouldCenter {
                placeholderLabel.anchor(left : leftAnchor, right: rightAnchor, paddingLeft: 8)
                placeholderLabel.centerY(inView: self)
            } else {
                placeholderLabel.anchor(top : topAnchor, left : leftAnchor, paddingTop: 7, paddingLeft: 6)
            }
        }
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame : frame, textContainer : textContainer)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    @objc func handleTextDidChange() {
        if text.isEmpty {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
    //MARK: - Helpers
    func configureUI() {
        addNotificationObserver()
        
        addSubview(placeholderLabel)
    }
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
}
