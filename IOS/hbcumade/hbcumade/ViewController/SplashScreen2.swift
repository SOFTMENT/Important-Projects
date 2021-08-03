//
//  SplashScreen2.swift
//  hbcumade
//
//  Created by Vijay on 23/03/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class SplashScreen2: UIViewController {
   
   
    let userDefaults = UserDefaults.standard
    var isLock = false
    @IBOutlet weak var splashImage: UIImageView!
    override func viewDidLoad() {
  
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let count = UserDefaults.standard.integer(forKey: "launchCount")
       
        print("VijayRathore \(count)")
        if count % 4 == 0 {

             splashImage.image = UIImage(named: "sp2")
    
        }
        else if count % 4  == 1 {

            splashImage.image = UIImage(named: "sp3")
           
        
           
        }
        else if count % 4 == 2 {
     
            splashImage.image = UIImage(named: "sp4")
            
        }
        else {
     
            splashImage.image = UIImage(named: "sp5")
           
        }
        
        loadViewIfNeeded()
        
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
                    self.getUserData(uid: Auth.auth().currentUser!.uid,showProgress: false)
                 }
                 else{
                     
                    self.getUserData(uid: Auth.auth().currentUser!.uid,showProgress: false)
                     
                 }
                 
                 
             }
             else {
                DispatchQueue.main.async {
                    self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
                }
             }
    }
   
}
