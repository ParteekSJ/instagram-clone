//
//  CustomTextField.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/22/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField : UITextField {
    //MARK: - Properties
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    //Custom Init
    init(placeholder : String) {
        super.init(frame: .zero)
        
        let spacer = UITextView()
        spacer.isUserInteractionEnabled = false
        spacer.backgroundColor = UIColor.white.withAlphaComponent(0)
        spacer.setDimensions(width: 12, height: 50)
        leftView = spacer
        leftViewMode = .always
        
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        autocapitalizationType = .none
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        setHeight(height: 50)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1, alpha: 0.7)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    //MARK: - Helpers

}
