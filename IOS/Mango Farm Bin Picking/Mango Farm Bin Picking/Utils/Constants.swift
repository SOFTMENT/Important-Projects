//
//  Constants.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 14/04/21.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase


public class Constants {
    
    struct StroyBoard {
        static let homeViewController = "homeNVC"
        static let signInViewController = "signInVC"
        static let signInViewController2 = "signIn2VC"
    }
    
  

    public static let kNotification = Notification.Name("kNotification")
    
    public static func getFirestoreDB() -> Firestore {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
    
        let dbRef = Firestore.firestore()
        dbRef.settings = settings
        
        return dbRef
    }

}
