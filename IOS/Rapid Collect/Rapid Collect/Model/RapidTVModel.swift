//
//  RapidTVModel.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 01/05/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import Foundation
import UIKit


class RapidTVModel {
    
    private var _title = ""
    private var _desc = ""

    private var _videoUrl = ""
    private var _image = ""
    
    init(title : String, desc : String, videoUrl : String, image : String) {
        _title = title
        _desc = desc
        _videoUrl = videoUrl
       _image = image
    }
    
    var title : String{
        return _title
    }
    
    var desc : String {
        return _desc
    }
    
    var videoUrl : String {
        return _videoUrl
    }
    
    var image : String {
        return _image
    }
    
}
