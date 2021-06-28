//
//  User.swift
//  hbcumade
//
//  Created by Vijay Rathore on 17/01/21.
//

import Foundation
import FirebaseFirestoreSwift



class PostID : NSObject, Codable{
    var postAt : Date?
    var postId : String?
    var uid : String?
  


    static var postid : PostID?
    static var sharedInstance : PostID {
        set(postIDData) {
            self.postid = postIDData
        }
        get {
            return postid!
        }
    }
    
    private override init() {}

    

  
}


