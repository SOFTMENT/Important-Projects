//
//  MangoBinModel.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 15/04/21.
//

import UIKit


class MangoBinModel {
    
    var id : String = ""
    var title : String = ""
    var pickedByName : String = ""
    var scannedByName : String = ""
    var machineNumber : String = ""
    var date : Double  = 0
    var binNumber : Int = 0

    static var mangoBinModels : Array<MangoBinModel> = Array()
    
    init(id : String, title : String,pickedByName : String,scannedByName : String, binNumber : Int, date : Double, machineNumber : String) {
        self.id = id
        self.title = title
        self.pickedByName = pickedByName
        self.scannedByName = scannedByName
        self.binNumber = binNumber
        self.date = date
        self.machineNumber = machineNumber
    }
    
}
