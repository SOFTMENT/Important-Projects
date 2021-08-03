//
//  UserData.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 18/07/21.
//

import UIKit
import Foundation


class UserData: NSObject, Codable {
    
    var fullName : String?
    var email : String?
    var profilePic : String?
    var uid : String?
    var registredAt : Date?
    var regiType : String?

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
