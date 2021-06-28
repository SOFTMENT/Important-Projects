//
//  ViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay on 13/05/21.
//

import UIKit
import FirebaseAuth
import Firebase
import MBProgressHUD
import AuthenticationServices
import CryptoKit


class LoginViewController: UIViewController {
  
    
 
    
   
    
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var signIn: UILabel!
    @IBOutlet weak var createAnAccount: UIButton!
    @IBOutlet weak var apple: UIView!
    @IBOutlet weak var facebook: UIView!
    @IBOutlet weak var google: UIView!
    fileprivate var currentNonce: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        google.layer.cornerRadius = 12
        facebook.layer.cornerRadius = 12
        apple.layer.cornerRadius = 12
        createAnAccount.layer.cornerRadius = 12
        
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
        
        //GoogleSignin
        google.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginWithGoogleBtnTapped)))
        
        //FacebookSignIn
        facebook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginWithFacebookBtnTapped)))
        
        //AppleSignIn
        apple.isUserInteractionEnabled = true
        apple.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginWithApple)))
        
        //SignIn
        signIn.isUserInteractionEnabled = true
        signIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signInBtnTapped)))
        
    
       
        NotificationCenter.default.addObserver(self, selector: #selector(fromAppDelegateForAuth(_:)), name: Constants.kNotification, object: nil)
    }
    
    

    @objc func fromAppDelegateForAuth(_ sender: Notification) {
       
        if let credential = sender.userInfo?["credential"] as? AuthCredential {
           authWithFirebase(credential: credential,type: "google",mName: "")
        }
      
    }
    
    @objc func loginWithApple(){
        self.startSignInWithAppleFlow()
    }
    @objc func loginWithGoogleBtnTapped(){
        self.loginWithGoogle()
    }

    @objc func loginWithFacebookBtnTapped(){
        self.loginWithFacebook()
    }
    
    @objc func signInBtnTapped(){
        performSegue(withIdentifier: "signinseg", sender: nil)
    }
    @IBAction func createAccountBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "signupseg", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser != nil {
            var providerID = ""
            if let providerId = Auth.auth().currentUser!.providerData.first?.providerID {
                providerID = providerId
            }
            if providerID != "password" || Auth.auth().currentUser!.isEmailVerified || Auth.auth().currentUser?.email == "support@acn.com" {
                self.getUserData(uid: Auth.auth().currentUser!.uid)
            }
            else{
                if let provider = Auth.auth().currentUser?.providerData.first?.providerID {
                    if provider == "apple.com" {
                        self.getUserData(uid: Auth.auth().currentUser!.uid)
                    }
                }
            }
            
            
        }
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
extension LoginViewController: ASAuthorizationControllerDelegate {

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
      
        authWithFirebase(credential: credential, type: "apple",mName: displayName)
        // User is signed in to Firebase with Apple.
        // ...
      
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    
    print("Sign in with Apple errored: \(error)")
  }

}
