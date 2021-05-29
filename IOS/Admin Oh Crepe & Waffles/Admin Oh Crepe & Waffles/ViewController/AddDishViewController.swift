//
//  AddDishViewController.swift
//  Admin Oh Crepe & Waffles
//
//  Created by Vijay on 08/05/21.
//


import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import MBProgressHUD
import CropViewController

class AddDishViewController: UIViewController {
    
 
    @IBOutlet weak var dish_img: UIImageView!
    @IBOutlet weak var addDishLabel: UILabel!
    
    @IBOutlet weak var dishNameEditField: UITextField!
    
    
    var isImageChanged = false
   
    override func viewDidLoad() {
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
       
        
       
        
        dishNameEditField.setRightPaddingPoints(10)
        dishNameEditField.setLeftPaddingPoints(10)
        
        dishNameEditField.layer.cornerRadius = 4
        
        dishNameEditField.delegate = self
        
        
       
        
        //TapToChangeImage
        addDishLabel.isUserInteractionEnabled = true
        addDishLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImages)))
    
    }
    
    @objc func changeImages() {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
      
      
        self.present(image,animated: true)
    }
    

    
    @IBAction func addDishBtnTapped(_ sender: Any) {
        let dish_title = dishNameEditField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
      
      
        let dr =  Firestore.firestore().collection("Menu").document()
        let dish_id = dr.documentID
        
        if isImageChanged {
            if dish_title != "" {
             
                    ProgressHUDShow(text: "Wait...")
            
                    
                    self.uploadImageOnFirebase(dish_id: dish_id) { (downloadUrl) in
                        
                        if downloadUrl != "" {
                            self.uploadDetailsOnDatabase(id : dish_id,downloadUrl: downloadUrl, dishName: dish_title!)
                        }
                        else {
                            self.showToast(message: "Image Upload Failed")
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                       
                
                        
                    
                }
                
            }
            else {
                showToast(message: "Please enter dish name")
            }
        }
        else {
            showToast(message: "Please add dish image")
        }
    }
    
    
  
    
    func uploadDetailsOnDatabase(id : String,downloadUrl : String ,dishName : String) {
        
            view.endEditing(true)
            Firestore.firestore().collection("Menu").document(id).setData(["id": id,"image": downloadUrl, "title" : dishName], completion: { error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                self.showToast(message: "Dish Added")
            
                self.dishNameEditField.text = ""
            
                self.isImageChanged = false
                self.dish_img.image = nil
            }
            else {
                self.showError(error!.localizedDescription)
            }
    
        })
    }
    
    
    
    func uploadImageOnFirebase( dish_id : String,completion : @escaping (String) -> Void ) {
        
        let storage = Storage.storage().reference().child("Menu").child("\(dish_id).png")
        var downloadUrl = ""
        let uploadData = (self.dish_img.image?.jpegData(compressionQuality: 0.3))!
    
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

extension AddDishViewController : UINavigationControllerDelegate, CropViewControllerDelegate, UIImagePickerControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.originalImage] as? UIImage {
            
            self.dismiss(animated: true) {
                let cropViewController = CropViewController(image: editedImage)
                cropViewController.delegate = self
                
                cropViewController.customAspectRatio = CGSize(width: 3, height: 4)
                cropViewController.aspectRatioLockEnabled = true
                self.present(cropViewController, animated: true, completion: nil)
            }
    
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
       
        isImageChanged = true
        
       dish_img.image = image
     self.dismiss(animated: true, completion: nil)
        
    
        
    }
}





extension AddDishViewController:  UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true;
    }
  
  
    
}
