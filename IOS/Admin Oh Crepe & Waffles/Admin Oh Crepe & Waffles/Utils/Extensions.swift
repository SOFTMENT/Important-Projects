//
//  Extensions.swift
//  Admin Oh Crepe & Waffles
//
//  Created by Vijay on 08/05/21.
//


import UIKit
import Firebase
import MBProgressHUD
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





extension UIViewController {
    
    func sendPushNotification() {
    
    //1. Create the alert controller.
    let alert = UIAlertController(title: "Notification", message: "Send Notification to All Users", preferredStyle: .alert)

    //2. Add the text field. You can configure it however you need.
    alert.addTextField { (textField) in
        textField.placeholder = "Enter Title"
    }
    //2. Add the text field. You can configure it however you need.
    alert.addTextField { (textField) in
        textField.placeholder = "Enter Message"
    }

    // 3. Grab the value from the text field, and print it when the user clicks OK.
    alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak alert] (_) in
        let textField = alert?.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines) // Force unwrapping because we know it exists.
        let textField1 = alert?.textFields![1].text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if (!textField!.isEmpty && !textField1!.isEmpty) {
            PushNotificationSender().sendPushNotification(title: textField!, body: textField1!)
            self.showToast(message: "Notification has been sent")
        }
        else {
            self.showToast(message: "Please Enter Title & Message")
        }
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
     
        alert.dismiss(animated: true, completion: nil)
    }))

    // 4. Present the alert.
    self.present(alert, animated: true, completion: nil)
    
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

    



    
    

 
    


    
    func convertDateAndTimeFormater(_ date: Date) -> String
        {
        let df = DateFormatter()
        df.dateFormat = "dd-MMM-yyyy, hh:mm aa"
        df.timeZone = TimeZone(abbreviation: "GMT")
        df.timeZone = TimeZone.current
        return df.string(from: date)

        }
    
    func convertDateFormater(_ date: Date) -> String
        {
        let df = DateFormatter()
        df.dateFormat = "dd-MMM-yyyy"
        df.timeZone = TimeZone(abbreviation: "GMT")
        df.timeZone = TimeZone.current
        return df.string(from: date)

        }
    
    func convertTimeFormater(_ date: Date) -> String
        {
        let df = DateFormatter()
        df.dateFormat = "hh:mm aa"
        df.timeZone = TimeZone(abbreviation: "GMT")
        df.timeZone = TimeZone.current
        return df.string(from: date)

        }

    
    func convertStringToDate(sDate : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter.date(from: sDate)!
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

