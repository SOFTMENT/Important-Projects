//
//  NetworkTrippleViewCell.swift
//  hbcumade
//
//  Created by Vijay Rathore on 10/06/21.
//

import UIKit
import SDWebImage

class NetworkTrippleViewCell: UICollectionViewCell {

    @IBOutlet weak var classificationImage: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var view: UIView!
    override func prepareForReuse() {
        profilePic.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
