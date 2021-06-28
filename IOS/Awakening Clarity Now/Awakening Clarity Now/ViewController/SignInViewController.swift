//
//  SignInViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay on 14/05/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

class SignInViewController: UIViewController {
   
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var forgotPassword: UILabel!
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        
        emailAddress.layer.cornerRadius = 12
        password.layer.cornerRadius = 12
        login.layer.cornerRadius = 12
        
        emailAddress.setLeftPaddingPoints(10)
        emailAddress.setRightPaddingPoints(10)
        
        password.setLeftPaddingPoints(10)
        password.setRightPaddingPoints(10)
        
        emailAddress.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])

        password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])

        
        //backbtn
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnPressed)))
        
        //forgotpassword
        forgotPassword.isUserInteractionEnabled = true
        forgotPassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgotPasswordBtnTapped)))
    }
    
    @objc func backBtnPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func forgotPasswordBtnTapped() {
        let sEmail = emailAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sEmail == "" {
            showToast(message: "Enter Email Address")
        }
        else {
            ProgressHUDShow(text: "Resetting...")
            Auth.auth().sendPasswordReset(withEmail: sEmail!) { error in
                self.ProgressHUDHide()
                if error == nil {
                    self.showMessage(title: "RESET PASSWORD", message: "We have sent reset link on your mail address")
                }
                else {
                    self.handleError(error: error!)
                }
            }
        }
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        let sEmail = emailAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sPassword = password.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sEmail == "" {
                 showToast(message: "Enter Email Address")
        }
        else {
            if sPassword == "" {
                showToast(message: "Enter Password")
            }
            else {
                ProgressHUDShow(text: "Login...")
                Auth.auth().signIn(withEmail: sEmail!, password: sPassword!) { result, error in
                  
                    if(error == nil) {
                        self.ProgressHUDHide()
                        if Auth.auth().currentUser!.isEmailVerified || Auth.auth().currentUser?.email == "support@acn.com"{
                            self.getUserData(uid: Auth.auth().currentUser!.uid)
                        }
                        else {
                            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                                self.ProgressHUDHide()
                                self.showMessage(title: "VERIFY EMAIL ADDRESS", message: "We have sent verification link on your mail address")
                            })
                        }
                       
                    }
                    else {
                        self.ProgressHUDHide()
                        self.handleError(error: error!)
                    }
                }
            }
        }
    }
    
 
    
}
