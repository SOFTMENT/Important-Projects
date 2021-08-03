//
//  Welcome.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 19/07/21.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
   
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
            //if app is first time opened then it will be nil
            userDefaults.setValue(true, forKey: "appFirstTimeOpend")
            // signOut from FIRAuth
            do {
                try Auth.auth().signOut()
            }catch {

            }
            // go to beginning of app
        }
        
        if Auth.auth().currentUser != nil {
                 var providerID = ""
                 if let providerId = Auth.auth().currentUser!.providerData.first?.providerID {
                     providerID = providerId
                 }
             
          
        
                 if providerID == "password"  {
                    if Auth.auth().currentUser!.isEmailVerified {
                       
                        self.getUserData(uid: Auth.auth().currentUser!.uid,showProgress: false)
                    }
                    else {
                        
                        self.gotoSignInViewController()
                    }
                   
                 }
                 else {
                     
                   self.getUserData(uid: Auth.auth().currentUser!.uid,showProgress: false)
                 }
                 
                 
             }
             else {
                self.gotoSignInViewController()
             }
    }
    
    func gotoSignInViewController(){
        DispatchQueue.main.async {
            self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
        }
    }
    
}
