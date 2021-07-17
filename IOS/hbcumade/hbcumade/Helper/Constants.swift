//
//  Constants.swift
//  hbcumade
//
//  Created by Vijay Rathore on 14/01/21.
//

import Foundation
import UIKit

struct Constants {
   
    
    struct StroyBoard {
        static let mobVeriVC = "mobVeriVC"
        static let signUpViewController = "signUpVC"
        static let signInViewController = "signInVC"
        static let homeViewController = "homeVC"
        static let recoverMailViewController = "recoverMailVC"
        static let enterverificationcodeviewcontroller = "enterCodeVC"
        static let commentViewController = "commentVC"
        static let networkViewController = "networkVC"
        static let verifiedIntroViewController = "verifiedIntroVC"
        static let tabBarViewController = "tabBarVC"
        static let profileController = "profileVC"
        static let accountSettingsController = "accountVC"
        static let exploreViewController = "exploreVC"
        static let eventViewController = "eventVC"
        static let enterInviteCodeController = "enterInviteCodeVC"
        
      
    }
    
    static func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    public static let kNotification = Notification.Name("kNotification")
    public static var postID = "-1"
    public static var tabBarHeight : CGFloat = 49.0
    public static var safeAreaHeight : CGFloat = 34.0
    public static var previousSelectedTabIndex : Int = 0
    public static var selected_classification = "student"
    
    

    
    
    
    
}


