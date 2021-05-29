//
//  RecoveryController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 12/01/21.
//

import UIKit
import Firebase
import MBProgressHUD

class RecoveryController : UIViewController, UITextFieldDelegate{
    

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var sendVerifyLinkButton: UIButton!
    @IBOutlet weak var signUpbutton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var recoveryEmailTextField: UITextField!
    
    override func viewDidLoad() {

        self.recoveryEmailTextField.layer.cornerRadius = 8
        
        self.recoveryEmailTextField.setLeftPaddingPoints(10)
        self.recoveryEmailTextField.setRightPaddingPoints(10)
        
        self.signInButton.layer.cornerRadius = 6
        
        self.signUpbutton.layer.cornerRadius = 6
        
        self.sendVerifyLinkButton.layer.cornerRadius = 6
        
        
      
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(tapRecognizer)
       
        
        
        recoveryEmailTextField.delegate = self
    }
    
    @IBAction func signUp(_ sender: Any) {
       
        navigateToAnotherScreen(mIdentifier: Constants.StroyBoard.signUpViewController)
        
    }
    
    @IBAction func sendVerificationLink(_ sender: Any) {
        if let emailId = recoveryEmailTextField.text {
            if emailId.isEmpty {
                showError("Please enter email address")
            }
            else {
                ProgressHUDShow(text: "Sending Link...")
                
                Auth.auth().sendPasswordReset(withEmail: emailId) { (error) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if error != nil {
                        self.handleError(error: error!)
                    }
                    else {
                       
                        let alert = UIAlertController(title: "SUCCESSFUL", message: "Verification link has been sent on your email address.", preferredStyle: .alert)

                        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                            self.dismiss(animated: true, completion: nil)
                        }

                        alert.addAction(okAction)

                        self.present(alert, animated: true, completion: nil)
                    }
                }

            }
        }

    }
    @IBAction func signIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    
    @objc func hideKeyBoard() {
        self.view.endEditing(true)
    }
    

  
    
    
   
    
 
      
}
