//
//  SignInViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 29/03/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import TTGSnackbar
import Firebase
import LocalAuthentication


class SignInViewController: UIViewController, UITextFieldDelegate{
  
  
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetButton: UILabel!
    
    @IBOutlet weak var guest: UIButton!
    let progress = ProgressHUD(text: "Sign In...")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(progress)
        
        
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

        
        guest.layer.borderWidth = 1
        guest.layer.borderColor = UIColor.red.cgColor
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter Email Address",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter Password",
              attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        // Do any additional setup after loading the view.
        
       
               let mailImage = UIImage(named: "icons8-important-mail-100")!
                     
                     let passwordImage = UIImage(named: "icons8-lock-100")!
        
        
                     
        emailTextField.setLeftIcons(icon: mailImage)
        passwordTextField.setLeftIcons(icon: passwordImage)
        
        forgetButton.isUserInteractionEnabled = true
        forgetButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgetTapped)))
 
        
    }
    @objc func forgetTapped() {
        if !emailTextField.text!.isEmpty {
            self.progress.text = "Wait..."
            
            progress.show()
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
                self.progress.hide()
                self.progress.text = "Sign In..."
                if error == nil {
                    
                     let alert =  UIAlertController.init(title: "RESET PASSWORD", message: "WE HAVE SEND PASSWORD RESET LINK ON YOUR MAIL ID.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        
                    }))
                    
                    self.present(alert,animated: true,completion: nil)
                }
                
            }
        }
        else {
             self.showToast(messages: "Enter Email Address")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let user = Auth.auth().currentUser

        if user != nil {
            let context = LAContext()
            var error : NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify Yourself!"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self](success, autherror) in
                    DispatchQueue.main.async {
                        if success {
                            self?.performSegue(withIdentifier: "tabbarseg", sender: nil)
                        }
                        else {
                            
                        }
                    }
                }
            }
            else {
                self.performSegue(withIdentifier: "tabbarseg", sender: nil)
            }
        }
    
                 
                  
                
              
        
    }
    
    
    
    
    

    
    @IBAction func signUpClicked(_ sender: Any) {
        performSegue(withIdentifier: "signup", sender: nil)
               
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func logInAsAguestClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "tabbarseg", sender: nil)
    }
    
    
    @IBAction func SignInButtonClicked(_ sender: Any) {
        
        let sEmail = emailTextField.text!
        let sPassword = passwordTextField.text!
        
        if sEmail.isEmpty {
            showToast(messages: "Email Address is Required")
        }
        else {
            if sPassword.isEmpty {
                showToast(messages: "Password is Required")
            }
            else {
                
                progress.show()
                
            
                Auth.auth().signIn(withEmail: sEmail, password: sPassword) { (result, error) in
                    if error != nil {
                        
                        self.progress.hide()
                        if let error_code = AuthErrorCode(rawValue: error!._code) {
                        
                        self.showToast(messages: error_code.errorMessage)
                            
                            
                        }
                    }
                    else {
                        self.progress.hide()

                        if !(Auth.auth().currentUser!.isEmailVerified) {
                            self.resendLink()
                        }
                        else {
                            self.performSegue(withIdentifier: "tabbarseg", sender: nil)
                        }
                        
                        
                    }
                }
                
            }
        }
        
        
    }
    
    func showToast(messages : String) {
           
           
           let snackbar = TTGSnackbar(message: messages, duration: .long)
           snackbar.messageLabel.textAlignment = .center
           snackbar.show()
       }
  
    func resendLink() {
        let resendAlert = UIAlertController(title: "Rapid Collect", message: "You have not confirmed your email address yet. Please confirm before login.", preferredStyle: .alert)
        progress.text = "Sending Confirmation Link..."

        progress.show()
        let  resendAction1 = UIAlertAction(title: "Resend Confirmation Link", style: .default) { (alert) in
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
               
                self.progress.hide()
                if error == nil {
                    self.showToast(messages: "Done! Check your email address")
                    
                }
                else {
                    self.showToast(messages: error!.localizedDescription)
                }
            })
        }
        
        let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        resendAlert.addAction(resendAction1)
        resendAlert.addAction(cancelAlert)
        
        self.present(resendAlert,animated: true,completion: nil)
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UITextField {

 /// set icon of 20x20 with left padding of 8px
 func setLeftIcons(icon: UIImage) {

    let padding = 8
    let size = 20

    let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
    let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
    iconView.image = icon
    outerView.addSubview(iconView)

    leftView = outerView
    leftViewMode = .always
  }
    
    
    
}


extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
        case .tooManyRequests :
            return "Too may requests. Please try again later."
        
    
        default:
            return "Unknown error occurred"
        }
    }
}
