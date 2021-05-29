//
//  BookCateringViewController.swift
//  Oh Crepe & Waffles
//
//  Created by Vijay on 15/05/21.
//

import UIKit
import AMTabView
import Firebase
import FirebaseFirestoreSwift
import MBProgressHUD


class BookCateringViewController: UIViewController, TabItem {

    var tabImage: UIImage? {
        return UIImage(named: "buffet")
    }

    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var enterAddress: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var dateAndTime: UITextField!
    @IBOutlet weak var howManyPeople: UITextField!
    @IBOutlet weak var desc: UITextField!
    
    @IBOutlet weak var book: UIButton!
    
    let datePicker = UIDatePicker()
    
    var sDate = ""
    var sTime = ""
    
    override func viewDidLoad() {
        fullName.layer.cornerRadius = 4
        enterAddress.layer.cornerRadius = 4
        phoneNumber.layer.cornerRadius = 4
        emailId.layer.cornerRadius = 4
        dateAndTime.layer.cornerRadius = 4
        howManyPeople.layer.cornerRadius = 4
        desc.layer.cornerRadius = 4
        book.layer.cornerRadius = 4
        
        fullName.layer.borderWidth = 1
        fullName.layer.borderColor = UIColor.lightGray.cgColor
        
        enterAddress.layer.borderWidth = 1
        enterAddress.layer.borderColor = UIColor.lightGray.cgColor
        
        phoneNumber.layer.borderWidth = 1
        phoneNumber.layer.borderColor = UIColor.lightGray.cgColor
        
        emailId.layer.borderWidth = 1
        emailId.layer.borderColor = UIColor.lightGray.cgColor
        
        dateAndTime.layer.borderWidth = 1
        dateAndTime.layer.borderColor = UIColor.lightGray.cgColor
        
        howManyPeople.layer.borderWidth = 1
        howManyPeople.layer.borderColor = UIColor.lightGray.cgColor
        
        desc.layer.borderWidth = 1
        desc.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        fullName.delegate = self
        enterAddress.delegate = self
        phoneNumber.delegate = self
        emailId.delegate = self
        dateAndTime.delegate = self
        howManyPeople.delegate = self
        desc.delegate = self
        
        fullName.setLeftPaddingPoints(10)
        fullName.setRightPaddingPoints(10)
        
        enterAddress.setLeftPaddingPoints(10)
        enterAddress.setRightPaddingPoints(10)
        
        phoneNumber.setLeftPaddingPoints(10)
        phoneNumber.setRightPaddingPoints(10)
        
        emailId.setLeftPaddingPoints(10)
        emailId.setRightPaddingPoints(10)
        
        dateAndTime.setLeftPaddingPoints(10)
        dateAndTime.setRightPaddingPoints(10)
        
        howManyPeople.setLeftPaddingPoints(10)
        howManyPeople.setRightPaddingPoints(10)
        
        desc.setLeftPaddingPoints(10)
        desc.setRightPaddingPoints(10)
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        createDatePicker()
    
    }
    
    
    
    
    @IBAction func bookBtnTapped(_ sender: Any) {
        let sFullName = fullName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sEnterAddress = enterAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sPhoneNumber = phoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sEmailId = emailId.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sDateAndTime = dateAndTime.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sHowManyPeople = howManyPeople.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sDesc = desc.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        
        if sFullName == ""{
            self.showToast(message: "Enter Full Name")
        }
        else if sEnterAddress == "" {
            self.showToast(message: "Enter Address")
        }
        else if sPhoneNumber == "" {
            self.showToast(message: "Enter Phone Number")
        }
        else if sEmailId == "" {
            self.showToast(message: "Enter Email ID")
        }
        else if sDateAndTime == "" {
            self.showToast(message: "Select Date And Time")
        }
        else if sHowManyPeople == "" {
            self.showToast(message: "Enter How Many Peoples")
        }
        else {
            ProgressHUDShow(text: "Wait...")
            Firestore.firestore().collection("Catering").document().setData(["email": sEmailId!, "address" : sEnterAddress!,"phonenumber":sPhoneNumber!,"fullname" : sFullName!,"dateandtime" : sDateAndTime!,"howmanypeoples":sHowManyPeople!,"description" : sDesc!]) { error in
                if error == nil {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.showMessage(title: "Thank You!", message: "We have received your booking request and we will contact you soon.")
                    
                    self.fullName.text = ""
                    self.enterAddress.text = ""
                    self.phoneNumber.text = ""
                    self.emailId.text = ""
                    self.dateAndTime.text = ""
                    self.howManyPeople.text = ""
                    self.desc.text = ""
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
        
        
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    func createDatePicker() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
      
        
      
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnTapped))
        toolbar.setItems([done], animated: true)
      
        dateAndTime.inputAccessoryView = toolbar
        

        datePicker.datePickerMode = .dateAndTime
        dateAndTime.inputView = datePicker
        
        
    }
    
    @objc func doneBtnTapped() {
        view.endEditing(true)
        let date = datePicker.date
        dateAndTime.text = convertDateFormater(date)
    
        
    }
    
}


extension BookCateringViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}


