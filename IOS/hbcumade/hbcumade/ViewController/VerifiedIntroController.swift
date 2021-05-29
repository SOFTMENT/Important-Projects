//
//  VerifiedIntroController.swift
//  hbcumade
//
//  Created by Vijay on 23/03/21.
//

import UIKit

class VerifiedIntroController: UIViewController {

    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { 
            self.beRootScreen(mIdentifier: Constants.StroyBoard.tabBarViewController)
        }
       
    }
}
