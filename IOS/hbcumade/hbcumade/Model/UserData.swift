//
//  UserData.swift
//  hbcumade
//
//  Created by Vijay Rathore on 23/01/21.
//

import Foundation

final class UserData : NSObject, Codable{
    var name : String?
    var email : String?
    var classification : String?
    var profile : String?
    var commentText : String?
    var isMobVerified : Bool?
    var registredAt : Date?
    var regiType : String?
    var school : String?
    var uid : String?
    var totalFollowing : Int?
    var totalFollowers : Int?
    var designation : String?
    
    private static var userData : UserData?
    
    static var data : UserData? {
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
