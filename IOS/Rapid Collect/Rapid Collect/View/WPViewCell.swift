//
//  WPViewCell.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 17/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit

class WPViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
