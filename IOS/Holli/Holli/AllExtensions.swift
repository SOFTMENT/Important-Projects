//
//  AllExtensions.swift
//  Holli
//
//  Created by Vijay on 11/04/21.
//  Copyright © 2021 OriginalDevelopment. All rights reserved.
//

import UIKit


extension UIViewController {
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 160, y: self.view.frame.size.height/2, width: 340, height: 36))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "RobotoCondensed-Regular1", size: 12)
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
}
