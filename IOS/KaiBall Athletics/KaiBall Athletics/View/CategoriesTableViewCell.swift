//
//  CategoriesTableViewCell.swift
//  KaiBall Athletics
//
//  Created by Vijay on 23/04/21.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {
    
  
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var cat_image: UIImageView!
    @IBOutlet weak var totalVideos: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
