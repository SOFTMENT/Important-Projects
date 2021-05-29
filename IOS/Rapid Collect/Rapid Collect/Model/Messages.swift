//
//  Messages.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 26/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import Foundation

class Messages {
    
    private var _message : String = ""
    private var _sender : String = ""
    
    init(message : String, sender : String) {
        _message = message
        _sender = sender
    }
    
    var message : String {
        return _message
    }
    
    var sender : String {
        return _sender
    }
    
}
