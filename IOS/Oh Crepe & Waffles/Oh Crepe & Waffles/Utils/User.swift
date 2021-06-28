//
//  User.swift
//  Oh Crepe & Waffles
//
//  Created by Vijay Rathore on 14/06/21.
//

import Foundation

final class User : NSObject, Codable{
    var name : String?
    var email : String?
    var uid : String?
    
    
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
