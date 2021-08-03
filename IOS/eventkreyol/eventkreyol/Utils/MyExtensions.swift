//
//  MyExtensions.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 18/07/21.
//

import UIKit
import FirebaseFirestore
import Firebase
import MBProgressHUD
import TTGSnackbar
import GoogleSignIn



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

    func loginWithGoogle() {
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func showSnack(messages : String) {
           
           
           let snackbar = TTGSnackbar(message: messages, duration: .long)
           snackbar.messageLabel.textAlignment = .center
           snackbar.show()
       }
    
    func ProgressHUDShow(text : String) {
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.mode = .indeterminate
        loading.label.text =  text
        loading.label.font = UIFont(name: "RobotoCondensed-Regular", size: 13)
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

    func sentVerificationEmail(){
        self.ProgressHUDShow(text: "")
        Auth.auth().currentUser!.sendEmailVerification { error in
            self.ProgressHUDHide()
            if error == nil {
                self.showMessage(title: "Verify Your Email", message: "We have sent verification mail on your email address. Please verify your email address before Sign In.",shouldDismiss: true)
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
    }
    
    
    func addUserData(data : [String : Any], uid : String, type : String) {
        
       ProgressHUDShow(text: "")
        
        Firestore.firestore().collection("Users").document(uid).setData(data) { (error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
          
            if error != nil {
                self.showError(error!.localizedDescription)
            }
            else {
                
                if type == "custom" {
                    if let user = Auth.auth().currentUser {
                        if user.isEmailVerified {
                            self.getUserData(uid: uid, showProgress: true)
                        }
                        else {
                            self.sentVerificationEmail()
                        }
                        
                    }
                }
                else {
                    self.getUserData(uid: uid, showProgress: true)
                }
                  
                
              
            }
                
        }
    }

    
    func getUserData(uid : String, showProgress : Bool)  {
        if showProgress {
            ProgressHUDShow(text: "")
        }
       
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapshot, error) in
            if showProgress {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
           
            if error != nil {
                
                self.showError(error!.localizedDescription)
            }
            else {
                
                    if let snapshot = snapshot {
                        if snapshot.exists {
                            do {
                                if let user = try snapshot.data(as: UserData.self){
                                    UserData.data = user
                                    self.beRootScreen(mIdentifier: Constants.StroyBoard.tabBarViewController)
                                    
                                }
                                else {
                                    if let user = Auth.auth().currentUser {
                                        user.delete { error in
                                            if error != nil {
                                                print(error!.localizedDescription)
                                            }
                                    
                                        }
                                        self.showError("Your account is not available. Please register your account.")
                                    }
                                }
                            }
                            catch {
                                print(error.localizedDescription)
                            }
                          
                        }
                        else {
                            if let user = Auth.auth().currentUser {
                                user.delete { error in
                                    if error != nil {
                                        print(error!.localizedDescription)
                                    }
                            
                                }
                                self.showError("Your account is not available. Please register your account.")
                            }
                        }
                           
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
        case Constants.StroyBoard.signInViewController:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? SignInViewController)!
            
        case Constants.StroyBoard.homeViewController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? HomeViewController)!
            
        case Constants.StroyBoard.tabBarViewController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? UITabBarController )!
          
        default:
            return (mainStoryboard.instantiateViewController(identifier: Constants.StroyBoard.signInViewController) as? SignInViewController)!
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
    
    func showMessage(title : String,message : String, shouldDismiss : Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok",style: .default) { action in
            if shouldDismiss {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        

        alert.addAction(okAction)        
        self.present(alert, animated: true, completion: nil)

    }
    
    
    func authWithFirebase(credential : AuthCredential, type : String,displayName : String) {
        
       ProgressHUDShow(text: "")
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error != nil {
                
                self.handleError(error: error!)
            }
            else {
                let user = authResult!.user
                let ref =  Firestore.firestore().collection("Users").document(user.uid)
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
                                
                                var profilepic = "https://firebasestorage.googleapis.com/v0/b/eventkreyol.appspot.com/o/profile-placeholder.jpg?alt=media&token=cb60876c-f59f-4eb4-bcdc-ccb80e5d9a4f"
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
                                                        
                                if type == "google"{
                                    profilepic = user.photoURL!.absoluteString.replacingOccurrences(of: "s96-c", with: "s512-c")
                                }
                                
                                let data = ["fullName" : name, "email" : emailId, "uid" :  user.uid, "registredAt" :  user.metadata.creationDate!,"profilePic" : profilepic, "regiType" : type] as [String : Any]
                                self.addUserData(data:data , uid: user.uid, type: type)
                            }
                        }
                     
                    }
                }
                
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
    
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 1.8)
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                     y: bounds.maxY - layer.shadowRadius,
                                                     width: bounds.width,
                                                     height: layer.shadowRadius)).cgPath
    }
    
    func installBlurEffect(isTop : Bool) {
        self.backgroundColor = UIColor.clear
        var blurFrame = self.bounds
       
        if isTop {
            var statusBarHeight : CGFloat = 0.0
            if #available(iOS 13.0, *) {
                let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            } else {
                statusBarHeight = UIApplication.shared.statusBarFrame.height
            }
            
            blurFrame.size.height += statusBarHeight
            blurFrame.origin.y -= statusBarHeight
            
        }
        else {
            let window = UIApplication.shared.windows[0]
            let bottomPadding = window.safeAreaInsets.bottom
            blurFrame.size.height += bottomPadding
          //  blurFrame.origin.y += bottomPadding
        }
        let blur = UIBlurEffect(style:.light)
        let visualeffect = UIVisualEffectView(effect: blur)
        visualeffect.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 0.7)
        visualeffect.frame = blurFrame
        self.addSubview(visualeffect)
    }
 
    func dropShadow(scale: Bool = true) {
               layer.masksToBounds = false
               layer.shadowColor = UIColor.black.cgColor
               layer.shadowOpacity = 0.3
               layer.shadowOffset = .zero
               layer.shadowRadius = 2
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
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           layer.mask = mask
       }
}


