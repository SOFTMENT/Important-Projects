//
//  MangoBinModel.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 15/04/21.
//

import UIKit


class MangoBinModel : Codable{
    
    var id : String?
    var title : String?
    var pickedByName : String?
    var scannedByName : String?
    var machineNumber : String?
    var date : Double?
    var binNumber : Int?
    var lati : Double?
    var long : Double?
    var emptyDate : Double?
    var status : String?
    

    static var mangoBinModels : Array<MangoBinModel> = Array()
    
 
    
}
