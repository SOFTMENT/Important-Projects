//
//  Extensions.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 14/04/21.
//


import UIKit
import GoogleSignIn
import MBProgressHUD
import FirebaseAuth
import Firebase
import SystemConfiguration

extension Data {

    /// Data into file
    ///
    /// - Parameters:
    ///   - fileName: the Name of the file you want to write
    /// - Returns: Returns the URL where the new file is located in NSURL
    func dataToFile(fileName: String) -> NSURL? {

        // Make a constant from the data
        let data = self

        // Make the file path (with the filename) where the file will be loacated after it is created
        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent(fileName)
            try data.write(to: fileURL)

            // Returns the URL where the new file is located in NSURL
            return fileURL as NSURL
        }
        catch {
            print(error.localizedDescription)
        }

        // Returns nil if there was an error in the do-catch -block
        return nil

    }

}

extension UIViewController {
    
    
    func extractDataFromSnashot(snapshot : DataSnapshot) {
        if snapshot.exists() {
            
            var mangoBinsModels =  Array<MangoBinModel>()
            for snap in snapshot.children {
                
                if let s = snap as? DataSnapshot {
                    if  let data = s.value as? [String : Any] {
                        
             
                        let id = data["id"] as? String
                        let title = data["title"] as? String
                        let pickedByName = data["pickedByName"] as? String
                        let scannedByName = data["scannedByName"] as? String
                        let date = data["date"] as? Double
                        let binNumber = data["binNumber"] as? Int
                        let machineNumber = data["machineNumber"] as? String
                        
                        let mangoBinModel = MangoBinModel(id: id!, title: title!, pickedByName: pickedByName!, scannedByName: scannedByName!, binNumber: binNumber!, date: date!, machineNumber: machineNumber!)
                        
                        mangoBinsModels.append(mangoBinModel)
                        
                    }
                }
            }
            self.createCSV(from: mangoBinsModels)
        }
        else {
            self.showError("No Report Available")
        }
    }
    
    func createCSV(from recArray:Array<MangoBinModel>) {
        
           var csvString = "\("SN"),\("Bin Number"),\("Title"),\("Picker Name"),\("Scanner Name"),\("Machine Number"),\("Time")\n\n"
           var i = 0;
           for dct in recArray {
            i = i + 1
            csvString = csvString.appending("\(String(describing: i)),\(String(describing: dct.binNumber)) ,\(String(describing: dct.title)),\(String(describing: dct.pickedByName)),\(String(describing: dct.scannedByName)),\(String(describing: dct.machineNumber)),\(self.convertTODateAndTime(dateValue: dct.date))\n")
           }

           let fileManager = FileManager.default
           do {
               let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("\(convertTODateAndTime(dateValue: Date().timeIntervalSince1970)).csv")
            print(fileURL)
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            
            // the Data you want to share as a file
           // let data = Data()
            
            // Write the data into a filepath and return the filepath in NSURL
            // Change the file-extension to specify the filetype (.txt, .json, .pdf, .png, .jpg, .tiff...)
           // let fileURL1 = data.dataToFile(fileName: "REPORTVIJAY.csv")

            // Create the Array which includes the files you want to share
            var filesToShare = [Any]()

            // Add the path of the file to the Array
            filesToShare.append(fileURL)

            // Make the activityViewContoller which shows the share-view
            let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)

            // Show the share-view
            self.present(activityViewController, animated: true, completion: nil)
            
            
           } catch {
            print(error.localizedDescription)
           }

       }
    

    
    func convertTODateAndTime(dateValue: Double) -> String {

        let date = Date(timeIntervalSince1970: TimeInterval(dateValue))
        let formatter = DateFormatter()
//formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "dd-MMM-yyyy, hh:mm a"
        return formatter.string(from: date)
    }
    
    func ProgressHUDShow(text : String) {
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.mode = .indeterminate
        loading.label.text =  text
        loading.label.font = UIFont(name: "RobotoCondensed-Regular", size: 14)
    }
    
    func handleError(error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            
            showError(errorCode.errorMessage)
        
        }
    }
    
    func showError(_ message : String) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)

    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2, width: 160, height: 36))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "RobotoCondensed-Regular", size: 12)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseIn, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    func navigateToAnotherScreen(mIdentifier : String)  {
       
        let destinationVC = getViewControllerUsingIdentifier(mIdentifier: mIdentifier)
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true) {
           
        }
        
    }
    
    func getViewControllerUsingIdentifier(mIdentifier : String) -> UIViewController{
    

        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        switch mIdentifier {
       
        case Constants.StroyBoard.signInViewController2:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? SignInViewController2)!
            
        
        case Constants.StroyBoard.homeViewController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? HomeNavigationController)!
          
       
            
        
        default:
            return (mainStoryboard.instantiateViewController(identifier: Constants.StroyBoard.signInViewController2) as? SignInViewController2)!
        }
    }
    
    func beRootScreen(mIdentifier : String) {
      
        
        guard let window = self.view.window else {
           
            self.view.window?.rootViewController = getViewControllerUsingIdentifier(mIdentifier: mIdentifier)
            self.view.window?.makeKeyAndVisible()
                return
            }
    
            window.rootViewController = getViewControllerUsingIdentifier(mIdentifier: mIdentifier)
            window.makeKeyAndVisible()
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
    }
    
    
    
}




extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension AuthErrorCode {
    
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
        case .accountExistsWithDifferentCredential:
            return "An account already exists with the same email address but different sign-in method."
        
        default:
            return "Unknown error occurred"
        }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

