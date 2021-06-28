//
//  SignUpViewController.swift
//  Oh Crepe & Waffles
//
//  Created by Vijay Rathore on 14/06/21.
//

import UIKit
import Firebase
import FirebaseAuth
import MBProgressHUD

class SignUpViewController: UIViewController,UITextFieldDelegate {
   
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var emailaddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var createAccountBtn: UIButton!
    
    @IBOutlet weak var loginbtn: UILabel!
    override func viewDidLoad() {
        
        name.setLeftPaddingPoints(10)
        name.setRightPaddingPoints(10)
        
        emailaddress.setRightPaddingPoints(10)
        emailaddress.setLeftPaddingPoints(10)
        
        password.setRightPaddingPoints(10)
        password.setLeftPaddingPoints(10)
        
        name.delegate = self
        emailaddress.delegate = self
        password.delegate = self
        
        createAccountBtn.layer.cornerRadius = 4
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        loginbtn.isUserInteractionEnabled = true
        loginbtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginBtnClicked)))
    }
    
    @objc func loginBtnClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    @IBAction func createAccountBtnTapped(_ sender: Any) {
        let mName = name.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let mEmail  = emailaddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let mPassword = password.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if mName == "" {
            showToast(message: "Enter Name")
        }
        else if mEmail == "" {
            showToast(message: "Enter Email Address")
        }
        else if mPassword == "" {
            showToast(message: "Enter Password")
        }
        else {
            self.createAccount(name: mName!, email: mEmail!, password: mPassword!)
        }
    }
    
    func createAccount(name : String, email : String, password : String){
        ProgressHUDShow(text: "Creating Account...")
        Auth.auth().createUser(withEmail: email, password: password) { auth, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                self.addUserData(data: ["uid" : Auth.auth().currentUser!.uid,"name" : name,"email":email], uid: Auth.auth().currentUser!.uid)
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
        
    }
    
    
}
