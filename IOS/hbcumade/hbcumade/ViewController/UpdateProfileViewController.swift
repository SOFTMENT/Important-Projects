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
   
    

    
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var classification: UITextField!
    @IBOutlet weak var designation: UITextField!
    @IBOutlet weak var update: UIButton!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var customSchoolName: UITextField!
    
    var pickerView = UIPickerView()
    var pickerView2 = UIPickerView()
    var schools = [Schools]()
    
    let classificationList = ["Student","Alumni"]
    override func viewDidLoad() {
        
        if Auth.auth().currentUser == nil {
            logout()
        }
        
        //SCHOOL
        school.delegate = self
        
   
        school.layer.cornerRadius = 8
        
        school.setLeftPaddingPoints(10)
        school.setRightPaddingPoints(10)
        
        designation.setRightPaddingPoints(10)
        designation.setLeftPaddingPoints(10)
        self.designation.layer.cornerRadius = 8
       
   
        
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
        
        customSchoolName.delegate = self
        customSchoolName.layer.cornerRadius = 8
        customSchoolName.setLeftPaddingPoints(10)
        customSchoolName.setRightPaddingPoints(10)
        
        
        pickerView2.dataSource = self
        pickerView2.delegate = self
        
      
        classification.inputView = pickerView2
        classification.attributedPlaceholder = NSAttributedString(string: "Choose Classification",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        update.layer.cornerRadius = 6
        submit.layer.cornerRadius = 6
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(tapRecognizer)
        
        getSchools()
    }
    
    
    func getSchools(){
        ProgressHUDShow(text: "")
        Firestore.firestore().collection("Schools").order(by: "name", descending: false).addSnapshotListener { snapshot, error in
            self.ProgressHUDHide()
            if error == nil {
                if let snapshot = snapshot {
                    self.schools.removeAll()
                    for qds in snapshot.documents {
                        if let school = try? qds.data(as: Schools.self) {
                         
                            self.schools.append(school)
                            
                        }
                    }
                    self.pickerView.reloadAllComponents()
                }
            }
        }
        
    }
    
    @objc func hideKeyBoard() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        let sCustomSchoolName = customSchoolName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sClassification = classification.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sDesignation = designation.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       
        if sCustomSchoolName == "" {
            showToast(message: "Enter Your School Name")
        }
        else if sClassification == "" {
            showToast(message: "Choose Classification")
        }
        else if sDesignation == "" {
            showToast(message: "Enter Career")
        }
        else {
            ProgressHUDShow(text: "")
            Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).setData(["hasApproved": false,"customSchoolName" : sCustomSchoolName!,"classification" : sClassification!,"designation" : sDesignation!],merge: true) { error in
                self.ProgressHUDHide()
                if error == nil {
                    self.showMessage(title: "Thank You", message: "We have received your request. We will notify you once your account is approved.")
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
    }
    
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        
        let sClassification = classification.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sSchool = school.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sDesignation = designation.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sSchool == "" {
            showToast(message: "Select School")
        }
        else if sClassification == "" {
            showToast(message: "Select Classification")
        }
        else if sDesignation == "" {
            showToast(message: "Enter Career")
        }
        
        else {
            ProgressHUDShow(text: "")
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
   
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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
            return schools[row].name
        }
        else {
            return classificationList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.pickerView {
            school.text = schools[row].name
            school.resignFirstResponder()
        }
        else {
            classification.text = classificationList[row]
            classification.resignFirstResponder()
        }
    }
    
}



