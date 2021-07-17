//
//  Messages.swift
//  hbcumade
//
//  Created by Vijay Rathore on 01/06/21.
//


import Foundation
import UIKit


class Messages : NSObject, Codable {


    var message : String?
    var sender : String?
    var type : String?
    var image : String?
    var name : String?
    var messageId : String?
    var dateandtime : Date = Date()
    
    private static var message  : Messages?
    
    static var data : Messages? {
        set(message) {
            self.message = message
        }
        get {
            return message
        }
    }


    override init() {
        
    }
    
   
    
}
