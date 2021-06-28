//
//  MangoBinDetailsTableViewCell.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 15/04/21.
//

import UIKit

class MangoBinDetailsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var basketImage: UIImageView!
    @IBOutlet weak var mangoBinImgView: UIView!
    @IBOutlet weak var imgNumber: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var machineNo: UILabel!
    @IBOutlet weak var scannedBy: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var pickedBy: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var emptyTime: UILabel!
    @IBOutlet weak var seeOnMap: UILabel!
    
    @IBOutlet weak var pickedByView: UIView!
    @IBOutlet weak var emptyDateView: UIView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
