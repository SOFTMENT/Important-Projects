//
//  SignInViewController.swift
//  Oh Crepe & Waffles
//
//  Created by Vijay Rathore on 14/06/21.
//

import UIKit
import Firebase
import FirebaseAuth
import MBProgressHUD

class SignInViewController: UIViewController,UITextFieldDelegate {
    
  
    @IBOutlet weak var signUpBtn: UILabel!
    @IBOutlet weak var emailAddress: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        
        
        let userDefaults = UserDefaults.standard
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
        
        emailAddress.setRightPaddingPoints(10)
        emailAddress.setLeftPaddingPoints(10)
        
        password.setRightPaddingPoints(10)
        password.setLeftPaddingPoints(10)
        
        emailAddress.delegate = self
        password.delegate = self
        
        loginButton.layer.cornerRadius = 4
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        signUpBtn.isUserInteractionEnabled = true
        signUpBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpBtnClicked)))
    }
    
    @objc func signUpBtnClicked(){
        performSegue(withIdentifier: "signupseg", sender: nil)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let mEmail = emailAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let mPassword = password.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if mEmail == "" {
            showToast(message: "Enter Email Address")
        }
        else if mPassword == "" {
            showToast(message: "Enter Password")
        }
        else {
            ProgressHUDShow(text: "Sign In...")
            Auth.auth().signIn(withEmail: mEmail!, password: mPassword!) { result, error in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    self.getUserData(uid: Auth.auth().currentUser!.uid)
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.getUserData(uid: Auth.auth().currentUser!.uid)
        }
    }
}
