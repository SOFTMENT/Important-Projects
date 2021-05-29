//
//  SignInController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 11/01/21.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import MBProgressHUD

class SignInController : UIViewController, UITextFieldDelegate {

    var activeField: UITextField?
    @IBOutlet weak var headImage: UIImageView!
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInTextField: UITextField!
    @IBOutlet weak var signInPasswordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!

    
   
    override func viewDidLoad() {


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
        
        if Auth.auth().currentUser != nil {
           getUserData(uid: Auth.auth().currentUser!.uid,showIntroScreen: false)
        }

        
        let screensize: CGRect = UIScreen.main.bounds
            let screenWidth = screensize.width
            let screenHeight = screensize.height
            var scrollView: UIScrollView!
            scrollView = UIScrollView(frame: CGRect(x: 0, y: 120, width: screenWidth, height: screenHeight))
            scrollView.contentSize = CGSize(width: screenWidth, height: 2000)
        
    
      

        self.signInTextField.layer.cornerRadius = 8
        
     
        self.signInPasswordField.layer.cornerRadius = 8
        
        self.signInButton.layer.cornerRadius = 6
        
        self.signUpButton.layer.cornerRadius = 6
        
        self.signInTextField.delegate = self
        self.signInPasswordField.delegate = self
        
        self.signInTextField.setLeftPaddingPoints(10)
        self.signInTextField.setRightPaddingPoints(10)
        
        self.signInPasswordField.setLeftPaddingPoints(10)
        self.signInPasswordField.setRightPaddingPoints(10)
        
        
        let forgotPasswordTap = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        forgotPasswordLabel.addGestureRecognizer(forgotPasswordTap)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(tapRecognizer)
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(fromAppDelegateForAuth(_:)), name: Constants.kNotification, object: nil)
        
      
    }
    
    
    
    @objc func forgotPasswordTapped() {
        self.navigateToAnotherScreen(mIdentifier: Constants.StroyBoard.recoverMailViewController)
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        self.loginWithFacebook()
    }
    
    
    @IBAction func googleLogin(_ sender: Any) {

        self.loginWithGoogle()
    }
    
    
    @IBAction func twitterLogin(_ sender: Any) {
        self.loginWithTwitter()
      
    }
    

    
  

    
    @objc func fromAppDelegateForAuth(_ sender: Notification) {
       
        if let credential = sender.userInfo?["credential"] as? AuthCredential {
           authWithFirebase(credential: credential,type: "google")
        }
      
    }
    
  
    
    @IBAction func signUp(_ sender: Any) {
        
        self.navigateToAnotherScreen(mIdentifier: Constants.StroyBoard.signUpViewController)
        
    }
    
    @IBAction func signIn(_ sender: Any) {
        let validDateMessage = validatedFields()
        
        if validDateMessage != nil {
            showError(validDateMessage!)
        }
        else {
     
            let email = signInTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = signInPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            ProgressHUDShow(text: "Loading...")
            
            
            Auth.auth().signIn(withEmail: email!, password: password!) { (result, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error != nil {
                    self.handleError(error: error!)
                }
                else {
                    self.getUserData(uid: Auth.auth().currentUser!.uid, showIntroScreen: false)
                }
            }
            
        }
        
    }
    
    

    
  
    
    
    
    
    func validatedFields() -> String? {
        if  (signInTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            signInPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
            {
                return "Please fill in all fields."
            }
        
        return nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    
    @objc func hideKeyBoard() {
        self.view.endEditing(true)
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
 
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    



    
    
}
