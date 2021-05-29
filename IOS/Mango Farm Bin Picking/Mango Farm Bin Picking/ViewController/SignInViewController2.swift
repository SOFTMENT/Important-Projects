//
//  ViewController.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 14/04/21.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import MBProgressHUD

class SignInViewController2: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var login: UIButton!
    let standard = UserDefaults.standard
    var isMachine = true
    var uid = "0"
    
    override func viewDidLoad() {
   
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
            //if app is first time opened then it will be nil
            userDefaults.setValue(true, forKey: "appFirstTimeOpend")
            // signOut from FIRAuth
            do {
                try Auth.auth().signOut()
            }catch {

            }
            // go to beginning of app
        }
       
        
        
        login.layer.cornerRadius = 4
        email.delegate = self
        password.delegate = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(hideKeyboard)))
      
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        
        
    }
    
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        var sEmail = email.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sPassword = password.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if sEmail != "" && sPassword != "" {
           
          
            ProgressHUDShow(text: "Sign In...")
            
            self.isMachine = true
            switch sEmail {
            case "1":
                uid = "1"
                sEmail = "1@mangobin.com"
                break
            case "2":
                uid = "2"
                sEmail = "2@mangobin.com"
                break
            case "3":
                uid = "3"
                sEmail = "3@mangobin.com"
                break
            case "4":
                uid = "4"
                sEmail = "4@mangobin.com"
                break
            case "5":
                uid = "5"
                sEmail = "5@mangobin.com"
                break
            case "6":
                uid = "6"
                sEmail = "6@mangobin.com"
                break
            case "7":
                uid = "7"
                sEmail = "7@mangobin.com"
                break
            case "8":
                uid = "8"
                sEmail = "8@mangobin.com"
                break
            case "9":
                uid = "9"
                sEmail = "9@mangobin.com"
                break
            case "10":
                uid = "10"
                sEmail = "10@mangobin.com"
                break
            case "11":
                uid = "11"
                sEmail = "11@mangobin.com"
                break
            case "12":
                uid = "12"
                sEmail = "12@mangobin.com"
                break
            case "13":
                uid = "13"
                sEmail = "13@mangobin.com"
                break
            case "14":
                uid = "14"
                sEmail = "14@mangobin.com"
                break
            case "15":
                uid = "15"
                sEmail = "15@mangobin.com"
                break
            case "16":
                uid = "16"
                sEmail = "16@mangobin.com"
                break
            case "17":
                uid = "17"
                sEmail = "17@mangobin.com"
                break
            case "18":
                uid = "18"
                sEmail = "18@mangobin.com"
                break
            case "19":
                uid = "19"
                sEmail = "19@mangobin.com"
                break
            case "20":
                uid = "20"
                sEmail = "20@mangobin.com"
                break
            case "21":
                uid = "21"
                sEmail = "21@mangobin.com"
                break
            case "22":
                uid = "22"
                sEmail = "22@mangobin.com"
                break
                
                
            default:
                isMachine = false
               
                
               
            }
            
            
            print("HELLO VIJAY \(isMachine)")
            
            
            Auth.auth().signIn(withEmail: sEmail!, password: sPassword!) { auth, err in
                MBProgressHUD.hide(for: self.view, animated: true)
                if err == nil {
                    
                    if self.isMachine {
                        
                        self.standard.setValue(self.uid, forKey: "machinenumber")
                        self.standard.setValue("machine", forKey: "designation")
                        self.standard.synchronize()
                        let userData = UserModel(email : sEmail!, machineNumber: self.uid, name: "Machine \(self.uid)", designation: "machine", pid: self.uid)
                    
                         UserModel.data = userData
                        
                        print("HELLO VIJAY")
                         self.beRootScreen(mIdentifier: Constants.StroyBoard.homeViewController)
                    }
                    else {
                        self.standard.setValue(Auth.auth().currentUser!.uid, forKey: "machinenumber")
                        self.standard.setValue("owner", forKey: "designation")
                        self.standard.synchronize()
                        self.getUserDataFromServer(uid: Auth.auth().currentUser!.uid)
                    }
                   
                }
                else {
                    self.showError("Invalid Login Details.")
                }
            }
        
        }
        else {
            self.showToast(message: "Please Enter Email Address and Password")
        }
    }
    
    func getUserDataFromServer(uid : String) {
        
        ProgressHUDShow(text: "Loading...")
        let dbRef = Database.database().reference().child("MangoFarm").child("Users")
        dbRef.keepSynced(true)
        dbRef.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if snapshot.exists() {
               
             
                        if let data =  snapshot.value as? [String : Any] {
                            
                            guard let sEmail = data["email"] as? String else {
                                return
                            }
                            
                            guard let sMachine = data["machineNumber"] as? String else {
                                return
                            }
                            guard let sName = data["name"] as? String else {
                                return
                            }
                            guard let sDesignation = data["designation"] as? String else {
                                return
                            }
                        
                            guard let sPid = data["pId"] as? String else {
                                return
                            }
                            
                          
                            let userData = UserModel(email : sEmail, machineNumber: sMachine, name: sName, designation: sDesignation, pid: sPid)
                            
                            UserModel.data = userData
                            
                            self.beRootScreen(mIdentifier: Constants.StroyBoard.homeViewController)
                            
                        
                    }
                    else {
                        print("BVIJAY")
                    }
                   
                
               
               
            }
         
           
            
          
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser != nil {
            if let designation = standard.string(forKey: "designation") {
            
                
                if designation == "machine" {
                    
                    if let uid = standard.string(forKey: "machinenumber") {
                       
                        let userData = UserModel(email : "\(uid)@mangobin.com", machineNumber: self.uid, name: "Machine \(self.uid)", designation: "machine", pid: self.uid)
                    
                         UserModel.data = userData
                        
                        DispatchQueue.main.async {
                            self.beRootScreen(mIdentifier: Constants.StroyBoard.homeViewController)
                        }
                       
                    }
                    
                   
                }
                else {
                    getUserDataFromServer(uid: Auth.auth().currentUser!.uid)
                }
            }
            else{
                getUserDataFromServer(uid: Auth.auth().currentUser!.uid)
            }
            
           
        }
        
        
    }
   
    
    
    
}
   
    
    
   
    
    
    
    
    
    
    
    
   


