//
//  ViewController.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 17/07/21.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var loginWithGoogleBtn: UIView!
    @IBOutlet weak var loginWithAppleBtn: UIView!
    @IBOutlet weak var enterEmailTextField: UITextField!
    @IBOutlet weak var enterPasswordTextField: UITextField!
    @IBOutlet weak var resetBtn: UILabel!
    @IBOutlet weak var register: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loginWithGoogleBtn.isUserInteractionEnabled = true
        loginWithGoogleBtn.layer.cornerRadius = 8
        loginWithGoogleBtn.layer.borderWidth = 1
        loginWithGoogleBtn.layer.borderColor = UIColor.init(red: 38/255, green: 115/255, blue: 209/255, alpha: 8/100).cgColor
        
        loginWithAppleBtn.isUserInteractionEnabled = true
        loginWithAppleBtn.layer.cornerRadius = 8
        loginWithAppleBtn.layer.borderWidth = 1
        loginWithAppleBtn.layer.borderColor = UIColor.init(red: 38/255, green: 115/255, blue: 209/255, alpha: 8/100).cgColor
        
        
        enterEmailTextField.delegate = self
        enterPasswordTextField.delegate = self
        
        enterEmailTextField.setLeftIcons(icon: UIImage(named: "email-2")!)
        enterEmailTextField.layer.cornerRadius = 8
        
        enterPasswordTextField.setLeftIcons(icon: UIImage(named: "padlock")!)
        enterPasswordTextField.layer.cornerRadius = 8
        continueBtn.layer.cornerRadius = 8
        
        //REGISTRATION
        register.isUserInteractionEnabled = true
        register.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoSignUpScreen)))
        
        //LoginWithGoogle
        loginWithGoogleBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginWithGoogleBtnClicked)))
        
        //ResetBtn
        resetBtn.isUserInteractionEnabled = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(fromAppDelegateForAuth(_:)), name: Constants.kNotification, object: nil)
    }
    
    @objc func resetBtnClicked(){
        let sEmail = enterEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sEmail == "" {
            showSnack(messages: "Enter Email Address")
        }
        else {
            ProgressHUDShow(text: "")
            Auth.auth().sendPasswordReset(withEmail: sEmail!) { error in
                self.ProgressHUDHide()
                if error == nil {
                    self.showMessage(title: "RESET PASSWORD", message: "We have sent reset password link on your mail address.", shouldDismiss: false)
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
    }
    
    @objc func fromAppDelegateForAuth(_ sender: Notification) {
       
        if let credential = sender.userInfo?["credential"] as? AuthCredential {
            authWithFirebase(credential: credential,type: "google", displayName: "")
        }
      
    }
    
    @objc func loginWithGoogleBtnClicked() {
        self.loginWithGoogle()
    }
    
    @objc func gotoSignUpScreen() {
        self.performSegue(withIdentifier: "signupseg", sender: nil)
    }

    @IBAction func continueBtnClicked(_ sender: Any) {
        let sEmail = enterEmailTextField.text?.trimmingCharacters(in: .nonBaseCharacters)
        let sPassword = enterPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sEmail == "" {
           showSnack(messages: "Enter Email Address")
        }
        else if sPassword == "" {
           showSnack(messages: "Enter Password")
        }
        else {
            ProgressHUDShow(text: "")
            Auth.auth().signIn(withEmail: sEmail!, password: sPassword!) { authResult, error in
                self.ProgressHUDHide()
                if error == nil {
                    
                    if let user = Auth.auth().currentUser {
                        if user.isEmailVerified {
                            self.getUserData(uid: user.uid, showProgress: true)
                        }
                        else {
                            self.sentVerificationEmail()
                        }
                      
                    }
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
        
        
    }
    
}

extension SignInViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

