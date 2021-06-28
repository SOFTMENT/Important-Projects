//
//  HomeChatTableCell.swift
//  hbcumade
//
//  Created by Vijay Rathore on 30/05/21.
//

import UIKit

class HomeChatTableCell: UITableViewCell {
    
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mLastMessage: UILabel!
    @IBOutlet weak var mTime: UILabel!
    @IBOutlet weak var mView: UIView!
    
    override func prepareForReuse() {
        mImage.image = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       
     
        
    }
}
