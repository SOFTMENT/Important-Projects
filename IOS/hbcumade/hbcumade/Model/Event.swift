//
//  Event.swift
//  hbcumade
//
//  Created by Vijay on 09/04/21.
//

import Foundation

class Event : NSObject, Codable{
    var name : String?
    var status : String?
    var image : String?
    var date : Date?

    init(name : String, status : String, image : String, date : Date?) {
        self.name = name
        self.status = status
        self.image = image
        self.date = date
    }
}


