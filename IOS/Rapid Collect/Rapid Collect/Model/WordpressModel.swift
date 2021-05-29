//
//  WordpressModel.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 17/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import Foundation
import SwiftyJSON


struct WordpressModel {
    
    var title : String = ""
    var content : String = ""
    var thumbnail : String = ""
    var date : String = ""

    
    init() {
        
    }
    
    init(json : JSON) {
        self.title = json["title"]["rendered"].stringValue
        self.content = json["content"]["rendered"].stringValue
        self.thumbnail = json["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["full"]["source_url"].stringValue
        let value = json["date"].stringValue
        let index = value.index(value.startIndex, offsetBy: 10)
        let mySubstring = value[..<index]
        self.date = String(mySubstring)
    }
    
}


