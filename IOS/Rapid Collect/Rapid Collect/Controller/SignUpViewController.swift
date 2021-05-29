//
//  SignUpViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 29/03/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import Firebase
import TTGSnackbar



class SignUpViewController: UIViewController , UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tapToChnage: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var emailID: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var termsAndConditions: UILabel!
    var isImageChanged = false
    var isCheckBoxSelected = false
    
    var progress = ProgressHUD(text: "Creating Account...")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        view.addSubview(progress)
        
        
        let nameImage = UIImage(named: "icons8-name-100")!
        let mobileImage = UIImage(named: "icons8-phone-100")!
        let mailImage = UIImage(named: "icons8-important-mail-100")!
        let passwordImage = UIImage(named: "icons8-lock-100")!
        
        termsAndConditions.isUserInteractionEnabled = true
        self.termsAndConditions.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsTapped)))
        
        firstName.setLeftIcons(icon: nameImage)
        lastName.setLeftIcons(icon: nameImage)
        mobileNumber.setLeftIcons(icon: mobileImage)
        emailID.setLeftIcons(icon: mailImage)
        password.setLeftIcons(icon: passwordImage)
        confirmPassword.setLeftIcons(icon: passwordImage)
        
        firstName.delegate = self
        lastName.delegate = self
        mobileNumber.delegate = self
        emailID.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        
        
        
        
        firstName.attributedPlaceholder = NSAttributedString(string: "Enter First Name",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        lastName.attributedPlaceholder = NSAttributedString(string: "Enter Last Name",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        
        mobileNumber.attributedPlaceholder = NSAttributedString(string: "Enter Mobile Number",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        emailID.attributedPlaceholder = NSAttributedString(string: "Enter Email Address",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        password.attributedPlaceholder = NSAttributedString(string: "Enter Password",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        confirmPassword.attributedPlaceholder = NSAttributedString(string: "Enter Confirm Password",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        
        
        //CircleImageView
        image.makeRounded()
        
        //TapToChangeImage
        tapToChnage.isUserInteractionEnabled = true
        tapToChnage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImages)))
        
       
        
        
        
    }
    
    @objc func changeImages() {
        
        let alert = UIAlertController(title: "Upload Profile Picture", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Using Camera", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = .camera
            image.allowsEditing = true
              
            self.present(image,animated: true)
            
            
        }
        
        let action2 = UIAlertAction(title: "From Photo Library", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = .photoLibrary
            image.allowsEditing = true
            self.present(image,animated: true)
            
            
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        self.present(alert,animated: true,completion: nil)
        
        
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            isImageChanged = true
            image.image = editedImage
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func backPressed(_ sender: Any) {
        
        dismiss(animated: true) {
            
        }
        
    }
    
    @objc func termsTapped() {
       if let link = URL(string: "https://rapidcollect.co.za/terms-and-conditions/") {
         UIApplication.shared.open(link)
       }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        view.endEditing(true)
        let sFirstName = firstName.text!
        let sLastName = lastName.text!
        let sMobile = mobileNumber.text!
        let sEmail = emailID.text!
        let sPassword = password.text!
        let sConfirmPassword = confirmPassword.text!
        
        if !isImageChanged {
            showToast(messages: "Upload Profile Picture")
            return
        }
        else {
            if sFirstName.isEmpty {
                showToast(messages: "First Name is Required")
                
                return
            }
            else {
                if sLastName.isEmpty {
                    showToast(messages: "Last Name is Required")
                    
                    return
                }
                else {
                    if sMobile.isEmpty {
                        showToast(messages: "Mobile Number is Required")
                        
                        return
                    }
                    else {
                        if sEmail.isEmpty {
                            showToast(messages: "Email ID is Required")
                            
                            return
                        }
                        else {
                            if sPassword.isEmpty {
                                showToast(messages: "Password is Required")
                                
                                return
                            }
                            else {
                                if sConfirmPassword.isEmpty {
                                    showToast(messages: "Confirm Password is Required")
                                    
                                    return
                                    
                                }
                                else {
                                    if sPassword != sConfirmPassword {
                                        showToast(messages: "Password Mismatch")
                                        
                                        return
                                    }
                                    else {
                                        
                                    
                                        if !isCheckBoxSelected {
                                            showToast(messages: "Please accept our terms and conditions")
                                            return
                                        }
                                        else {
                                            self.progress.show()
                                        
                                        Auth.auth().createUser(withEmail: sEmail, password: sPassword) { (result, error) in
                                            
                                          
                                            if error != nil {
                                                self.progress.hide()
                                                
                                                if let error_code =  AuthErrorCode(rawValue: error!._code) {
                                                    self.showToast(messages: error_code.errorMessage)
                                                }
                                            }
                                            else {
                                                
                                                self.uploadImageOnFirebase { (downloadUrl) in
                                                    
                                                    self.uploadDetailsOnDatabase(downloadUrl: downloadUrl, mail: sEmail, mobile: sMobile, name: sFirstName + " " + sLastName)
                                                    
                                                    
                                                }
                                                
                                                
                                            }
                                            
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        
        
        
        
    }
    
    
    
    @IBAction func checkBoxSelected(_ sender: Any) {
        
        let uibutton = sender as! UIButton
        uibutton.isSelected = !uibutton.isSelected
        isCheckBoxSelected = uibutton.isSelected
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        let distanceToBottom = self.scrollView.frame.size.height - (textField.frame.origin.y) - (textField.frame.size.height)
        let collapseSpace = 250 - distanceToBottom
        if collapseSpace < 0 {
            // no collapse
            return
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func showToast(messages : String) {
        
        
        let snackbar = TTGSnackbar(message: messages, duration: .long)
        snackbar.messageLabel.textAlignment = .center
        snackbar.show()
    }

    
    func uploadDetailsOnDatabase(downloadUrl : String , mail : String , mobile : String , name : String) {
        
        let database = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid)
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        let value = ["name" : name, "mail" : mail, "mobile" : mobile, "profileimage" : downloadUrl, "uid" : Auth.auth().currentUser!.uid, "time" : myStringafd] as [String : Any]
        
        database.updateChildValues(value) { (error, databaseref) in
            if error == nil {
                self.progress.hide()
                
                self.sendConfirmationLink()
            }
            else {
                self.progress.hide()
                self.showToast(messages: error.debugDescription)
            }
            
        }
    
        
    }
    
    func sendConfirmationLink() {
        
        let currentUser = Auth.auth().currentUser
        if  currentUser != nil && !currentUser!.isEmailVerified {
            currentUser?.sendEmailVerification(completion: { (error) in
                if error == nil {
                    let confirmEmailAlert = UIAlertController(title: "Thank You!", message: "Your Rapid Collect account has been created successfully.\n\nKindly click the link sent to your provided email address in order to validate your account.", preferredStyle: .actionSheet)
                    let action = UIAlertAction(title: "Ok", style: .default) { (actions) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    confirmEmailAlert.addAction(action)
                    self.present(confirmEmailAlert,animated: true,completion: nil)
                    
                    
                    
                }
                else {
                    self.showToast(messages: error.debugDescription)
                }
            })
        }
        
        
    }
    
    func uploadImageOnFirebase( completion : @escaping (String) -> Void ) {
        
        let storage = Storage.storage().reference().child("ProfilePicture").child("\(Auth.auth().currentUser?.uid ?? "").png")
        var downloadUrl = ""
        let uploadData = (self.image.image?.jpegData(compressionQuality: 0.4))!
        
        storage.putData(uploadData, metadata: nil) { (metadata, error) in
            
            if error == nil {
                storage.downloadURL { (url, error) in
                    if error == nil {
                        downloadUrl = url!.absoluteString
                    }
                    completion(downloadUrl)
                    
                    
                    
                    
                }
            }
            else {
                completion(downloadUrl)
            }
            
        }
    }
    
    
}




extension UIImageView {
    func makeRounded() {
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        
    }
    
    
}

