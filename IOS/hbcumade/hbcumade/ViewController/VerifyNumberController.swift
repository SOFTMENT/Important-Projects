//
//  VerifyNumberController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 12/01/21.
//

import UIKit
import Firebase
import MBProgressHUD

class VerifyNumberController: UIViewController, UITextFieldDelegate{
    let preferences = UserDefaults.standard
   
    @IBOutlet weak var sImage: UIImageView!
    @IBOutlet weak var verifyPhoneNumberTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var sendVerificationCodeButton: UIButton!
    
    override func viewDidLoad() {
//        let schoolData = ["Clark Atlanta University",
//                          "Florida A&M University",
//                          "Hampton University",
//                          "Howard University",
//                          "Morehouse College",
//                          "Morgan State University",
//                          "Norfolk State University",
//                          "Spelman College",
//                          "Virginia State University"]
//
//        if preferences.object(forKey: "school") != nil {
//            if let school = preferences.string(forKey: "school") {
//                switch school {
//                case schoolData[0]:
//                    sImage.image = UIImage(named: "cau")
//                    break
//                case schoolData[1]:
//                    sImage.image = UIImage(named: "famu")
//                    break
//                case schoolData[2]:
//                    sImage.image = UIImage(named: "hampton")
//                    break
//                case schoolData[3]:
//                    sImage.image = UIImage(named: "howard")
//                    break
//                case schoolData[4]:
//                    sImage.image = UIImage(named: "morehouse")
//                    break
//                case schoolData[5]:
//                    sImage.image = UIImage(named: "morgan")
//                    break
//                case schoolData[6]:
//                    sImage.image = UIImage(named: "norfolk")
//                    break
//                case schoolData[7]:
//                    sImage.image = UIImage(named: "spelman")
//                    break
//                case schoolData[8]:
//                    sImage.image = UIImage(named: "vsu")
//                    break
//
//
//                default:
//                    print("DON'T CHANGE IMAHGE")
//                }
//            }
//
//        }
//
//        preferences.synchronize()
//       
        
        self.verifyPhoneNumberTextField.layer.cornerRadius = 8
        
        self.verifyPhoneNumberTextField.setLeftPaddingPoints(10)
        self.verifyPhoneNumberTextField.setRightPaddingPoints(10)
        self.verifyPhoneNumberTextField.attributedPlaceholder =
            NSAttributedString(string: "+1987654321",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        self.signInButton.layer.cornerRadius = 6
        self.sendVerificationCodeButton.layer.cornerRadius = 6
        
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(tapRecognizer)
        verifyPhoneNumberTextField.smartInsertDeleteType = .no
        verifyPhoneNumberTextField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard let textFieldText = textField.text,
               let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                   return false
           }
           let substringToReplace = textFieldText[rangeOfTextToReplace]
           let count = textFieldText.count - substringToReplace.count + string.count
           return count <= 13
       }
    
    @IBAction func sendVerificationCode(_ sender: Any) {
        
        
        
        let mobNumber = verifyPhoneNumberTextField.text
        if mobNumber!.isEmpty {
            showError("Enter Phone Number")
        }
        else{
            
            ProgressHUDShow(text: "Sending Verification Code...")
            
            PhoneAuthProvider.provider().verifyPhoneNumber(mobNumber!, uiDelegate: nil) { (verificationID, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let err = error {
                self.showError(err.localizedDescription)
               
              }
              else {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.navigateToAnotherScreen(mIdentifier: Constants.StroyBoard.enterverificationcodeviewcontroller)
              }
                
              
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    
    @objc func hideKeyBoard() {
        self.view.endEditing(true)
    }
    

  
    
   
}
