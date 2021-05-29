//
//  ToDoViewCell.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 06/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit

class ToDoViewCell: UITableViewCell {

    @IBOutlet weak var completeStatus: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
