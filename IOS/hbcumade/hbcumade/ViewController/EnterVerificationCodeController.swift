//
//  EnterVerificationCodeController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 12/01/21.
//
import UIKit
import Firebase
import MBProgressHUD

class EnterVerificationCodeController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var stackViewOTP: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var resendCode: UIButton!
    @IBOutlet weak var verifyAccount: UIButton!
    
    @IBOutlet weak var tf1: UITextField!
    
    @IBOutlet weak var tf2: UITextField!
    
    @IBOutlet weak var tf3: UITextField!
    
    @IBOutlet weak var tf4: UITextField!
    
    @IBOutlet weak var tf5: UITextField!
    
    @IBOutlet weak var tf6: UITextField!
    
    override func viewDidLoad() {

        self.tf1.layer.cornerRadius = 8
        
       
        self.tf2.layer.cornerRadius = 8
        

    
        self.tf3.layer.cornerRadius = 8
        
    
        
        self.tf4.layer.cornerRadius = 8
        
       
        self.tf5.layer.cornerRadius = 8

        self.tf6.layer.cornerRadius = 8
        
        self.tf1.delegate = self
        self.tf2.delegate = self
        self.tf3.delegate = self
        self.tf4.delegate = self
        self.tf5.delegate = self
        self.tf6.delegate = self
        
        self.signIn.layer.cornerRadius = 6
        self.resendCode.layer.cornerRadius = 6
        self.verifyAccount.layer.cornerRadius = 6
        
        
        self.tf1.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        self.tf2.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        self.tf3.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        self.tf4.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        self.tf5.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        self.tf6.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        
       
        
    
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(tapRecognizer)
    
    }
    
    
    @objc func changeCharacter(textField : UITextField) {
       
        if textField.text!.utf16.count == 1 {
           
            switch textField {
            case tf1:
                tf2.becomeFirstResponder()
                break
            case tf2:
                tf3.becomeFirstResponder()
                break
            case tf3:
                tf4.becomeFirstResponder()
                break
            case tf4:
                tf5.becomeFirstResponder()
                break
            case tf5:
                tf6.becomeFirstResponder()
                break
            case tf6:
                tf6.resignFirstResponder()
                break
            default:
                break
            }
        
        }
        else if (textField.text!.isEmpty) {
          
            switch textField {
            case tf6:
                tf5.becomeFirstResponder()
                break
            case tf5:
                tf4.becomeFirstResponder()
                break
            case tf4:
                tf3.becomeFirstResponder()
                break
            case tf3:
                tf2.becomeFirstResponder()
                break
            case tf2:
                tf1.becomeFirstResponder()
                break
            case tf1:
                tf1.resignFirstResponder()
                break
            default:
                break
            }
        }
        
    }
    
    @IBAction func signIn(_ sender: Any) {
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
       
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let destinationVC = mainStoryboard.instantiateViewController(identifier: Constants.StroyBoard.signInViewController) as? SignInController else {
            print("FAILED TO NAVIGATE ON SIGN UP PAGE")
            return
        }
    
        self.view.window?.rootViewController = destinationVC
        self.view.window?.makeKeyAndVisible()
      
    }
    
    @IBAction func resendCode(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func verifyAccount(_ sender: Any) {
        
        let t1 = tf1.text!
        let t2 = tf2.text!
        let t3 = tf3.text!
        let t4 = tf4.text!
        let t5 = tf5.text!
        let t6 = tf6.text!
        
        if t1.isEmpty || t2.isEmpty || t3.isEmpty || t4.isEmpty || t5.isEmpty || t6.isEmpty {
            showError("Invalid Code")
        }
        else {
        
        let code = t1 + t2 + t3 + t4 + t5 + t6
       
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!, verificationCode: code)
            
            ProgressHUDShow(text: "Verifying...")
        
        Auth.auth().currentUser?.link(with: credential, completion: { (result, error) in
           
            if let error = error {
              MBProgressHUD.hide(for: self.view, animated: true)
              self.showError(error.localizedDescription)
              return
            }
            FirebaseStoreManager.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData(["isMobVerified" : true]) { (error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error != nil {
                    //WILL ADD LATER
                }
                else {
                    self.getUserData(uid: Auth.auth().currentUser!.uid,showProgress: true)
                }
            }
           
        })
        }
       
    }
    
    
    @objc func hideKeyBoard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
      

      
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.utf16.count == 1 && !string.isEmpty {
            
            return false
        }
        return true
    }
    
    
    
}
