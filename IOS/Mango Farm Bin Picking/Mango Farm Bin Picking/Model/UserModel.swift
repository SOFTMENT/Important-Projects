//
//  UserModel.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 15/04/21.
//

import UIKit


class UserModel : Codable {
    var email : String?
    var machineNumber : String?
    var pId : String?
    var name : String?
    var designation : String?



  
    public static var userData : UserModel = UserModel()
    
   
}


