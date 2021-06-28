//
//  Extensions.swift
//  Oh Crepe & Waffles
//
//  Created by Vijay on 07/05/21.
//



import UIKit
import Firebase
import MBProgressHUD
import FirebaseFirestoreSwift
import FirebaseAuth


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





extension UIViewController {
    
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
    
    func getViewControllerUsingIdentifier(mIdentifier : String) -> UIViewController{

        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        switch mIdentifier {
        case Constants.StroyBoard.signInViewController:
            return mainStoryboard.instantiateViewController(identifier: mIdentifier)
            
        case Constants.StroyBoard.homeViewController:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier))
     

        default:
            return (mainStoryboard.instantiateViewController(identifier: Constants.StroyBoard.signInViewController) as? SignInViewController)!
        }
    }
    
    
    
    
    func getUserData(uid : String)  {
        ProgressHUDShow(text: "")
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapshot, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error != nil {
                self.showError(error!.localizedDescription)
            }
            else {
                if let user = try? snapshot?.data(as: User.self) {
                    User.data = user
                    
                    self.beRootScreen(mIdentifier: Constants.StroyBoard.homeViewController)
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
    
    func addUserData(data : [String : String], uid : String) {

        ProgressHUDShow(text: "")
        Firestore.firestore().collection("Users").document(uid).setData(data) { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)
           
            if error == nil {
                User.data?.email = data["email"]
                User.data?.name = data["name"]
                User.data?.uid = data["uid"]
                self.beRootScreen(mIdentifier: Constants.StroyBoard.homeViewController)
            }
            else {
                self.showError(error!.localizedDescription)
            }

        }
    }
    
    
    func ProgressHUDShow(text : String) {
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.mode = .indeterminate
        loading.label.font = UIFont(name: "Rubik-Medium", size: 14)
        loading.label.textColor = UIColor.darkGray
        loading.label.text =  text
      
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height/2, width: 300, height: 36))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "Rubik-Medium", size: 12)
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

    



    
    

 
    


    
    func convertDateFormater(_ date: Date) -> String
        {
        let df = DateFormatter()
        df.dateFormat = "dd-MMM-yyyy hh:mm a"
        df.timeZone = TimeZone(abbreviation: "GMT")
        df.timeZone = TimeZone.current
        return df.string(from: date)

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

