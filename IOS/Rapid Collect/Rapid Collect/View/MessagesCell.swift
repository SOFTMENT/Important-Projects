//
//  MessagesCell.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 26/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit


class MessagesCell: UITableViewCell {
    @IBOutlet weak var senderView: UIView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myLabel: UILabel!
    var message : Messages!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myView.layer.cornerRadius = 10
        senderView.layer.cornerRadius = 10
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func config(message : Messages, uid : String) {
        self.message  = message
        
        if message.sender == uid {
            senderView.isHidden = true
            myView.isHidden = false
            myLabel.text = message.message
        }
        else {
            senderView.isHidden = false
            myView.isHidden = true
            senderLabel.text = message.message
        }
        
    }

}
