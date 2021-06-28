//
//  CreateViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay on 14/05/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreSwift
import Firebase

class CreateViewController: UIViewController {
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var termsAndConditions: UILabel!
    @IBOutlet weak var backBtn: UIImageView!
    
    
    override func viewDidLoad() {
        
        emailAddress.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        confirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        firstName.attributedPlaceholder = NSAttributedString(string: "First Name",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        lastName.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        mobileNumber.attributedPlaceholder = NSAttributedString(string: "Mobile Number (Optional)",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        emailAddress.setLeftPaddingPoints(10)
        emailAddress.setRightPaddingPoints(10)
        emailAddress.layer.cornerRadius = 12
        
        password.setLeftPaddingPoints(10)
        password.setRightPaddingPoints(10)
        password.layer.cornerRadius = 12
        
        confirmPassword.setLeftPaddingPoints(10)
        confirmPassword.setRightPaddingPoints(10)
        confirmPassword.layer.cornerRadius = 12
        
        firstName.setLeftPaddingPoints(10)
        firstName.setRightPaddingPoints(10)
        firstName.layer.cornerRadius = 12
        
        lastName.setLeftPaddingPoints(10)
        lastName.setRightPaddingPoints(10)
        lastName.layer.cornerRadius = 12
        
        mobileNumber.setLeftPaddingPoints(10)
        mobileNumber.setRightPaddingPoints(10)
        mobileNumber.layer.cornerRadius = 12
        
        createAccount.layer.cornerRadius = 12
        
        //backbtnclicked
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backPreseed)))
        
    }
    
    @objc func backPreseed(){
        navigationController?.popViewController(animated: true)
    }
    @IBAction func createAccountTapped(_ sender: Any) {
        
        let sEmail = emailAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sPassword = password.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sConfirmPassword = confirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sFirstName = firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sLastName = lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sMobileNumber = mobileNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sEmail == "" {
            showToast(message: "Enter Email Address")
        }
        else if sPassword == "" {
            showToast(message: "Enter Password")
        }
        else if sConfirmPassword == "" {
            showToast(message: "Enter Confirm Password")
        }
        else if sFirstName == "" {
            showToast(message: "Enter First Name")
        }
        else if sLastName == "" {
            showToast(message: "Enter Last Name")
        }
        else if sPassword != sConfirmPassword {
            showToast(message: "Password Does Not Match")
        }
        else {
            ProgressHUDShow(text: "Creating Account...")
            Auth.auth().createUser(withEmail: sEmail!, password: sPassword!) { result, error in
               
                if error == nil {
                    self.addUser(sFirstName: sFirstName!, sLastName: sLastName!,sMobile: sMobileNumber!,sEmail: sEmail!)
                }
                else {
                    self.ProgressHUDHide()
                    self.handleError(error: error!)
                }
            }
        }
        
    }
    
    func addUser(sFirstName : String, sLastName : String, sMobile : String, sEmail : String){
        if Auth.auth().currentUser != nil {
            let uid = Auth.auth().currentUser!.uid
            let sName = sFirstName + " "+sLastName
            Firestore.firestore().collection("Users").document(uid).setData(["uid" : uid,"name":sName,"mobileNumber":sMobile,"emailAddress" : sEmail,"registrationDate" : FieldValue.serverTimestamp() ,"type" : "custom"]) { error in
                
                if error == nil {
                    Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                        self.ProgressHUDHide()
                        self.showMessage(title: "VERIFY EMAIL ADDRESS", message: "We have sent verification link on your mail address")
                        
                    })
                }
                else {
                    self.ProgressHUDHide()
                    self.showError(error!.localizedDescription)
                }
                
            }
        }
        else {
            self.ProgressHUDHide()
        }
    }
}
