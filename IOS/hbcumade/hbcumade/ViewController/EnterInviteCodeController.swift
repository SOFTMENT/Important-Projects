//
//  EnterInviteCodeController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 13/07/21.
//

import UIKit
import FirebaseFirestoreSwift
import Firebase

class EnterInviteCodeController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var inviteCode: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    override func viewDidLoad() {
        
        inviteCode.setLeftPaddingPoints(10)
        inviteCode.setRightPaddingPoints(10)
        inviteCode.layer.cornerRadius = 8
        inviteCode.delegate = self
        submit.layer.cornerRadius = 8
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(tapRecognizer)
        
    }
    @objc func hideKeyBoard() {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        let sInviteCode = inviteCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sInviteCode!.isEmpty {
            showToast(message: "Enter Invite Code")
        }
        else {
            ProgressHUDShow(text: "")
            Firestore.firestore().collection("InviteCode").document(sInviteCode!).getDocument { document, err in
                self.ProgressHUDHide()
            
                if err == nil {
                    if let doc = document {
                        if doc.exists {
                            self.ProgressHUDShow(text: "")
                           
                            if sInviteCode != "7869992" {
                                
                                Firestore.firestore().collection("InviteCode").document(sInviteCode!).delete()
                                
                            }
                           
                            Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).setData(["hasApproved" : true], merge: true) { error in
                                self.ProgressHUDHide()
                                if err == nil {
                                    self.beRootScreen(mIdentifier: Constants.StroyBoard.tabBarViewController)
                                }
                                else {
                                    self.showError(err!.localizedDescription)
                                }
                            }
                        }
                        else {
                            self.showError("Invite code is not valid or already used.")
                        }
                    }
                    else {
                        self.showError("Invite code is not valid or already used.")
                    }
                }
                else {
                    self.showError(err!.localizedDescription)
                }
            }
        }
    }
    
}
