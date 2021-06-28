//
//  HomePageTableCell.swift
//  hbcumade
//
//  Created by Vijay Rathore on 25/01/21.
//

import UIKit


class HomePageTableCell : UITableViewCell, UITextFieldDelegate {
  
    
   
    @IBOutlet weak var viewForViewProfile: UIView!
    @IBOutlet weak var postMore: UIImageView!
    @IBOutlet weak var writeCommentEditField: UITextField!
    @IBOutlet weak var writeACommentImage: UIImageView!
    @IBOutlet weak var postProfile: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var classificationImage: UIImageView!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var shareBtn: UILabel!
    @IBOutlet weak var commentBtn: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var likeBtn: UIImageView!
    var count = 0
    

      internal var aspectConstraint : NSLayoutConstraint? {
          didSet {
              if oldValue != nil {
                  postImage.removeConstraint(oldValue!)
              }
              if aspectConstraint != nil {
                  postImage.addConstraint(aspectConstraint!)
              }
          }
      }

      override func prepareForReuse() {
          super.prepareForReuse()
          aspectConstraint = nil
            
         
      }
   

      func setCustomImage(image : UIImage) {
      
        
        //let aspect = image.size.width / image.size.height
         let constraint = NSLayoutConstraint(item: postImage!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: postImage, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0.0)
           
        constraint.priority = UILayoutPriority.init(999)
  
       
          aspectConstraint = constraint

          postImage.image = image
       
          postImage.layoutIfNeeded()
        
       
            
         
      }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
     
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == writeCommentEditField) {
            return false
        }
        return true
     
    }
    
  
 
   
    
//    /* Updated for Swift 4 */
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.endEditing(true)
//            return false
//        }
//        return true
//    }
//
//    /* Older versions of Swift */
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.endEditing(true)
//            return false
//        }
//        return true
//    }
}

