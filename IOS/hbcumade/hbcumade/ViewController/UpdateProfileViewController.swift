//
//  UpdateProfileViewController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 03/06/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


class UpdateProfileViewController: UIViewController,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
   
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerView {
            return schools.count
        }
        else {
            return classificationList.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerView {
            return schools[row]
        }
        else {
            return classificationList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.pickerView {
           school.text = schools[row]
            school.resignFirstResponder()
        }
        else {
            classification.text = classificationList[row]
            classification.resignFirstResponder()
        }
    }
    
    @IBOutlet weak var inviteCode: UITextField!
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var classification: UITextField!
    @IBOutlet weak var designation: UITextField!
    @IBOutlet weak var update: UIButton!
    
    var pickerView = UIPickerView()
    var pickerView2 = UIPickerView()
    var schools = ["Clark Atlanta University",
                   "Florida A&M University",
                   "Hampton University",
                   "Tennessee State University",
                   "Howard University",
                   "Morehouse College",
                   "Morgan State University",
                   "Norfolk State University",
                   "Spelman College",
                   "Virginia State University"]
    
    
    let classificationList = ["Student","Alumni"]
    override func viewDidLoad() {
        
        if Auth.auth().currentUser == nil {
            logout()
        }
        
        //SCHOOL
        school.delegate = self
        schools.sort()
   
        school.layer.cornerRadius = 8
        
        school.setLeftPaddingPoints(10)
        school.setRightPaddingPoints(10)
        
        designation.setRightPaddingPoints(10)
        designation.setLeftPaddingPoints(10)
        self.designation.layer.cornerRadius = 8
       
        inviteCode.setLeftPaddingPoints(10)
        inviteCode.setRightPaddingPoints(10)
        inviteCode.layer.cornerRadius = 8
        inviteCode.delegate = self
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
      
        school.inputView = pickerView
        school.attributedPlaceholder = NSAttributedString(string: "Choose Your University",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
       
        
        //CLASSFICATION
        classification.delegate = self

        classification.layer.cornerRadius = 8
        
        classification.setLeftPaddingPoints(10)
        classification.setRightPaddingPoints(10)
        
       
        
        pickerView2.dataSource = self
        pickerView2.delegate = self
        
      
        classification.inputView = pickerView2
        classification.attributedPlaceholder = NSAttributedString(string: "Choose Classification",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        update.layer.cornerRadius = 6
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(tapRecognizer)
        
    }
    @objc func hideKeyBoard() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        
        let sClassification = classification.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sSchool = school.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sDesignation = designation.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sInviteCode = inviteCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if sSchool == "" {
            showToast(message: "Select School")
        }
        else if sClassification == "" {
            showToast(message: "Select Classification")
        }
        else if sDesignation == "" {
            showToast(message: "Enter Designation")
        }
        else if sInviteCode == "" {
            showToast(message: "Enter Invite Code")
        }
        else {
            ProgressHUDShow(text: "")
            
            Firestore.firestore().collection("InviteCode").document(sInviteCode!).getDocument { document, err in
                self.ProgressHUDHide()
                if err == nil {
                    if let doc = document {
                        if doc.exists {
                            
                            Firestore.firestore().collection("InviteCode").document(sInviteCode!).delete()
                            self.ProgressHUDShow(text: "Updating...")
                            Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).setData(["classification" : sClassification!,"school": sSchool!,"designation" : sDesignation!], merge: true) { error in
                                self.ProgressHUDHide()
                                if error == nil {
                                    self.performSegue(withIdentifier: "updateprofileseg", sender: nil)
                                }
                                else {
                                    self.showError(error!.localizedDescription)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
