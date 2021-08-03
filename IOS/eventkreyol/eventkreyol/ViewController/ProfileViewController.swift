//
//  ProfileViewController.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 27/07/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var deleteAccountView: UIButton!
    @IBOutlet weak var switchOrganisationView: UIButton!
    
    
    override func viewDidLoad() {
        
        profileImage.makeRounded()
        deleteAccountView.layer.cornerRadius = 8
        deleteAccountView.layer.borderWidth = 1
        deleteAccountView.layer.borderColor = UIColor(red: 209/255, green: 26/255, blue: 42/255, alpha: 1).cgColor
        
        switchOrganisationView.layer.cornerRadius = 8
        
    }
    
    @IBAction func switchToOrganisation(_ sender: Any) {
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
    }
}
