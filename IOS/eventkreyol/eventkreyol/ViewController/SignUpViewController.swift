//
//  SignUpViewController.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 18/07/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


class SignUpViewController : UIViewController  {
    
    @IBOutlet weak var enterFullNameTextField: UITextField!
    @IBOutlet weak var enterEmailTextField: UITextField!
    @IBOutlet weak var enterPasswordTextField: UITextField!
    @IBOutlet weak var signIn: UILabel!
    @IBOutlet weak var register : UIButton!
    
    
    override func viewDidLoad() {
        
       
        
        
        enterEmailTextField.delegate = self
        enterPasswordTextField.delegate = self
        
        enterFullNameTextField.setLeftIcons(icon: UIImage(named: "user-3")!)
        enterFullNameTextField.layer.cornerRadius = 8
        
        enterEmailTextField.setLeftIcons(icon: UIImage(named: "email-2")!)
        enterEmailTextField.layer.cornerRadius = 8
        
        enterPasswordTextField.setLeftIcons(icon: UIImage(named: "padlock")!)
        enterPasswordTextField.layer.cornerRadius = 8
       
        register.layer.cornerRadius = 8
        
        //SignInBtnClicked
        signIn.isUserInteractionEnabled = true
        signIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signInBtnClicked)))
        
    }
    
    @objc func signInBtnClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        let sFullName = enterFullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sEmail = enterEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sPassword = enterPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sFullName == "" {
            showSnack(messages: "Enter Full Name")
        }
        else if sEmail == "" {
            showSnack(messages: "Enter Email")
        }
        else if sPassword  == "" {
            showSnack(messages: "Enter Password")
        }
        else {
            ProgressHUDShow(text: "Creating Account...")
            Auth.auth().createUser(withEmail: sEmail!, password: sPassword!) { result, error in
                self.ProgressHUDHide()
                if error == nil {
                    
                    self.addUserData(data: ["fullName" : sFullName!, "email" : sEmail!, "profilePic" : "https://firebasestorage.googleapis.com/v0/b/eventkreyol.appspot.com/o/profile-placeholder.jpg?alt=media&token=cb60876c-f59f-4eb4-bcdc-ccb80e5d9a4f", "uid"  : Auth.auth().currentUser!.uid,"registredAt" : FieldValue.serverTimestamp(),"regiType" : "custom" ], uid: Auth.auth().currentUser!.uid, type: "custom")
                }
                else {
                    self.handleError(error: error!)
                }
            }
        }
        
    }
    
    
    
}


extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

