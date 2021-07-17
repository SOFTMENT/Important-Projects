//
//  User.swift
//  hbcumade
//
//  Created by Vijay Rathore on 17/01/21.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import UIKit



class Comment : NSObject, Codable{
    
    var commentID : String?
    var uid : String?
    var name : String?
    var image : String?
    var classification : String?
    var commentText : String?
    var commentAt : Date?
    var commentLike : Array<String>?
    var commentCount : Int?
    var school : String?

    
   
    static var comment : Comment?
    static var sharedInstance : Comment {
        set(commentData) {
            self.comment = commentData
        }
        get {
            return comment!
        }
    }
    
    init(commentID : String, uid : String, name : String, image : String, classification : String, commentText : String, commentAt : Date, commentLike : Array<String>, commentCount : Int, school : String) {
        
        self.commentID = commentID
        self.uid = uid
        self.name = name
        self.image = image
        self.classification = classification
        self.commentText = commentText
        self.commentAt = commentAt
        self.commentLike  = commentLike
        self.commentCount  = commentCount
        self.school = school
    }
    
    private override init() {}


}


