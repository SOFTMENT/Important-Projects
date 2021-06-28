//
//  UserModel.swift
//  Awakening Clarity Now
//
//  Created by Vijay on 14/05/21.
//

import UIKit


class UserModel: NSObject, Codable{
    
    var uid : String = ""
    var name : String = ""
    var mobileNumber : String = ""
    var emailAddress : String = ""
    var lastQuotesId : Int?
    var lastQuotesDate : Date?
    var registrationDate : Date = Date()
    
    private static var userData : UserModel?
    
    static var data : UserModel? {
        set(userData) {
            self.userData = userData
        }
        get {
            return userData
        }
    }

    

    override init() {
       
    }
    
}
