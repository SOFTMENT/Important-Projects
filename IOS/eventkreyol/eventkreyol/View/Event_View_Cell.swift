//
//  Event_View_Cell.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 21/07/21.
//

import UIKit

class Event_View_Cell: UITableViewCell {
   
    
   
    
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var eventFav: UIImageView!
    @IBOutlet weak var eventShare: UIImageView!
    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDate: UILabel!
    
    
    override class func awakeFromNib() {
        
    }
}
