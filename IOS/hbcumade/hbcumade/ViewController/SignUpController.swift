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
import AuthenticationServices
import CryptoKit



class SignUpController : UIViewController, UITextFieldDelegate {
    let preferences = UserDefaults.standard
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpNameTextField: UITextField!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpRepeatPasswordTextField: UITextField!
    var activeField: UITextField?
 
    fileprivate var currentNonce: String?
    
  
    

    
    
    
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
       
                            self.ProgressHUDShow(text: "Creating An Account...")
                                
                                
                            Auth.auth().createUser(withEmail: cleanedEmail, password: cleanedPassword) { (result, error) in
                                MBProgressHUD.hide(for: self.view, animated: true)
                                if error != nil {
                                    self.handleError(error: error!)      // use the handleError method
                                    return
                                }
                                else {
                                 
                                    let data = ["name" : cleanedName, "email" : cleanedEmail, "uid" :  result!.user.uid, "registredAt" :  result!.user.metadata.creationDate!,"profile" : "","isMobVerified" : true,"regiType" : "custom"] as [String : Any]
                                    
                                
                                    self.addUserData(data: data, uid: result!.user.uid, type: "custom")
                                }
                            }
                        }
                        
            

    
        
    }
    
   
    
   


    
    func validatedFields() -> String? {
        if  (signUpNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            signUpEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            signUpPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            signUpRepeatPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
            {
                return "Please fill in all fields."
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
      //  self.startSignInWithAppleFlow()
        self.loginWithTwitter()
    }
  
   
 
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
 

    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
     // authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}


@available(iOS 13.0, *)
extension SignUpController: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
   
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      
        var displayName = "ACN"
        if let fullName = appleIDCredential.fullName {
            if let firstName = fullName.givenName {
                displayName = firstName
            }
            if let lastName = fullName.familyName {
                displayName = "\(displayName) \(lastName)"
            }
        }
      
        authWithFirebase(credential: credential, type: "apple",displayName: displayName)
        // User is signed in to Firebase with Apple.
        // ...
      
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    
    print("Sign in with Apple errored: \(error)")
  }

}

