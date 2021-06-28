//
//  User.swift
//  hbcumade
//
//  Created by Vijay Rathore on 17/01/21.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase



class Post : NSObject, Codable{
   
    
    
    var postId : String?
    var uid : String?
    var name : String?
    var classification : String?
    var school : String?
    var image : String?
    var postText : String?
    var postImage : String?
    var postAt : Date?
    var postLike : Array<String>?
    var postVisibility : String?
    var postComment : Comment?
    var commentCount : Int?
    var token : String?
    private static var postData : Post?
    
    static var data : Post? {
        set(postData) {
            self.postData = postData
        }
        get {
            return postData
        }
    }

    
    override init() {}

    


}


