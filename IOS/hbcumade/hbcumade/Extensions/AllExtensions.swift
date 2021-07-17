//
//  AllExtensions.swift
//  hbcumade
//
//  Created by Vijay Rathore on 14/01/21.
//


import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import MBProgressHUD




extension UITextView {

    func centerVerticalText() {
    
        let fitSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fitSize)
        let calculate = (bounds.size.height - size.height * zoomScale) / 2
        let offset = max(1, calculate)
        contentOffset.y = -offset
    }
}

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

extension Date {

    func timeAgoSinceDate() -> String {

        // From Time
        let fromDate = self

        // To Time
        let toDate = Date()

        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }

        return "a moment ago"
    }
}



extension UIViewController {
    
    

    
    func generateRef() -> String {
        return  String.init(arc4random_uniform(900000) + 100000) 
        
    }
    
    func ProgressHUDShow(text : String) {
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.mode = .indeterminate
        loading.label.text =  text
        loading.label.font = UIFont(name: "RobotoCondensed-Regular", size: 14)
    }
    
    func ProgressHUDHide(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2, width: 160, height: 36))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "RobotoCondensed-Regular", size: 12)
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

    
    
    func addUserData(data : [String : Any], uid : String, type : String) {
        
       ProgressHUDShow(text: "Loading...")
        
        FirebaseStoreManager.db.collection("Users").document(uid).setData(data) { (error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
          
            if error != nil {
                self.showError(error!.localizedDescription)
            }
            else {
                if type == "custom" {
                    self.getUserData(uid: uid, showProgress: true)
                    
                }
                else {
                    self.getUserData(uid: uid, showProgress: true)
                }
              
            }
                
            }
    }

    
    func getUserData(uid : String, showProgress : Bool)  {
        if showProgress {
            ProgressHUDShow(text: "Loading...")
        }
       
        FirebaseStoreManager.db.collection("Users").document(uid).getDocument { (snapshot, error) in
            if showProgress {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
           
            if error != nil {
                
                self.showError(error!.localizedDescription)
            }
            else {
                
               
                do {
                if let user = try snapshot?.data(as: UserData.self) {
                    UserData.data = user
                   if user.isMobVerified ?? false || user.regiType != "custom" {
                        if let school = user.school {
                            if school != "" {
                                
                                if let coverPic = user.coverImage {
                                    
                                   
                                    if coverPic != "" {
                                        if let hasApproved  = user.hasApproved{
                                            if hasApproved {
                                                self.beRootScreen(mIdentifier: Constants.StroyBoard.tabBarViewController)
                                            }
                                            else {
                                                self.beRootScreen(mIdentifier: Constants.StroyBoard.enterInviteCodeController)
                                            }
                                        }
                                        else {
                                            self.beRootScreen(mIdentifier: Constants.StroyBoard.enterInviteCodeController)
                                        }
                                
                                    }
                                    else {
                                        self.performSegue(withIdentifier: "updateprofileseg", sender: nil)
                                    }
                                }
                                else {
                                    self.performSegue(withIdentifier: "updateprofileseg", sender: nil)
                                }
                               
                            }
                            else {
                                if let customSchoolName = user.customSchoolName {
                                    if customSchoolName != "" {
                                        self.showMessage(title: "Pending", message: "You're account is still pending. We will notify you once your account is approved.")
                                    }
                                    else {
                                        self.performSegue(withIdentifier: "updateseg", sender: nil)
                                    }
                                    
                                }
                                else {
                                    self.performSegue(withIdentifier: "updateseg", sender: nil)
                                }
                                
                            }
                        }
                        else {
                         
                            if let customSchoolName = user.customSchoolName {
                                if customSchoolName != "" {
                                    self.showMessage(title: "Pending", message: "YYou're account is still pending. We will notify you once your account is approved.")
                                }
                                else {
                                    self.performSegue(withIdentifier: "updateseg", sender: nil)
                                }
                                
                            }
                            else {
                                self.performSegue(withIdentifier: "updateseg", sender: nil)
                            }
                        }
                        
                    }
                    else {
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.mobVeriVC)
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
                catch {
                    print(error)
                }
                
            }
        }
      
    }
    
    func navigateToAnotherScreen(mIdentifier : String)  {
       
        let destinationVC = getViewControllerUsingIdentifier(mIdentifier: mIdentifier)
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true) {
           
        }
        
    }
    
    func myPerformSegue(mIdentifier : String)  {
        performSegue(withIdentifier: mIdentifier, sender: nil)
       
    }
    

    
    func getViewControllerUsingIdentifier(mIdentifier : String) -> UIViewController{
    
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        switch mIdentifier {
        case Constants.StroyBoard.mobVeriVC:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? VerifyNumberController)!
          
            
        
        case Constants.StroyBoard.signInViewController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? SignInController)!
          
        case Constants.StroyBoard.homeViewController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? HomeViewController)!
            
        case Constants.StroyBoard.signUpViewController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? SignUpController)!
            
        case Constants.StroyBoard.recoverMailViewController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? RecoveryController)!
            
        case Constants.StroyBoard.enterverificationcodeviewcontroller :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? EnterVerificationCodeController)!
            
        case Constants.StroyBoard.commentViewController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? CommentViewController)!
            
        case Constants.StroyBoard.networkViewController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? NetworkViewController)!
            
        
        case Constants.StroyBoard.profileController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? MainProfile)!
            
        case Constants.StroyBoard.accountSettingsController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? AccountSettingsViewController)!
     
            
        case Constants.StroyBoard.verifiedIntroViewController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? VerifiedIntroController)!
            
        case Constants.StroyBoard.tabBarViewController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? TabBarController)!
            
        case Constants.StroyBoard.exploreViewController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? ExploreViewController)!
        case Constants.StroyBoard.eventViewController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? EventViewController)!
            
        case Constants.StroyBoard.enterInviteCodeController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? EnterInviteCodeController)!
            
    
            
        default:
            return (mainStoryboard.instantiateViewController(identifier: Constants.StroyBoard.signInViewController) as? SignInController)!
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
  
  
    
    func convertDateAndTimeFormater(_ date: Date) -> String
        {
        let df = DateFormatter()
        df.dateFormat = "dd-MMM-yyyy hh:mm a"
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.timeZone = TimeZone.current
        return df.string(from: date)

        }
    
    func convertDateFormater(_ date: Date) -> String
        {
        let df = DateFormatter()
        df.dateFormat = "dd-MMM-yyyy"
        df.timeZone = TimeZone(abbreviation: "UTC")
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

        let okAction = UIAlertAction(title: "Ok", style: .default) { alert in
            if title == "Thank You" {
                self.dismiss(animated: true, completion: nil)
            }
        }

        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)

    }
    
    
    func authWithFirebase(credential : AuthCredential, type : String,displayName : String) {
        
       ProgressHUDShow(text: "Loading...")
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error != nil {
                
                self.handleError(error: error!)
            }
            else {
                let user = authResult!.user
                let ref =  FirebaseStoreManager.db.collection("Users").document(user.uid)
                ref.getDocument { (snapshot, error) in
                    if error != nil {
                        self.showError(error!.localizedDescription)
                    }
                    else {
                        if let doc = snapshot {
                            if doc.exists {
                                self.getUserData(uid: user.uid, showProgress: true)
                                
                            }
                            else {
                                
                                var profilepic = ""
                                var emailId = ""
                                let provider =  user.providerData
                                var name = ""
                                for firUserInfo in provider {
                                    if let email = firUserInfo.email {
                                        emailId = email
                                    }
                                }
                               
                                if type == "apple" {
                                    name = displayName
                                }
                                else {
                                    name = user.displayName!.capitalized
                                }
                                
                                if type == "twitter" {
                                    profilepic = (user.photoURL?.absoluteString.replacingOccurrences(of: "_normal", with: ""))!
                                }
                                else if type == "facebook" {
                                    profilepic = user.photoURL!.absoluteString + "?type=large"
                                }
                                else if type == "google"{
                                    profilepic = user.photoURL!.absoluteString.replacingOccurrences(of: "s96-c", with: "s512-c")
                                }
                                let data = ["name" : name, "email" : emailId,"classification" : "","school":"", "uid" :  user.uid, "registredAt" :  user.metadata.creationDate!,"profile" : profilepic, "isMobVerified" : false,"regiType" : type] as [String : Any]
                                self.addUserData(data:data , uid: user.uid, type: type)
                            }
                        }
                     
                    }
                }
                
            }
         
        }
    }
    
    func loginWithGoogle() {


        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        
    }
    
    func loginWithTwitter() {
        
        
        TwitterProvider.provider.getCredentialWith(nil) { (credential, error) in
            if error != nil {
                
                self.showError(error!.localizedDescription)
            }
            if credential != nil {
                self.authWithFirebase(credential: credential!, type: "twitter",displayName: "")
            }
        }
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
                self.authWithFirebase(credential: credential,type: "facebook",displayName: "")
              }
                
              }
            
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
    
    }
    
    public func logout(){
        do {
            try Auth.auth().signOut()
            self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
        }
        catch {
            
        }
    }

}



extension NSLayoutConstraint {

    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}


extension UIImageView {
    func makeRounded() {
        
        //self.layer.borderWidth = 1
        self.layer.masksToBounds = false
       // self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        
    }
    
    
    
    
}


extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    public var safeAreaFrame: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            return window.safeAreaInsets.bottom
        }
        else  {
            let window = UIApplication.shared.keyWindow
            return window!.safeAreaInsets.bottom
        }
    }
}
