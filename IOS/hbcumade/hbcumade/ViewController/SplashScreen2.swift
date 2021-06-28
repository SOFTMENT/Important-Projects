//
//  SplashScreen2.swift
//  hbcumade
//
//  Created by Vijay on 23/03/21.
//

import UIKit

class SplashScreen2: UIViewController {
   
   
    var isLock = false
    @IBOutlet weak var splashImage: UIImageView!
    override func viewDidLoad() {
  
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let count = UserDefaults.standard.integer(forKey: "launchCount")
       
        if count % 3 == 0 {

             splashImage.image = UIImage(named: "sp2")
             
            sleep(2)
            DispatchQueue.main.async {
                self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
            }
         
            
        }
        else if count % 3  == 1 {

            splashImage.image = UIImage(named: "sp3")
            sleep(2)
            DispatchQueue.main.async {
                self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
            }
        
           
        }
        else if count % 3 == 2 {
     
            splashImage.image = UIImage(named: "sp4")
            sleep(2)
            DispatchQueue.main.async {
                self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
            }
           
        }
    }
    
    
   
}
