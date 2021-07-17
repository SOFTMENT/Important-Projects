//
//  AdminHomeController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 13/07/21.
//

import UIKit

class AdminHomeController: UIViewController {
    
    @IBOutlet weak var manageWaitlistView: UIView!
    
    @IBOutlet weak var waitListSchoolView: UIView!
    override func viewDidLoad() {
        
        manageWaitlistView.layer.cornerRadius = 8
        manageWaitlistView.dropShadow()
        manageWaitlistView.isUserInteractionEnabled = true
        manageWaitlistView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(manageWaitListBtnClicked)))
        
        
        waitListSchoolView.layer.cornerRadius = 8
        waitListSchoolView.dropShadow()
        waitListSchoolView.isUserInteractionEnabled = true
        waitListSchoolView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(manageWaitListSchoolBtnClicked)))
    }
    
    @objc func manageWaitListBtnClicked(){
        performSegue(withIdentifier: "waitlistseg", sender: nil)
    }
    
    @objc func manageWaitListSchoolBtnClicked(){
        performSegue(withIdentifier: "waitlistschoolseg", sender: nil)
    }
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
