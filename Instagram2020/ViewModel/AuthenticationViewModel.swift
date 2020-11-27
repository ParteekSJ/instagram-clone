//
//  AuthenticationViewModel.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/22/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

protocol FormViewModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var formIsValid : Bool { get }
    var buttonBackgroundColor : UIColor { get }
    var buttonTitleColor : UIColor { get }
}

struct LoginViewModel : AuthenticationViewModel {
    var email : String?
    var password : String?
    
    var formIsValid : Bool {
        if email?.isEmpty == false && password?.isEmpty == false {
            return true //TextFieldsNotEmpty - VALID
        } else {
            return false //TextFieldsEmpty - INVALID
        }
    }
    var buttonBackgroundColor : UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    var buttonTitleColor : UIColor {
        return formIsValid ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : UIColor(white: 1, alpha: 0.66)
    }
}


struct RegistrationViewModel : AuthenticationViewModel {
    var email : String?
    var password : String?
    var username : String?
    var fullname : String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
            && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : UIColor(white: 1, alpha: 0.66)
    }
}
