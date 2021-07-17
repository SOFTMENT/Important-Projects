//
//  UpdatePicturesViewController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 01/07/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import CropViewController
import SDWebImage

class UpdatePicturesViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var coverPicImage: UIImageView!
    var isProfilePicChanged = false
    var isCoverPicChanged = false
    override func viewDidLoad() {
        
        profilePicImage.makeRounded()
        coverPicImage.layer.cornerRadius = 2
        updateBtn.layer.cornerRadius = 6
       
        profilePicImage.isUserInteractionEnabled = true
        profilePicImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeProfilePic)))
        
        coverPicImage.isUserInteractionEnabled = true
        coverPicImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeCoverPic)))
        
        
        if let profilePicUrl = UserData.data?.profile {
            if profilePicUrl != "" {
                isProfilePicChanged = true
                profilePicImage.sd_setImage(with: URL(string: profilePicUrl), placeholderImage: UIImage(named: "profile-placeholder"), options: .refreshCached, completed: nil)
            }
        }
    }
    
    @IBAction func updateBtnClicked(_ sender: Any) {
        if !isProfilePicChanged {
            showToast(message: "Upload Profile Picture")
        }
        else if !isCoverPicChanged {
            showToast(message: "Upload Cover Picture")
        }
        else {
            self.getUserData(uid: Auth.auth().currentUser!.uid, showProgress: true)
        }
    }
    
    @objc func changeProfilePic() {
        
        let alert = UIAlertController(title: "Upload Profile Picture", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Using Camera", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.title = "Profile Picture"
            image.delegate = self
            image.sourceType = .camera
           
              
            self.present(image,animated: true)
            
            
        }
        
        let action2 = UIAlertAction(title: "From Photo Library", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.delegate = self
            image.title = "Profile Picture"
            image.sourceType = .photoLibrary
    
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
    
    @objc func changeCoverPic() {
        
        let alert = UIAlertController(title: "Upload Cover Photo", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Using Camera", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.title = "Cover Photo"
            image.delegate = self
            image.sourceType = .camera
            image.title = "Cover Photo"
            self.present(image,animated: true)
            
            
        }
        
        let action2 = UIAlertAction(title: "From Photo Library", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.delegate = self
            image.title = "Cover Photo"
            image.sourceType = .photoLibrary
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
        if let editedImage = info[.originalImage] as? UIImage {
            
            
            
            self.dismiss(animated: true) {
                
                let cropViewController = CropViewController(image: editedImage)
                cropViewController.title = picker.title
                cropViewController.delegate = self
                if picker.title! == "Profile Picture" {
                    cropViewController.customAspectRatio = CGSize(width: 1, height: 1)
                }
                else {
                    cropViewController.customAspectRatio = CGSize(width: 414  , height: 160)
                }
                
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.aspectRatioPickerButtonHidden = true
                self.present(cropViewController, animated: true, completion: nil)
            }
            
            
           
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
       
        self.ProgressHUDShow(text: "Updating...")
        
        if cropViewController.title! == "Profile Picture"  {
            self.isProfilePicChanged = true
            profilePicImage.image = image
            uploadImageOnFirebase(type: "ProfilePicture") { downloadURL in
               
                UserData.data?.profile = downloadURL
                Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).setData(["profile" : downloadURL], merge: true) { err in
                    self.ProgressHUDHide()
                    if err == nil{
                        
                        self.showToast(message: "Updated...")
                    }
                    else {
                        self.showError(err!.localizedDescription)
                    }
                }
                
            }
        }
        else {
            isCoverPicChanged = true
            coverPicImage.image = image
            uploadImageOnFirebase(type: "CoverPhoto") { downloadURL in
                UserData.data?.coverImage = downloadURL
                Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).setData(["coverImage" : downloadURL], merge: true) { err in
                    self.ProgressHUDHide()
                    if err == nil{
                        self.showToast(message: "Updated...")
                    }
                    else {
                        self.showError(err!.localizedDescription)
                    }
                }
                
            }
        }
        
        
      
        
        
    
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageOnFirebase(type : String ,completion : @escaping (String) -> Void ) {
        
        let storage = Storage.storage().reference().child(type).child("\(Auth.auth().currentUser?.uid ?? "").png")
        var downloadUrl = ""
        
        var uploadData : Data!
    
        if type == "ProfilePicture" {
            uploadData = (self.profilePicImage.image?.jpegData(compressionQuality: 0.4))!
        }
        else {
            uploadData  = (self.coverPicImage.image?.jpegData(compressionQuality: 0.4))!
         }
        
    
        
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
