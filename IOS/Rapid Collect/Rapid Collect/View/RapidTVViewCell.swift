//
//  RapidTVViewCell.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 01/05/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit

class RapidTVViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var myview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        myview.layer.borderColor = UIColor.gray.cgColor
        myview.layer.borderWidth  = 1
        myview.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
