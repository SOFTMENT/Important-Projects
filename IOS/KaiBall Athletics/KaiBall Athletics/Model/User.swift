//
//  User.swift
//  KaiBall Athletics
//
//  Created by Vijay on 22/04/21.
//

import Foundation

final class User : NSObject, Codable{
    var name : String?
    var email : String?
    var uid : String?
    var hasMembership : Bool?
    
    private static var userData : User?
    
    static var data : User? {
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
