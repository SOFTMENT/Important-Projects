//
//  NetworkSingleViewCell.swift
//  hbcumade
//
//  Created by Vijay Rathore on 10/06/21.
//

import UIKit
import SDWebImage
class NetworkSingleViewCell: UICollectionViewCell {

    
    @IBOutlet weak var networkMore: UIImageView!
    @IBOutlet weak var classificationImage: UIImageView!

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePic.image = UIImage(named: "profile-user")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
