//
//  ToDoItemModel.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 06/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import Foundation
import RealmSwift



//struct ToDoItemModel {
//
//    var name : String
//    var details : String
//    var completionDate : Date
//    var startDate : Date
//    var isComplete : Bool
//
//    init(name : String, details : String , completionDate : Date) {
//        self.name = name
//        self.details = details
//        self.completionDate = completionDate
//        startDate = Date()
//        isComplete = false
//    }
//}


public class LocalDatabase {
    
    static var realm : Realm? {
    
        do {
            let realmobject = try Realm()
            return realmobject
        }
        catch {
            print("Can not create realm object")
            return nil
        }
        
   
    }
    
}

class Task : Object {
    
    @objc dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var name = ""
    @objc dynamic var details = ""
    @objc dynamic var completionDate = NSDate()
    @objc dynamic var startDate = NSDate()
    @objc dynamic var isComplete = false
    
}
