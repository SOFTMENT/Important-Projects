//
//  Top_Organiser_Cell.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 21/07/21.
//

import UIKit

class Top_Organiser_Cell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var followers: UILabel!
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var followBtn: UIView!
    
    @IBOutlet weak var followText: UILabel!
    @IBOutlet weak var followPlusBtn: UIImageView!
    override class func awakeFromNib() {
        
    }
}
