//
//  Extensions.swift
//  Awakening Clarity Now
//
//  Created by Vijay on 14/05/21.
//

import UIKit
import MBProgressHUD
import FirebaseAuth
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FirebaseFirestoreSwift

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
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
        case .accountExistsWithDifferentCredential:
            return "An account already exists with the same email address but different sign-in method."
        
        default:
            return "Unknown error occurred"
        }
    }
}


extension UIViewController {
    
  
    
    
    func loginWithGoogle() {


        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        
    }
    
    func loginWithFacebook() {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
            if (error == nil){
                
                let fbloginresult : LoginManagerLoginResult = result!
              // if user cancel the login
                if (result?.isCancelled)!{
                      return
                }
             
               
              if(fbloginresult.grantedPermissions.contains("email"))
              { if((AccessToken.current) != nil){
               
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                self.authWithFirebase(credential: credential,type: "facebook", mName: "")
              }
                
              }
            
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
    
        
        
    }
    
    func convertTimeFormater(_ date: Date) -> String
        {
        let df = DateFormatter()
        df.dateFormat = "hh:mm aa"
        df.timeZone = TimeZone(abbreviation: "GMT")
        df.timeZone = TimeZone.current
        return df.string(from: date)

        }
    
    func authWithFirebase(credential : AuthCredential, type : String,mName : String) {
        
       ProgressHUDShow(text: "Loading...")
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error != nil {
                
                self.handleError(error: error!)
            }
            else {
                let user = authResult!.user
                let ref = Firestore.firestore().collection("Users").document(user.uid)
                ref.getDocument { (snapshot, error) in
                    if error != nil {
                        self.showError(error!.localizedDescription)
                    }
                    else {
                        if let doc = snapshot {
                            if doc.exists {
                                self.getUserData(uid: user.uid)
                                
                            }
                            else {
                                
                     
                                var emailId = ""
                                var displayName = ""
                                let provider =  user.providerData
                                for firUserInfo in provider {
                                    if let email = firUserInfo.email {
                                        emailId = email
                                    }
                                }
                               
                                if type == "apple" {
                                    displayName = mName.capitalized
                                }
                                else {
                                    displayName = user.displayName!.capitalized
                                }
                               
                                let data = ["name" : displayName, "emailAddress" : emailId,"uid":Auth.auth().currentUser!.uid,"registrationDate" : FieldValue.serverTimestamp(),"mobileNumber" : "","type" : type] as [String : Any]
                                
                                self.addUserData(data:data , uid: user.uid)
                            }
                        }
                     
                    }
                }
                
            }
         
        }
    }
    
  
    func addUserData(data : [String : Any], uid : String) {
        
       ProgressHUDShow(text: "Loading...")
        
        Firestore.firestore().collection("Users").document(uid).setData(data) { (error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
          
            if error != nil {
                self.showError(error!.localizedDescription)
            }
            else {
               
                    self.getUserData(uid: uid)
                
              
            }
                
        }
    }
    func getUserData(uid : String)  {
        ProgressHUDShow(text: "Loading...")
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapshot, error) in
            self.ProgressHUDHide()
            if error != nil {
                self.showError(error!.localizedDescription)
            }
            else {
                if let user = try? snapshot?.data(as: UserModel.self) {
                    UserModel.data = user
                    if user.emailAddress == "support@acn.com" {
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.adminHomeViewController)
                    }
                    else{
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.tabViewController)
                    }
                       
                }
                else {
                    do {
                    try Auth.auth().signOut()
                    }
                    catch {
                        
                    }
                    self.showError("Your record has been deleted")
                }
            }
        }

    }
    
    func getViewControllerUsingIdentifier(mIdentifier : String) -> UIViewController{

        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        switch mIdentifier {
        case Constants.StroyBoard.signInViewController:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? UINavigationController)!
            
        case Constants.StroyBoard.tabViewController:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? UITabBarController)!
            
        case Constants.StroyBoard.adminHomeViewController:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? AdminHomeViewController)!
            
        default:
            return (mainStoryboard.instantiateViewController(identifier: Constants.StroyBoard.signInViewController) as? UINavigationController)!
        }
    }
    
    func beRootScreen(mIdentifier : String) {


        guard let window = self.view.window else {
            self.view.window?.rootViewController = getViewControllerUsingIdentifier(mIdentifier: mIdentifier)
            self.view.window?.makeKeyAndVisible()
                return
            }

            window.rootViewController = getViewControllerUsingIdentifier(mIdentifier: mIdentifier)
            window.makeKeyAndVisible()
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)

    }
    func convertDateFormater(_ date: Date) -> String
        {
        let df = DateFormatter()
        df.dateFormat = "dd-MMM-yyyy"
        df.timeZone = TimeZone(abbreviation: "GMT")
        df.timeZone = TimeZone.current
        return df.string(from: date)

        }
    
    func convertDateAndTimeFormater(_ date: Date) -> String
        {
        let df = DateFormatter()
        df.dateFormat = "dd-MMM-yyyy hh:mm a"
        df.timeZone = TimeZone(abbreviation: "GMT")
        df.timeZone = TimeZone.current
        return df.string(from: date)

        }
    
    func handleError(error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
        
            showError(errorCode.errorMessage)
        }
    }
    
    func showError(_ message : String) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)

    }
    
    func showMessage(title : String,message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)

    }
    
    

    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height/2, width: 300, height: 36))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "SF-Mono-Regular", size: 12)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseIn, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func ProgressHUDShow(text : String) {
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.mode = .indeterminate
        loading.label.font = UIFont(name: "Helvetica", size: 15)
        loading.label.textColor = UIColor.darkGray
        loading.label.text =  text
      
    }
    
    func ProgressHUDHide()  {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

}

