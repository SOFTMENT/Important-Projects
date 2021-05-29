//
//  MainProfile.swift
//  hbcumade
//
//  Created by Vijay on 05/04/21.
//

import UIKit

class MainProfile: UIViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    
    override func viewDidLoad() {
        
        profilePic.makeRounded()
      
    }
}
