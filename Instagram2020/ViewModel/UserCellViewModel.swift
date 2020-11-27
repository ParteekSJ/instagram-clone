//
//  UserCellViewModel.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/24/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

struct UserCellViewModel {
     //MARK: - Properties
    private let user : User
    
    var profileImageURL : String {
        return user.profileImageURL
    }
    var fullName : String {
        return user.fullname
    }
    var username : String {
        return user.username
    }
    
     //MARK: - LifeCycle
    init(user : User) {
        self.user = user
    }
    
     //MARK: - API
     
     //MARK: - Selectors
     
     //MARK: - Helpers
}
