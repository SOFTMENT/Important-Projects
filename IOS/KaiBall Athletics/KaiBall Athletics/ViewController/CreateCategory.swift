//
//  CreateCategory.swift
//  KaiBall Athletics
//
//  Created by Vijay on 02/05/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import MBProgressHUD

class CreateCategory: UIViewController {
    
   
    @IBOutlet weak var cat_img: UIImageView!
    
    @IBOutlet weak var addCategoryLabel: UILabel!
    
    @IBOutlet weak var categoryNameEditField: UITextField!
    
    @IBOutlet weak var categoryDescField: UITextView!
    
    let placeholderText = "Category Description"
    
    var isImageChanged = false
   
    override func viewDidLoad() {
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        categoryDescField.textColor = UIColor.lightGray
        categoryDescField.text = placeholderText
        
        categoryDescField.layer.cornerRadius = 4
     
        
        categoryNameEditField.setRightPaddingPoints(10)
        categoryNameEditField.setLeftPaddingPoints(10)
        
        categoryNameEditField.layer.cornerRadius = 4
        
        categoryNameEditField.delegate = self
        categoryDescField.delegate = self
        
        
        //AddCategoryImage
        
        //TapToChangeImage
       addCategoryLabel.isUserInteractionEnabled = true
       addCategoryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImages)))
    
    }
    
    @objc func changeImages() {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = true
        self.present(image,animated: true)
    }
    

    
    
    
    @IBAction func createCategoryBtnTapped(_ sender: Any) {
        let cat_title = categoryNameEditField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let cat_desc = categoryDescField.text.trimmingCharacters(in: .whitespacesAndNewlines)
      
        let dr =  Firestore.firestore().collection("Categories").document()
        let cat_id = dr.documentID
        
        if isImageChanged {
            if cat_title != "" {
                if cat_desc != "" {
                    
                    ProgressHUDShow(text: "Wait...")
            
                    
                    self.uploadImageOnFirebase(cat_id: cat_id) { (downloadUrl) in
                        
                        if downloadUrl != "" {
                            self.uploadDetailsOnDatabase(id : cat_id,downloadUrl: downloadUrl, categoryName: cat_title!, categoryDesc: cat_desc)
                        }
                        else {
                            self.showToast(message: "Image Upload Failed")
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                       
                
                        
                    }
                }
                else {
                    showToast(message: "Please enter category desc")
                }
            }
            else {
                showToast(message: "Please enter category name")
            }
        }
        else {
            showToast(message: "Please add category image")
        }
    }
    
    
    func uploadDetailsOnDatabase(id : String,downloadUrl : String ,categoryName : String , categoryDesc : String) {
        
       
            Firestore.firestore().collection("Categories").document(id).setData(["id": id,"image": downloadUrl, "title" : categoryName, "desc" :categoryDesc,"totalVideos" : 0], completion: { error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                self.showToast(message: "Category Added")
                self.cat_img.image = UIImage(named: "placeholder_image")
                self.categoryDescField.textColor = UIColor.lightGray
                self.categoryNameEditField.text = ""
                self.categoryDescField.text = self.placeholderText
                self.isImageChanged = false
            }
            else {
                self.showError(error!.localizedDescription)
            }
    
        })
    }
    
    
    
    func uploadImageOnFirebase( cat_id : String,completion : @escaping (String) -> Void ) {
        
        let storage = Storage.storage().reference().child("Categories").child(cat_id).child("\(cat_id).png")
        var downloadUrl = ""
        let uploadData = (self.cat_img.image?.jpegData(compressionQuality: 0.4))!
    
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
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    

}

extension CreateCategory : UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            isImageChanged = true
            cat_img.image = editedImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}



extension CreateCategory:  UITextFieldDelegate, UITextViewDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true;
    }
  
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == placeholderText {
            textView.textColor = UIColor.darkGray
            textView.text = ""
        }
        return true
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            textView.text = placeholderText
        }
    }
    
}
