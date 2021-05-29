//
//  ViewController.swift
//  KaiBall Athletics
//
//  Created by Vijay on 21/04/21.
//

import UIKit
import MBProgressHUD
import Firebase
import FirebaseAuth
import FirebaseMessaging

class SignInViewController: UIViewController {

    
    
    @IBOutlet weak var versionCode: UILabel!
    @IBOutlet weak var skipNow: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var resetPassword: UILabel!
    @IBOutlet weak var enterPasswordField: UITextField!
    @IBOutlet weak var createNewAccount: UILabel!
    @IBOutlet weak var enterEmailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SUBSCRIBE TO TOPIC
        Messaging.messaging().subscribe(toTopic: "kaiball"){ error in
                if error == nil{
                    print("Subscribed to topic")
                }
                else{
                    print("Not Subscribed to topic")
                }
            }
      
        
        
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
        
        //SKIP
        skipNow.isUserInteractionEnabled = true
        skipNow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(skipBtnTapped)))
        
        enterEmailField.delegate = self
        enterPasswordField.delegate = self
        
        enterPasswordField.setLeftPaddingPoints(10)
        enterEmailField.setLeftPaddingPoints(10)
        
        enterPasswordField.setRightPaddingPoints(10)
        enterEmailField.setRightPaddingPoints(10)
        
        enterEmailField.layer.cornerRadius = 4
        enterPasswordField.layer.cornerRadius = 4
        
        loginButton.layer.cornerRadius = 4
        
        //ResetPassword
        resetPassword.isUserInteractionEnabled = true
        resetPassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sentResetPasswordLink)))
     
        //CreateAccount
        createNewAccount.isUserInteractionEnabled = true
        createNewAccount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createAccountBtnClicked)))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func skipBtnTapped() {
       
        let user = User()
        user.email = "guest@kaiball.com"
        user.name = "Guest"
        user.uid = "123456789"
        user.hasMembership = false
        User.data =  user
        beRootScreen(mIdentifier: Constants.StroyBoard.homeViewController)
  
    }
    
    @objc func sentResetPasswordLink() {
        
        let email = enterEmailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if email == "" {
            self.showToast(message: "Please enter email address")
        }
        
        else {
            self.ProgressHUDShow(text: "Wait...")
            Auth.auth().sendPasswordReset(withEmail: email!) { error in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    self.showMessage(title: "Reset Password", message: "Reset password link has sent on your mail address.")
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
    }
    
    @objc func createAccountBtnClicked() {
        
        performSegue(withIdentifier: "signupseg", sender: nil)
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        let sEmail = enterEmailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sPassword = enterPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sEmail == "" {
            self.showToast(message: "Enter Email Address")
        }
        else {
            if sPassword == "" {
                self.showToast(message: "Enter Password")
            }
            else {
                ProgressHUDShow(text: "Wait...")
                Auth.auth().signIn(withEmail: sEmail!, password: sPassword!) { (auth, error) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if error == nil {
                        if(Auth.auth().currentUser?.email?.lowercased() == "support@kaiball.com") {
                            self.beRootScreen(mIdentifier: Constants.StroyBoard.adminHomeViewController)
                        }
                        else if auth!.user.isEmailVerified {
                    
                            self.getUserData(uid: auth!.user.uid)
                        }
                        else {
                            self.sendEmailVerificationLink()
                        }
                    }
                    else {
                       
                        self.handleError(error: error!)
                    }
                }
            }
        }
        
        
    }
    
    func sendEmailVerificationLink() {
        Auth.auth().currentUser!.sendEmailVerification { (error) in
            
        }
        
        let alert = UIAlertController(title: "Verify Your Email", message: "We have sent verification link on your mail address.Please Verify email and  continue to Sign In.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default,handler: nil)
         
    
        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            if Auth.auth().currentUser!.isEmailVerified {
        
                self.getUserData(uid: Auth.auth().currentUser!.uid)
            }
            else if(Auth.auth().currentUser?.email?.lowercased() == "support@kaiball.com") {
               
                DispatchQueue.main.async {
                    self.beRootScreen(mIdentifier: Constants.StroyBoard.adminHomeViewController)
                }
               
            }
            
          
        }
        
        
        
    }
    
}


extension SignInViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
    
}
