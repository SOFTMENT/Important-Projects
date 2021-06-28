//
//  NetworkDoubleViewCell.swift
//  hbcumade
//
//  Created by Vijay Rathore on 10/06/21.
//

import UIKit
import SDWebImage

class NetworkDoubleViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var classificationImage: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    override func prepareForReuse() {
        profilePic.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
