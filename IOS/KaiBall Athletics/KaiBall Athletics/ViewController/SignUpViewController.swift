//
//  SignUpViewController.swift
//  KaiBall Athletics
//
//  Created by Vijay on 21/04/21.
//
import FirebaseAuth
import Firebase
import UIKit
import MBProgressHUD

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signInBtn: UILabel!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var versionCode: UILabel!
    
    @IBOutlet weak var backBtn: UIView!
    
    
    
    override func viewDidLoad() {
        fullNameField.delegate = self
        emailAddressField.delegate = self
        passwordField.delegate = self
        
        fullNameField.setLeftPaddingPoints(10)
        emailAddressField.setLeftPaddingPoints(10)
        passwordField.setLeftPaddingPoints(10)
        
        fullNameField.setRightPaddingPoints(10)
        emailAddressField.setRightPaddingPoints(10)
        passwordField.setRightPaddingPoints(10)
        
        fullNameField.layer.cornerRadius = 4
        emailAddressField.layer.cornerRadius = 4
        passwordField.layer.cornerRadius = 4
        
        createAccountBtn.layer.cornerRadius = 4
        
        //BackBtn
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backToSignIn)))
      
        //BackBtn
        signInBtn.isUserInteractionEnabled = true
        signInBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backToSignIn)))
    }
    
  
    

    @IBAction func createAccountBtnClicked(_ sender: Any) {
        let sName = fullNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sEmail = emailAddressField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sPassword = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sName == "" {
            self.showToast(message: "Enter Full Name")
        }
        else {
            if sEmail == "" {
                self.showToast(message: "Enter Email Address")
            }
            else {
                if sPassword == "" {
                    self.showToast(message: "Enter Password")
                }
                else {
                    
                    ProgressHUDShow(text: "Creating...")
                    Auth.auth().createUser(withEmail: sEmail!, password: sPassword!) { (auth, error) in
                        if error == nil {
                            if let auth = auth {
                                
                                let data = ["uid" : auth.user.uid, "email" : sEmail!,"name" :  sName!.capitalized, "hasMembership" : false] as [String : Any]
                                self.addUserData(data: data , uid: auth.user.uid)
                            }
                          
                        }
                        else {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.handleError(error: error!)
                        }
                    }
                    
                }
            }
        }
    }
    
    
    
    func addUserData(data : [String : Any], uid : String) {

        Firestore.firestore().collection("Users").document(uid).setData(data) { (error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if error != nil {
                self.showError(error!.localizedDescription)
            }
            else {
                
                self.sendEmailVerificationLink()
            }

        }
    }

    
    func sendEmailVerificationLink() {
        Auth.auth().currentUser!.sendEmailVerification { (error) in
            
        }
        
        let alert = UIAlertController(title: "Verify Your Email", message: "We have sent verification link on your mail address.Please Verify email and  continue to Sign In.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true) {
                self.navigationController?.popViewController(animated: true)
            }
         
        }

        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func backToSignIn() {
   
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
extension SignUpViewController : UITextFieldDelegate {
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.dismissKeyboard()
            return true
        }
        
}
