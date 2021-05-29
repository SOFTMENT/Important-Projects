//
//  VideoTableViewCell.swift
//  KaiBall Athletics
//
//  Created by Vijay on 04/05/21.
//

import UIKit

class VideoTableViewcell: UITableViewCell {
    
    @IBOutlet weak var lockImg: UIImageView!
    @IBOutlet weak var myview: UIView!
    @IBOutlet weak var playBtn: UIImageView!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var title: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
