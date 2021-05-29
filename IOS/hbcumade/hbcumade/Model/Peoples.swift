//
//  Peoples.swift
//  hbcumade
//
//  Created by Vijay on 09/04/21.
//

import UIKit

class Peoples : NSObject, Codable{
    var name : String?
    var information : String?
    var image : String?


    init(name : String, information : String, image : String) {
        self.name = name
        self.information = information
        self.image = image
        
    }
}


