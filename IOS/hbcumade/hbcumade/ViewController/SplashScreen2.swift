//
//  SplashScreen2.swift
//  hbcumade
//
//  Created by Vijay on 23/03/21.
//

import UIKit

class SplashScreen2: UIViewController {
    
    override func viewDidLoad() {
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sleep(2)
        beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
    }
}
