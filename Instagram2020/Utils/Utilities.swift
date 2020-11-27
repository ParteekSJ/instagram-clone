//
//  Utilities.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/22/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    //CustomActionButtons
    func createActionButton(imageName : String, selector : Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    func createAttributedButton(text1 : String , text2 : String) -> UIButton {
        let button = UIButton()
        
        let atributedText = NSMutableAttributedString(string: text1, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.5), NSAttributedString.Key.foregroundColor : UIColor.white])
        atributedText.append(NSAttributedString(string: text2, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14.5), NSAttributedString.Key.foregroundColor : UIColor.white]))
        
        button.setAttributedTitle(atributedText, for: .normal)
        return button
    }
    
    func configureGradientLayer(view : UIView) {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0 , 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
    func createAuthenticationButton(title : String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(height: 50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        return button
    }
}
