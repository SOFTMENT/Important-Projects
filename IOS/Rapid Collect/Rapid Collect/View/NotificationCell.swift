//
//  NotificationCell.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 29/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var desc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        myView.layer.borderColor = UIColor.black.cgColor
        myView.layer.cornerRadius = CGFloat(10)
        // Configure the view for the selected state
    }

}
