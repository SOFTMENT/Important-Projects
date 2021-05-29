//
//  EditProfileViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 30/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import TTGSnackbar
import MobileCoreServices

class EditProfileViewController: UIViewController{
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tapToChange: UILabel!
    @IBOutlet weak var solo: UIButton!
    @IBOutlet weak var closed: UIButton!
    @IBOutlet weak var pty: UIButton!
    
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var checkSupported: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    var trading = ""
    var isUploadClicked = false
    
    var mytitle : String?

  
    @IBOutlet weak var myNavigationItem: UINavigationItem!
    
    var isImageChanged = false
    let progress = ProgressHUD(text: "Updating...")
    var root = Database.database().reference().child("Users")
    var myimage : UIImage?

    let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData), String(kUTTypePDF), String(kUTTypeJPEG), String(kUTTypePNG)], in: .import)

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(progress)
        documentPicker.delegate = self
        myView.layer.cornerRadius = CGFloat(8)
        
        uploadBtn.layer.cornerRadius = CGFloat(8)
        uploadBtn.layer.borderColor = UIColor.white.cgColor
        uploadBtn.layer.borderWidth = CGFloat(1)
        
        pty.layer.cornerRadius = CGFloat(8)
       closed.layer.cornerRadius = CGFloat(8)
        solo.layer.cornerRadius = CGFloat(8)
        
        updateBtn.layer.cornerRadius = CGFloat(8)
        
        
        
        
         view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        
               firstName.attributedPlaceholder = NSAttributedString(string: "Enter First Name",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
               
               lastName.attributedPlaceholder = NSAttributedString(string: "Enter Last Name",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
               
               
               mobileNumber.attributedPlaceholder = NSAttributedString(string: "Enter Mobile Number",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        let nameImage = UIImage(named: "icons8-name-100")!
        let mobileImage = UIImage(named: "icons8-phone-100")!
        firstName.setLeftIcons(icon: nameImage)
        lastName.setLeftIcons(icon: nameImage)
        mobileNumber.setLeftIcons(icon: mobileImage)
        
        firstName.delegate = self
        lastName.delegate = self
        mobileNumber.delegate = self
        
        checkSupported.isEnabled  = true
        checkSupported.isUserInteractionEnabled = true
        
        checkSupported.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkSupportedTapped)))
        
        //TapToChangeImage
        tapToChange.isUserInteractionEnabled = true
        tapToChange.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImages)))
        
       
        myNavigationItem.title = mytitle
        
        //CircleImageView
        imageView.makeRounded()
        
        if let user = Auth.auth().currentUser {
            
            root.child(user.uid).observe(.value) { (snapshot) in
                    if  let profile = snapshot.value as?  [String : String] {
                                if let s = profile["name"] {
                                    let name =  s.split(separator: " ")
                                    self.firstName.text = String.init(describing: name.first!)
                                    self.lastName.text = String.init(describing: name.last!)
                            }
                                
                            if let mobile = profile["mobile"] {
                                self.mobileNumber.text = mobile
                            }
                            
                            if let imageString = profile["profileimage"] {
                        
                                self.imageView.kf.setImage(with: URL(string: imageString))
                            
                            }
                            
                            
                        }
            }
            
    }
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if self.isUploadClicked {
           
            if let editedImage = info[.originalImage] as? UIImage {
                          isImageChanged = true
                self.myimage = editedImage
                self.uploadImageOnFirebase(posi: "doc") { (download) in
                    Database.database().reference().child("Documents").child(Auth.auth().currentUser!.uid).child(self.trading).child(Database.database().reference().child("Documents").childByAutoId().key!).setValue(download)
                }
                          
        }
          
        }
        else {
           if let editedImage = info[.editedImage] as? UIImage {
               isImageChanged = true
               imageView.image = editedImage
               
           }
        }
           
           self.dismiss(animated: true, completion: nil)
    }
       
    func showToast(messages : String) {
           
           
           let snackbar = TTGSnackbar(message: messages, duration: .long)
           snackbar.messageLabel.textAlignment = .center
           snackbar.show()
       }
       
    

     
    
    @objc func changeImages() {
        
        let alert = UIAlertController(title: "Upload Profile Picture", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Using Camera", style: .default) { (action) in
            
            
            self.isUploadClicked = false
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc func checkSupportedTapped() {
        Temp.btnName = "doc"
         let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "web")
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    

    @IBAction func updateBtnTapped(_ sender: Any) {
                    
        let sFirstName = firstName.text!
        let sLastName  = lastName.text!
        let sMobile = mobileNumber.text!
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
                            progress.text = "Updating..."
                            progress.show()
                            
                            if isImageChanged {
                                uploadImageOnFirebase(posi: "profile") { (downloadUrl) in
                                        
                                    
                                    let value = ["name" : sFirstName + " " + sLastName, "mobile" : sMobile, "profileimage" : downloadUrl,"trading" : self.trading] as [String : Any]
                                      self.updateDetails(values: value)
                                }
                            }
                            else {
                                
                                let value = ["name" : sFirstName + " " + sLastName, "mobile" : sMobile,"trading" : self.trading] as [String : Any]
                                self.updateDetails(values: value)
                            }
                            
                            
                        }
                        
                    }
                    
        }
        
    }
    
    
    func updateDetails(values : [String : Any]) {
        root.child(Auth.auth().currentUser!.uid).updateChildValues(values) { (error, database) in
            self.progress.hide()
            if error == nil {
                self.showToast(messages: "Updated!")
            }
            else {
                self.showToast(messages: error!.localizedDescription)
                
            }
        }
            
    }

    
    
    
    @IBAction func tappedTradingButton(_ sender: Any) {
        
        if let button = sender as? UIButton {
            switch button.tag {
            case 1:
                self.trading = "solo"
                solo.backgroundColor = UIColor(red: 237/255, green: 27/255, blue: 37/255, alpha: 1)
                closed.backgroundColor = UIColor(red: 90/255, green: 200/250, blue: 250/255, alpha: 1)
                pty.backgroundColor = UIColor(red: 90/255, green: 200/250, blue: 250/255, alpha: 1)
                break
            
            case 2:
                self.trading = "closed"
               solo.backgroundColor = UIColor(red: 90/255, green: 200/250, blue: 250/255, alpha: 1)
                              closed.backgroundColor = UIColor(red: 237/255, green: 27/255, blue: 37/255, alpha: 1)

               pty.backgroundColor = UIColor(red: 90/255, green: 200/250, blue: 250/255, alpha: 1)
                break
             
            case 3:
                self.trading = "pty"
                solo.backgroundColor = UIColor(red: 90/255, green: 200/250, blue: 250/255, alpha: 1)
                closed.backgroundColor = UIColor(red: 90/255, green: 200/250, blue: 250/255, alpha: 1)
                               pty.backgroundColor = UIColor(red: 237/255, green: 27/255, blue: 37/255, alpha: 1)

                break
            default:
                print("Ok")
            }
        }
        
    }
    @IBAction func uploadDoc(_ sender: Any) {
        
        
       
        if self.trading.isEmpty {
            self.showToast(messages: "Please Select Trading Type!")
        }
        else {
       let alert = UIAlertController(title: "Upload Documents", message: "", preferredStyle: .alert)
       let action1 = UIAlertAction(title: "Using Camera", style: .default) { (action) in
           
        self.isUploadClicked = true
           let image = UIImagePickerController()
           image.delegate = self
           image.sourceType = .camera
             
           self.present(image,animated: true)
           
           
       }
       
       let action2 = UIAlertAction(title: "From Library", style: .default) { (action) in
           
         self.present(self.documentPicker, animated: true, completion: nil)
           
           
       }
       
       let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
           
           alert.dismiss(animated: true, completion: nil)
       }
       
       alert.addAction(action1)
       alert.addAction(action2)
       alert.addAction(action3)
       
       self.present(alert,animated: true,completion: nil)
        }
    
    }
    
    
    func uploadImageOnFirebase(posi : String ,completion : @escaping (String) -> Void ) {
        var storage = Storage.storage().reference().child("ProfilePicture").child("\(Auth.auth().currentUser?.uid ?? "").png")
        var uploadData = (self.imageView.image?.jpegData(compressionQuality: 0.4))!
        if posi == "doc" {
          storage = Storage.storage().reference().child("Documents").child(Auth.auth().currentUser!.uid).child(self.trading).child("\(UUID().uuidString).png")
            uploadData = (self.myimage?.jpegData(compressionQuality: 0.4))!
        }
       
        var downloadUrl = ""
        
        
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
    
    func uploadDoc( url : URL,completion : @escaping (String) -> Void ) {
        self.progress.text = "Uploading..."
        self.progress.show()
        
        let storage = Storage.storage().reference().child("Documents").child(Auth.auth().currentUser!.uid).child(self.trading).child(UUID().uuidString)
        var downloadUrl = ""
        
        storage.putFile(from: url, metadata: nil) { (metadata, error) in
            if error == nil {
                storage.downloadURL { (url, error) in
                    if error == nil {
                        self.progress.hide()
                        self.showToast(messages: "Uploaded")
                        downloadUrl = url!.absoluteString
                    }
                    else {
                        self.showToast(messages: error!.localizedDescription)
                    }
                    completion(downloadUrl)
                    
                    
                }
            }
            else {
                self.showToast(messages: error!.localizedDescription)
                completion(downloadUrl)
            }
        }
        
       
    
    }
    
    
}



extension EditProfileViewController  : UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate {
    
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    
    self.uploadDoc(url: urls.first!) { (download) in
        
        Database.database().reference().child("Documents").child(Auth.auth().currentUser!.uid).child(self.trading).child(Database.database().reference().child("Documents").childByAutoId().key!).setValue(download)
    }
    
    }
    
    
  
    
    
}
