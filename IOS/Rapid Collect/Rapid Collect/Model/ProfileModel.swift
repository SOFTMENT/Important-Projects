//
//  ProfileModel.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 20/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import Foundation

class ProfileModel {
    
    static var profilemodel : ProfileModel?
    static func getModel() -> ProfileModel {
        if profilemodel == nil {
            profilemodel = ProfileModel()

        }
        return profilemodel ?? ProfileModel()
    }
    
    var name : String = ""
    var profileimage : String = ""
    var mail : String = ""
    
    
    
}
