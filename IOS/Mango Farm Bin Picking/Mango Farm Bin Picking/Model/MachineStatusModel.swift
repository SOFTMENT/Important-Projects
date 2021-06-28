//
//  MachineStatusModel.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay Rathore on 18/06/21.
//

import UIKit

class MachineStatusModel: Codable {
    var machine : String?
    var status : String?
    var time : Double?
    
    public static var data : MachineStatusModel = MachineStatusModel()
}
