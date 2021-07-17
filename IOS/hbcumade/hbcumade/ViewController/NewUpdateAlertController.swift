//
//  NewUpdateAlertController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 14/07/21.
//

import UIKit

class NewUpdateAlertController: UIViewController {
    

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var ignore: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var message: UILabel!
    let standard = UserDefaults.standard
    var sMessage : String?
    var version : String = "1"
    override func viewDidLoad() {
      
        updateBtn.layer.cornerRadius = 8
        myView.layer.cornerRadius = 8
        ignore.isUserInteractionEnabled = true
        ignore.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissBtnTapped)))
        
        if let sMessage = sMessage {
            message.text = sMessage
        }
    }
    
    @IBAction func update(_ sender: Any) {
        standard.setValue(true, forKey: version)
        standard.synchronize()
        if let url = URL(string: "itms-apps://apple.com/app/id1551241222") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func dismissBtnTapped(){
        
        standard.setValue(true, forKey: version)
        standard.synchronize()
        self.dismiss(animated: true, completion: nil)
    }
    
}
