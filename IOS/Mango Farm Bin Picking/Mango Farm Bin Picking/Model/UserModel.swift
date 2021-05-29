//
//  UserModel.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 15/04/21.
//

import UIKit


class UserModel {
    var email : String = ""
    var machineNumber : String = ""
    var pId : String = ""
    var name : String = ""
    var designation : String = ""


    init(email : String,machineNumber : String, name : String, designation : String, pid : String) {
      
        self.email = email
        self.machineNumber = machineNumber
        self.name = name
        self.designation = designation
        self.pId = pid
       
       
    }
  
    private static var userData : UserModel?
    
    static var data : UserModel? {
        set(userData) {
            self.userData = userData
        }
        get {
            return userData
        }
    }
}


