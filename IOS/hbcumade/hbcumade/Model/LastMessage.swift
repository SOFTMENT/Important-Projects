//
//  LastMessage.swift
//  hbcumade
//
//  Created by Vijay Rathore on 30/05/21.
//

import UIKit

class LastMessage: NSObject, Codable {

    var uid : String?
    var name : String?
    var time : Date?
    var message : String?
    var image : String?
    var isRead : Bool?
    var token : String?
    
    
    private static var lastMessage  : LastMessage?
    
    static var data : LastMessage? {
        set(lastMessage) {
            self.lastMessage = lastMessage
        }
        get {
            return lastMessage
        }
    }


    override init() {
        
    }
    
    
}
