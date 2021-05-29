//
//  EventTableViewCell.swift
//  Admin Oh Crepe & Waffles
//
//  Created by Vijay on 08/05/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var delete: UIImageView!
    override class func awakeFromNib() {
        
    }
}
