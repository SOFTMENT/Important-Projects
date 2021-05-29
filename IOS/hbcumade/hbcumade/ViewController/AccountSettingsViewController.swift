//
//  AccountSettingsViewController.swift
//  hbcumade
//
//  Created by Vijay on 08/04/21.
//

import UIKit

class AccountSettingsViewController  : BaseViewController {
    
    @IBOutlet weak var personalInfoTextView: UITextView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameEditField: UITextField!
    
    @IBOutlet weak var birthDayEditField: UITextField!
    
    @IBOutlet weak var phoneNumberEditField: UITextField!
    
    @IBOutlet weak var schoolInfoTextView: UITextView!
    
    @IBOutlet weak var schoolName: UITextField!
    
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
    
    override func viewDidLoad() {
        
        personalInfoTextView.layer.cornerRadius = 8
        personalInfoTextView.layer.borderWidth = 1.5
        personalInfoTextView.layer.borderColor = UIColor.black.cgColor
        personalInfoTextView.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10); 
        
        firstNameTextField.layer.cornerRadius = 8
        firstNameTextField.layer.borderWidth = 1.5
        firstNameTextField.layer.borderColor = UIColor.black.cgColor
        firstNameTextField.setRightPaddingPoints(10)
        firstNameTextField.setLeftPaddingPoints(10)
        
        lastNameEditField.layer.cornerRadius = 8
        lastNameEditField.layer.borderWidth = 1.5
        lastNameEditField.layer.borderColor = UIColor.black.cgColor
        lastNameEditField.setRightPaddingPoints(10)
        lastNameEditField.setLeftPaddingPoints(10)
        
        birthDayEditField.layer.cornerRadius = 8
        birthDayEditField.layer.borderWidth = 1.5
        birthDayEditField.layer.borderColor = UIColor.black.cgColor
        birthDayEditField.setRightPaddingPoints(10)
        birthDayEditField.setLeftPaddingPoints(10)
        
        
        phoneNumberEditField.layer.cornerRadius = 8
        phoneNumberEditField.layer.borderWidth = 1.5
        phoneNumberEditField.layer.borderColor = UIColor.black.cgColor
        phoneNumberEditField.setRightPaddingPoints(10)
        phoneNumberEditField.setLeftPaddingPoints(10)
        
        schoolInfoTextView.layer.cornerRadius = 8
        schoolInfoTextView.layer.borderWidth = 1.5
        schoolInfoTextView.layer.borderColor = UIColor.black.cgColor
        schoolInfoTextView.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10);
        
        schoolName.layer.cornerRadius = 8
        schoolName.layer.borderWidth = 1.5
        schoolName.layer.borderColor = UIColor.black.cgColor
        schoolName.setRightPaddingPoints(10)
        schoolName.setLeftPaddingPoints(10)
        
        major.layer.cornerRadius = 8
        major.layer.borderWidth = 1.5
        major.layer.borderColor = UIColor.black.cgColor
        major.setRightPaddingPoints(10)
        major.setLeftPaddingPoints(10)
        
        classification.layer.cornerRadius = 8
        classification.layer.borderWidth = 1.5
        classification.layer.borderColor = UIColor.black.cgColor
        classification.setRightPaddingPoints(10)
        classification.setLeftPaddingPoints(10)
        
        graduationDate.layer.cornerRadius = 8
        graduationDate.layer.borderWidth = 1.5
        graduationDate.layer.borderColor = UIColor.black.cgColor
        graduationDate.setRightPaddingPoints(10)
        graduationDate.setLeftPaddingPoints(10)
        
        
        primaryEmail.layer.cornerRadius = 8
        primaryEmail.layer.borderWidth = 1.5
        primaryEmail.layer.borderColor = UIColor.black.cgColor
        primaryEmail.setLeftPaddingPoints(10)
        primaryEmail.setRightPaddingPoints(10)
                                        
        
        secondaryEmail.layer.cornerRadius = 8
        secondaryEmail.layer.borderWidth = 1.5
        secondaryEmail.layer.borderColor = UIColor.black.cgColor
        secondaryEmail.setRightPaddingPoints(10)
        secondaryEmail.setLeftPaddingPoints(10)
        
        currentPassword.layer.cornerRadius = 8
        currentPassword.layer.borderWidth = 1.5
        currentPassword.layer.borderColor = UIColor.black.cgColor
        currentPassword.setRightPaddingPoints(10)
        currentPassword.setLeftPaddingPoints(10)
        
        newPassword.layer.cornerRadius = 8
        newPassword.layer.borderWidth = 1.5
        newPassword.layer.borderColor = UIColor.black.cgColor
        newPassword.setRightPaddingPoints(10)
        newPassword.setLeftPaddingPoints(10)
        
        repeatPassword.layer.cornerRadius = 8
        repeatPassword.layer.borderWidth = 1.5
        repeatPassword.layer.borderColor = UIColor.black.cgColor
        repeatPassword.setRightPaddingPoints(10)
        repeatPassword.setLeftPaddingPoints(10)
        
        personalInfoSave.layer.cornerRadius = 6
        
        schoolInfoSave.layer.cornerRadius = 6
        
        emailAddressSave.layer.cornerRadius = 6
        
        passwordSave.layer.cornerRadius = 6
        
        
        
    }
    
    @IBAction func savePersonalInfo(_ sender: Any) {
    }
    
    @IBAction func saveSchoolInfo(_ sender: Any) {
    }
    
    @IBAction func saveEmailAddress(_ sender: Any) {
    }
    
    @IBAction func savePassword(_ sender: Any) {
    }
    
}

