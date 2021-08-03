//
//  Event_DateandTime_Cell.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 22/07/21.
//

import UIKit

class Event_DateandTime_Cell: UICollectionViewCell {
   
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var dayName: UILabel!
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var dayDigit: UILabel!
    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    
    override class func awakeFromNib() {
        
    }
}
