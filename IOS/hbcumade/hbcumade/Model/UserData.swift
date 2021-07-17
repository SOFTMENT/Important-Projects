//
//  UserData.swift
//  hbcumade
//
//  Created by Vijay Rathore on 23/01/21.
//

import Foundation

 class UserData : NSObject, Codable{
    var name : String?
    var email : String?
    var classification : String?
    var profile : String?
    var isMobVerified : Bool?
    var registredAt : Date?
    var regiType : String?
    var school : String?
    var customSchoolName : String?
    var uid : String?
    var hasApproved : Bool?
    var totalFollowing : Int?
    var totalFollowers : Int?
    var designation : String?
    var aboutSelf : String?
    var dob : Date?
    var phone : String?
    var twitterUsername : String?
    var instagramUsername : String?
  
    var major : String?
    var graduationDate : Date?
    var secondaryEmail : String?
    var coverImage : String?
    var token : String?
    var referralUsed : Int?
    
  
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
