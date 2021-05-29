//
//  LocationModel.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 28/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import Foundation


class LocationModel {
    
    private var _address = ""
    private var _date = ""
    
    
    init(address : String, date : String) {
        _address = address
        _date = date
    }
    
    var address : String {
        return _address
    }
    
    var date : String {
        return _date
    }
    
}
