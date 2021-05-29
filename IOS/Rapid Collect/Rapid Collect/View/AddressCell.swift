//
//  AddressCell.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 28/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {

   
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        myView.layer.cornerRadius = 10
        myView.layer.borderColor = UIColor.black.cgColor
      
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
