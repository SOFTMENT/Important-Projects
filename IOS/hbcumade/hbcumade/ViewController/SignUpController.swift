//
//  SignUpController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 12/01/21.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import MBProgressHUD


class SignUpController : UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let preferences = UserDefaults.standard
    @IBOutlet weak var chooseClassification: UITextField!
    @IBOutlet weak var chooseSchool: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpNameTextField: UITextField!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpRepeatPasswordTextField: UITextField!
    var activeField: UITextField?
    var pickerView = UIPickerView()
    var pickerView2 = UIPickerView()
    
    let schools = ["Clark Atlanta University",
                   "Florida A&M University",
                   "Hampton University",
                   "Howard University",
                   "Morehouse College",
                   "Morgan State University",
                   "Norfolk State University",
                   "Spelman College",
                   "Virginia State University"]
    
    let classification = ["Student","Alumni"]
    

    
    
    
    override func viewDidLoad() {
        
    
        

        self.signUpNameTextField.layer.cornerRadius = 8
        

        self.signUpEmailTextField.layer.cornerRadius = 8
        

        self.signUpPasswordTextField.layer.cornerRadius = 8
        
      
        self.signUpRepeatPasswordTextField.layer.cornerRadius = 8
        
      
        self.signInButton.layer.cornerRadius = 6
        self.signUpButton.layer.cornerRadius = 6
        
        self.signUpNameTextField.delegate = self
        self.signUpEmailTextField.delegate = self
        self.signUpPasswordTextField.delegate = self
        self.signUpRepeatPasswordTextField.delegate = self
        
        self.signUpNameTextField.setRightPaddingPoints(10)
        self.signUpNameTextField.setLeftPaddingPoints(10)
        
        self.signUpEmailTextField.setRightPaddingPoints(10)
        self.signUpEmailTextField.setLeftPaddingPoints(10)
        
        //SCHOOL
        chooseSchool.delegate = self
   
        chooseSchool.layer.cornerRadius = 8
        
        chooseSchool.setLeftPaddingPoints(10)
        chooseSchool.setRightPaddingPoints(10)
        
       
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
      
        chooseSchool.inputView = pickerView
        chooseSchool.attributedPlaceholder = NSAttributedString(string: "Choose Your University",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
       
        
        //CLASSFICATION
        chooseClassification.delegate = self

        chooseClassification.layer.cornerRadius = 8
        
        chooseClassification.setLeftPaddingPoints(10)
        chooseClassification.setRightPaddingPoints(10)
        
       
        
        pickerView2.dataSource = self
        pickerView2.delegate = self
        
      
        chooseClassification.inputView = pickerView2
        chooseClassification.attributedPlaceholder = NSAttributedString(string: "Choose Classification",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
       
        
        
        self.signUpPasswordTextField.setRightPaddingPoints(10)
        self.signUpPasswordTextField.setLeftPaddingPoints(10)
        
        self.signUpRepeatPasswordTextField.setRightPaddingPoints(10)
        self.signUpRepeatPasswordTextField.setLeftPaddingPoints(10)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(tapRecognizer)
      
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }

    

   
    @IBAction func signIn(_ sender: Any) {
        
        beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
    }
    
    @IBAction func createAnAccount(_ sender: Any) {

        
        let validateResult = validatedFields()
        if validateResult != nil {
            self.showError(validateResult!)
        }
        else {
        let cleanedEmail = signUpEmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedName = signUpNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedPassword = signUpPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let schoolText = chooseSchool.text
        
        let classificationText = chooseClassification.text
            
           

        ProgressHUDShow(text: "Creating An Account...")
            
            
        Auth.auth().createUser(withEmail: cleanedEmail, password: cleanedPassword) { (result, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error != nil {
                self.handleError(error: error!)      // use the handleError method
                return
            }
            else {
             
                let data = ["name" : cleanedName, "email" : cleanedEmail, "uid" :  result!.user.uid,"school":schoolText!, "registredAt" :  result!.user.metadata.creationDate!,"profile" : "","classification" : classificationText! ,"isMobVerified" : true,"regiType" : "custom"] as [String : Any]
                
                self.preferences.setValue(schoolText, forKey: "school")
                self.preferences.synchronize()
                self.addUserData(data: data, uid: result!.user.uid, type: "custom")
            }
        }
    }
        
    }
    
    
   

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == chooseSchool || textField == chooseClassification) {
            return false
        }
        return true
     
    }
    
    func validatedFields() -> String? {
        if  (signUpNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            signUpEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            signUpPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            signUpRepeatPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
            {
                return "Please fill in all fields."
            }
        
        if chooseSchool.text == "" {
            return "Please choose school"
        }
        
        if chooseClassification.text == "" {
            return "Please choose classification"
        }
        
    
        
        let cleanedPassword = signUpPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print(cleanedPassword)
        
        if Constants.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 Characters, Contains a special character and a number."
        }
        let cleanedRepeatPassword = signUpRepeatPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Constants.isPasswordValid(cleanedRepeatPassword) == false {
            return "Please make sure your password is at least 8 Characters, Contains a special character and a number."
        }
        
        if cleanedPassword != cleanedRepeatPassword {
            return "Passowrd and Repeat password must be same."
        }
        
        return nil
    }
    
 
   
    
    
    @objc func hideKeyBoard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
  

    
    
    @IBAction func googleSignIn(_ sender: Any) {
        self.loginWithGoogle()
    }
    @IBAction func faceBookSignIn(_ sender: Any) {
        self.loginWithFacebook()
    }
    
    @IBAction func twitterSignIn(_ sender: Any) {
        self.loginWithTwitter()
    }
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerView {
            return schools.count
        }
        else {
            return classification.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerView {
            return schools[row]
        }
        else {
            return classification[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.pickerView {
            chooseSchool.text = schools[row]
            chooseSchool.resignFirstResponder()
        }
        else {
            chooseClassification.text = classification[row]
            chooseClassification.resignFirstResponder()
        }
    }
}

