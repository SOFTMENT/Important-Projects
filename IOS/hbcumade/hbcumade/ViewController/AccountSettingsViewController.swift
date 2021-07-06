//
//  AccountSettingsViewController.swift
//  hbcumade
//
//  Created by Vijay on 04/04/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class AccountSettingsViewController  : BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerView {
            return schoolList.count
        }
        else {
            return classificationList.count
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerView {
            return schoolList[row]
        }
        else {
            return classificationList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.pickerView {
            schoolName.text = schoolList[row]
            schoolName.resignFirstResponder()
        }
        else {
            classification.text = classificationList[row]
            classification.resignFirstResponder()
        }
    }
    
    @IBOutlet weak var personalInfoTextView: UITextView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameEditField: UITextField!
    
    @IBOutlet weak var birthDayEditField: UITextField!
    
    @IBOutlet weak var phoneNumberEditField: UITextField!
    
   
    @IBOutlet weak var instagramUsername: UITextField!
    
    
    @IBOutlet weak var twitterUsername: UITextField!
    

    
    @IBOutlet weak var schoolName: UITextField!
    
    @IBOutlet weak var designation: UITextField!
    
    
    @IBOutlet weak var major: UITextField!
    
    @IBOutlet weak var classification: UITextField!
    
    @IBOutlet weak var graduationDate: UITextField!
    
    @IBOutlet weak var primaryEmail: UITextField!
    
    @IBOutlet weak var secondaryEmail: UITextField!
    
    @IBOutlet weak var currentPassword: UITextField!
    
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var repeatPassword: UITextField!
    
    
    @IBOutlet weak var personalInfoSave: UIButton!
    
    @IBOutlet weak var schoolInfoSave: UIButton!
    
    @IBOutlet weak var emailAddressSave: UIButton!
    
    @IBOutlet weak var passwordSave: UIButton!
    
    
    @IBOutlet weak var passwordView: UIView!
    
    let dobPicker = UIDatePicker()
    let graduationPicker = UIDatePicker()
    
    var pickerView = UIPickerView()
    var pickerView2 = UIPickerView()
    
    var schoolList = ["Clark Atlanta University",
                   "Florida A&M University",
                   "Hampton University",
                   "Howard University",
                   "Morehouse College",
                   "Tennessee State University",
                   "Morgan State University",
                   "Norfolk State University",
                   "Spelman College",
                   "Virginia State University"]
    
    let classificationList = ["Student","Alumni"]
    
    override func viewDidLoad() {
        
        
        schoolList.sort()
        
        personalInfoTextView.layer.cornerRadius = 4
        personalInfoTextView.layer.borderWidth = 1.2
        personalInfoTextView.layer.borderColor = UIColor.black.cgColor
        personalInfoTextView.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10); 
        
        firstNameTextField.layer.cornerRadius = 4
        firstNameTextField.layer.borderWidth = 1.2
        firstNameTextField.layer.borderColor = UIColor.black.cgColor
        firstNameTextField.setRightPaddingPoints(10)
        firstNameTextField.setLeftPaddingPoints(10)
        
        lastNameEditField.layer.cornerRadius = 4
        lastNameEditField.layer.borderWidth = 1.2
        lastNameEditField.layer.borderColor = UIColor.black.cgColor
        lastNameEditField.setRightPaddingPoints(10)
        lastNameEditField.setLeftPaddingPoints(10)
        
        birthDayEditField.layer.cornerRadius = 4
        birthDayEditField.layer.borderWidth = 1.2
        birthDayEditField.layer.borderColor = UIColor.black.cgColor
        birthDayEditField.setRightPaddingPoints(10)
        birthDayEditField.setLeftPaddingPoints(10)
        
        
        phoneNumberEditField.layer.cornerRadius = 4
        phoneNumberEditField.layer.borderWidth = 1.2
        phoneNumberEditField.layer.borderColor = UIColor.black.cgColor
        phoneNumberEditField.setRightPaddingPoints(10)
        phoneNumberEditField.setLeftPaddingPoints(10)
        
        instagramUsername.layer.cornerRadius = 4
        instagramUsername.layer.borderWidth = 1.2
        instagramUsername.layer.borderColor = UIColor.black.cgColor
        instagramUsername.setRightPaddingPoints(10)
        instagramUsername.setLeftPaddingPoints(10)
        
        twitterUsername.layer.cornerRadius = 4
        twitterUsername.layer.borderWidth = 1.2
        twitterUsername.layer.borderColor = UIColor.black.cgColor
        twitterUsername.setRightPaddingPoints(10)
        twitterUsername.setLeftPaddingPoints(10)
     
        schoolName.layer.cornerRadius = 4
        schoolName.layer.borderWidth = 1.2
        schoolName.layer.borderColor = UIColor.black.cgColor
        schoolName.setRightPaddingPoints(10)
        schoolName.setLeftPaddingPoints(10)
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
      
        schoolName.inputView = pickerView
        
        designation.layer.cornerRadius = 4
        designation.layer.borderWidth = 1.2
        designation.layer.borderColor = UIColor.black.cgColor
        designation.setRightPaddingPoints(10)
        designation.setLeftPaddingPoints(10)
        
        major.layer.cornerRadius = 4
        major.layer.borderWidth = 1.2
        major.layer.borderColor = UIColor.black.cgColor
        major.setRightPaddingPoints(10)
        major.setLeftPaddingPoints(10)
        
        classification.layer.cornerRadius = 4
        classification.layer.borderWidth = 1.2
        classification.layer.borderColor = UIColor.black.cgColor
        classification.setRightPaddingPoints(10)
        classification.setLeftPaddingPoints(10)
        
        pickerView2.dataSource = self
        pickerView2.delegate = self
        
      
        classification.inputView = pickerView2
        
        graduationDate.layer.cornerRadius = 4
        graduationDate.layer.borderWidth = 1.2
        graduationDate.layer.borderColor = UIColor.black.cgColor
        graduationDate.setRightPaddingPoints(10)
        graduationDate.setLeftPaddingPoints(10)
        
        
        primaryEmail.layer.cornerRadius = 4
        primaryEmail.layer.borderWidth = 1.2
        primaryEmail.layer.borderColor = UIColor.black.cgColor
        primaryEmail.setLeftPaddingPoints(10)
        primaryEmail.setRightPaddingPoints(10)
                                        
        
        secondaryEmail.layer.cornerRadius = 4
        secondaryEmail.layer.borderWidth = 1.2
        secondaryEmail.layer.borderColor = UIColor.black.cgColor
        secondaryEmail.setRightPaddingPoints(10)
        secondaryEmail.setLeftPaddingPoints(10)
        
        currentPassword.layer.cornerRadius = 4
        currentPassword.layer.borderWidth = 1.2
        currentPassword.layer.borderColor = UIColor.black.cgColor
        currentPassword.setRightPaddingPoints(10)
        currentPassword.setLeftPaddingPoints(10)
        
        newPassword.layer.cornerRadius = 4
        newPassword.layer.borderWidth = 1.2
        newPassword.layer.borderColor = UIColor.black.cgColor
        newPassword.setRightPaddingPoints(10)
        newPassword.setLeftPaddingPoints(10)
        
        repeatPassword.layer.cornerRadius = 4
        repeatPassword.layer.borderWidth = 1.2
        repeatPassword.layer.borderColor = UIColor.black.cgColor
        repeatPassword.setRightPaddingPoints(10)
        repeatPassword.setLeftPaddingPoints(10)
        
        personalInfoSave.layer.cornerRadius = 6
        
        schoolInfoSave.layer.cornerRadius = 6
        
        emailAddressSave.layer.cornerRadius = 6
        
        passwordSave.layer.cornerRadius = 6
        
        
        guard let userData = UserData.data else {
            self.logout()
            return
        }
        
        personalInfoTextView.text = userData.aboutSelf
        let fullName = userData.name ?? "HBCU MADE"
        var components = fullName.components(separatedBy: " ")
        if components.count > 0 {
        let firstName = components.removeFirst()
        let lastName = components.joined(separator: " ")
        self.firstNameTextField.text = firstName
        self.lastNameEditField.text = lastName
        }
        
        if let dob = userData.dob {
            self.birthDayEditField.text = self.convertDateFormater(dob)
        }
        self.phoneNumberEditField.text = userData.phone
        
        self.twitterUsername.text = userData.twitterUsername
        
        self.instagramUsername.text = userData.instagramUsername
        
        
      
        self.schoolName.text = userData.school
        self.designation.text = userData.designation
        self.major.text = userData.major
        self.classification.text = userData.classification
        if let graduationDate = userData.graduationDate {
            self.graduationDate.text = self.convertDateFormater(graduationDate)
        }
        self.primaryEmail.text = userData.email
        self.secondaryEmail.text = userData.secondaryEmail
        
        createDobPicker()
        createGraduationPicker()
        
        if userData.regiType == "custom" {
            passwordView.isHidden = false
        }
        
        
        
    }
    
    func createDobPicker() {
        if #available(iOS 13.4, *) {
            dobPicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
      
        
      
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dobDoneBtnTapped))
        toolbar.setItems([done], animated: true)
      
        birthDayEditField.inputAccessoryView = toolbar
        

        dobPicker.datePickerMode = .date
        birthDayEditField.inputView = dobPicker
    }
    
    @objc func dobDoneBtnTapped() {
        view.endEditing(true)
        let date = dobPicker.date
        birthDayEditField.text = convertDateFormater(date)
    }
    
    func createGraduationPicker(){
        if #available(iOS 13.4, *) {
            graduationPicker.preferredDatePickerStyle = .wheels
        }
        else {
            // Fallback on earlier versions
        }
      
        
      
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(graduationDoneTapped))
        toolbar.setItems([done], animated: true)
      
        graduationDate.inputAccessoryView = toolbar
        

        graduationPicker.datePickerMode = .date
        graduationDate.inputView = graduationPicker
    }
    
    @objc func graduationDoneTapped() {
        view.endEditing(true)
        let date = graduationPicker.date
        graduationDate.text = convertDateFormater(date)
    }
    
    @IBAction func savePersonalInfo(_ sender: Any) {
        
        let saboutSelf = personalInfoTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let sfirstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let slastName = lastNameEditField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sdob = birthDayEditField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sphone = phoneNumberEditField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let stwitter = twitterUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sinstagram = instagramUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if saboutSelf == "" {
            showToast(message: "Enter About Yourself")
        }
        else if sfirstName == "" {
            showToast(message: "Enter First Name")
        }
        else if slastName == "" {
            showToast(message: "Enter Last Name")
        }
        else if sdob == "" {
            showToast(message: "Select Date Of Birth")
            
        }
        else if sphone == "" {
            showToast(message: "Enter Phone Number")
        }
       
        else {
            ProgressHUDShow(text: "Saving...")
            Firestore.firestore().collection("Users").document(UserData.data?.uid ?? "Guest").setData(["aboutSelf" : saboutSelf,"name" : "\(String(describing: sfirstName!)) \(String(describing: slastName!))","dob" : dobPicker.date, "phone" : sphone!,"twitterUsername" : stwitter!, "instagramUsername" : sinstagram!], merge: true) { error in
                self.ProgressHUDHide()
                if error == nil {
                    self.showToast(message: "Saved")
                    UserData.data?.aboutSelf = saboutSelf
                    UserData.data?.name = "\(String(describing: sfirstName!)) \(String(describing: slastName!))"
                    UserData.data?.dob = self.dobPicker.date
                    UserData.data?.phone = sphone
                    UserData.data?.instagramUsername = sinstagram
                    UserData.data?.twitterUsername = stwitter
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func saveSchoolInfo(_ sender: Any) {
        
        
        let sschoolname = schoolName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sDesignation = designation.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sMajor = major.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sClassification = classification.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sGraduationDate = graduationDate.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sschoolname == "" {
            showToast(message: "Enter School Name")
        }
        else if sDesignation == "" {
            showToast(message: "Enter Designation")
        }
        else if sMajor == "" {
            showToast(message: "Enter Major")
            
        }
        else if sClassification == "" {
          
            showToast(message: "Select Classification")
        }
        else if sGraduationDate == "" {
            showToast(message: "Select Graduation Date")
        }
        else {
            ProgressHUDShow(text: "Saving...")
            Firestore.firestore().collection("Users").document(UserData.data?.uid ?? "Guest").setData(["schoolName" : sschoolname!,"designation" : sDesignation!,"major" : sMajor!, "classification" : sClassification!,"graduationDate" : graduationPicker.date], merge: true) { error in
                self.ProgressHUDHide()
                if error == nil {
                    self.showToast(message: "Saved")
                    UserData.data?.school = sschoolname
            
                    UserData.data?.designation = sDesignation
                    UserData.data?.major = sMajor
                    UserData.data?.classification = sClassification
                    UserData.data?.graduationDate = self.graduationPicker.date
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
    }
    
    
    
    @IBAction func saveEmailAddress(_ sender: Any) {
        let sPEmail = primaryEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sSEmail = secondaryEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sPEmail == "" {
            showToast(message: "Enter Primary Email")
        }
        else if sSEmail == "" {
            showToast(message: "Enter Secondary Email")
        }
        else {
            ProgressHUDShow(text: "Saving...")
            Firestore.firestore().collection("Users").document(UserData.data?.uid ?? "Guest").setData(["email" : sPEmail!,"secondaryEmail" : sSEmail!], merge: true) { error in
                self.ProgressHUDHide()
                if error == nil {
                    self.showToast(message: "Saved")
                    UserData.data?.email = sPEmail
                    UserData.data?.secondaryEmail = sSEmail
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func savePassword(_ sender: Any) {
        let sCurrentPassword = currentPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sNewPassword  = newPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sConfirmPassword = repeatPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sCurrentPassword == "" {
            self.showToast(message: "Enter Current Password")
        }
        else if sNewPassword == "" {
            self.showToast(message: "Enter New Password")
        }
        else if sConfirmPassword == "" {
            self.showToast(message: "Enter Confirm Password")
        }
        else if sConfirmPassword != sNewPassword {
            self.showToast(message: "Password Mismatch")
        }
        else {
            let authCredential = EmailAuthProvider.credential(withEmail: UserData.data!.email!, password: sConfirmPassword!)
            ProgressHUDShow(text: "Saving...")
            Auth.auth().currentUser?.reauthenticate(with: authCredential, completion: { authresult, error in
               
               
                if error == nil {
                    Auth.auth().currentUser?.updatePassword(to: sNewPassword!, completion: { error in
                        if error == nil {
                            self.currentPassword.text = ""
                            self.newPassword.text = ""
                            self.repeatPassword.text = ""
                            self.showToast(message: "Password Changed")
                        }
                        else {
                            self.ProgressHUDHide()
                            self.showError(error!.localizedDescription)
                        }
                    })
                }
                else {
                    self.ProgressHUDHide()
                    self.showError(error!.localizedDescription)
                }
            })
        }
    }
    
}

