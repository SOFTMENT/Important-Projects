//
//  AdminVideosTableViewCell.swift
//  KaiBall Athletics
//
//  Created by Vijay on 04/05/21.
//

import UIKit

class AdminVideosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var delete: UIImageView!
    @IBOutlet weak var edit: UIImageView!
    
    
    @IBOutlet weak var myView: UIView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
