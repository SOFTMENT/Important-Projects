//
//  Ticket_View_Cell.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 27/07/21.
//

import UIKit

class Ticket_View_Cell: UITableViewCell {
    
    @IBOutlet weak var mTicketImage: UIImageView!
    @IBOutlet weak var mSeeTickets: UIStackView!
    @IBOutlet weak var mTicketsNumberView: UIView!
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mDate: UILabel!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mTicketCount: UILabel!
    
    
    override class func awakeFromNib() {
    
        
    }
}
