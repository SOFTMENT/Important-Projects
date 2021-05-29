//
//  CommentPageTableCell.swift
//  hbcumade
//
//  Created by Vijay Rathore on 28/01/21.
//

import UIKit


class CommentPageTableCell: UITableViewCell {
    
    @IBOutlet weak var prrofilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var universityName: UILabel!
    @IBOutlet weak var classificationImage:UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var replyBtn: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
