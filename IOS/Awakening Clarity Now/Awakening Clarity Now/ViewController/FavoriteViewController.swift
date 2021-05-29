//
//  FavoriteViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 22/05/21.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var settingsBtn: UIImageView!
    override func viewDidLoad() {
        
        //SettingsBtn
        settingsBtn.isUserInteractionEnabled = true
        settingsBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingsBtnClicked)))
    }
    
    @objc func settingsBtnClicked(){
        performSegue(withIdentifier: "settingsseg", sender: nil)
    }
}
