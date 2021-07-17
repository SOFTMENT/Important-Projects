//
//  SignInController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 11/01/21.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import MBProgressHUD
import AuthenticationServices
import CryptoKit

class SignInController : UIViewController, UITextFieldDelegate{

    var activeField: UITextField?
    @IBOutlet weak var headImage: UIImageView!
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInTextField: UITextField!
    @IBOutlet weak var signInPasswordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    fileprivate var currentNonce: String?
    
    @IBOutlet weak var loginWithApple: UIView!
    
    override func viewDidLoad() {

        

 
        
//        Firestore.firestore().collection("Users").getDocuments { snapshot, err in
//            if err == nil {
//
//
//                if let snapshot = snapshot {
//                    for qds in snapshot.documents {
//                        if let network = try? qds.data(as: UserData.self){
//
//
//                            if let school = network.school {
//                                if school != "" {
//                                    Firestore.firestore().collection("Users").document(network.uid!).setData(["hasApproved": true], merge: true)
//                                }
//                                else {
//                                    Firestore.firestore().collection("Users").document(network.uid!).setData(["hasApproved": false], merge: true)
//                                }
//                            }
//                            else {
//                                Firestore.firestore().collection("Users").document(network.uid!).setData(["hasApproved": false], merge: true)
//                            }
//
//                        }
//
//                    }
//
//                }
//
//
//
//            }
//            else {
//                self.showError(err!.localizedDescription)
//            }
//        }
        

      
        
       

        
        let screensize: CGRect = UIScreen.main.bounds
            let screenWidth = screensize.width
            let screenHeight = screensize.height
            var scrollView: UIScrollView!
            scrollView = UIScrollView(frame: CGRect(x: 0, y: 120, width: screenWidth, height: screenHeight))
            scrollView.contentSize = CGSize(width: screenWidth, height: 2000)
        
    
      

        self.loginWithApple.layer.cornerRadius = 8
        self.signInTextField.layer.cornerRadius = 8
        
     
        self.signInPasswordField.layer.cornerRadius = 8
        
        self.signInButton.layer.cornerRadius = 6
        
        self.signUpButton.layer.cornerRadius = 6
        
        self.signInTextField.delegate = self
        self.signInPasswordField.delegate = self
        
        self.signInTextField.setLeftPaddingPoints(10)
        self.signInTextField.setRightPaddingPoints(10)
        
        self.signInPasswordField.setLeftPaddingPoints(10)
        self.signInPasswordField.setRightPaddingPoints(10)
        
        
        self.loginWithApple.isUserInteractionEnabled = true
        self.loginWithApple.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signInWithAppleBtnTapped)))
        
        let forgotPasswordTap = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        forgotPasswordLabel.addGestureRecognizer(forgotPasswordTap)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(tapRecognizer)
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(fromAppDelegateForAuth(_:)), name: Constants.kNotification, object: nil)
        
      
    }
    
    
    @objc func signInWithAppleBtnTapped(){
        self.startSignInWithAppleFlow()
    }
    
    @objc func forgotPasswordTapped() {
        self.navigateToAnotherScreen(mIdentifier: Constants.StroyBoard.recoverMailViewController)
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        self.loginWithFacebook()
    }
    
    
    @IBAction func googleLogin(_ sender: Any) {

        self.loginWithGoogle()
    }
    
    
    @IBAction func twitterLogin(_ sender: Any) {
       // self.startSignInWithAppleFlow()
        self.loginWithTwitter()
      
    }
    

    @objc func fromAppDelegateForAuth(_ sender: Notification) {
       
        if let credential = sender.userInfo?["credential"] as? AuthCredential {
            authWithFirebase(credential: credential,type: "google", displayName: "")
        }
      
    }
    
  
    
    @IBAction func signUp(_ sender: Any) {
        
        self.navigateToAnotherScreen(mIdentifier: Constants.StroyBoard.signUpViewController)
        
    }
    
    @IBAction func signIn(_ sender: Any) {
        let validDateMessage = validatedFields()
        
        if validDateMessage != nil {
            showError(validDateMessage!)
        }
        else {
     
            let email = signInTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = signInPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            ProgressHUDShow(text: "Loading...")
            Auth.auth().signIn(withEmail: email!, password: password!) { (result, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error != nil {
                    self.handleError(error: error!)
                }
                else {
                    self.getUserData(uid: Auth.auth().currentUser!.uid, showProgress: true)
                }
            }
            
        }
        
    }
    // get current number of times app has been launched
   
    func validatedFields() -> String? {
        if  (signInTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            signInPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
            {
                return "Please fill in all fields."
            }
        
        return nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    
    @objc func hideKeyBoard() {
        self.view.endEditing(true)
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
 
 
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
extension SignInController: ASAuthorizationControllerDelegate {

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
      
        var displayName = "Apple_hbcu"
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
