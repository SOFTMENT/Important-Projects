//
//  AdminViewController.swift
//  Holli
//
//  Created by Vijay on 11/04/21.
//  Copyright © 2021 OriginalDevelopment. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController, UITextFieldDelegate{
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userNameField: UITextField!
    final let username = "holliapp"
    final let password = "holli@2021"
    
    
    override func viewDidLoad() {
        loginBtn.layer.cornerRadius = 4
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard)))
        passwordField.delegate = self
        userNameField.delegate = self
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

    @objc func hideKeyBoard() {
        view.endEditing(true)
    }
    @IBAction func loginBtnClicked(_ sender: Any) {
        let sUsername = userNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sPassword = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sUsername == username && sPassword == password{
            defaults.set(true, forKey: "isLoggedIn")
            sendPushNotification()
        }
        else {
            showToast(message: "Incorrect Username and Password")
        }
    }
    
   
}
