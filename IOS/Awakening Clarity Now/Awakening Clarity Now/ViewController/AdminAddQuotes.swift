//
//  AdminAddQuotes.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 22/05/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class AdminAddQuotes: UIViewController {
    
    
    @IBOutlet weak var close: UIImageView!
    @IBOutlet weak var addInsightBtn: UIButton!
    @IBOutlet weak var quotes: UITextView!
    @IBOutlet weak var image: UIImageView!
    var isImageChanged = false
   
    
    let placeholderText = "Enter Quote"
    override func viewDidLoad() {
        
        addInsightBtn.layer.cornerRadius = 4
        quotes.layer.cornerRadius = 4
       
        
        quotes.textColor = UIColor.lightGray
        quotes.text = placeholderText
        quotes.delegate = self
        
        
        //Close
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeBtnTapped)))
        
        //Image
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageAdd)))
        
    }
    
    @objc func imageAdd(){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image,animated: true)
    }
    
    
    
    @objc func closeBtnTapped(){
        self.dismiss(animated: true, completion: nil)
    }

  
    @IBAction func addInsightsBtnClicked(_ sender: Any) {
        let sQuotes = quotes.text
      
        
        if sQuotes == "" {
            showToast(message: "Enter Quote")
        }
        else {
            if !isImageChanged {
                showToast(message: "Choose Image")
            }
            else {
                
                
                ProgressHUDShow(text: "Adding...")
                Firestore.firestore().collection("DailyInsights").limit(toLast: 1).order(by: "id").getDocuments { snap, error in
                    if error == nil {
                        
                        if let snap = snap {
                            if !snap.isEmpty {
                                for s in snap.documents {
                                    let daily =  try?  s.data(as: DailyInsightsModel.self)
                                    
                                    self.uploadImageOnFirebase(id: String.init((daily?.id ?? 1) + 1), sQuotes: sQuotes!)
                                }
                            }
                            else {
                                self.uploadImageOnFirebase(id: "1", sQuotes: sQuotes!)
                            }
                        }
                        else {
                            self.uploadImageOnFirebase(id: "1", sQuotes: sQuotes!)
                        }
                    }
                    else {
                        self.ProgressHUDHide()
                        self.showError(error!.localizedDescription)
                    }
                   
                }
                
             
                
            }
        }
        
       
    }
    
    
    func uploadImageOnFirebase( id : String, sQuotes : String) {
        
        let storage = Storage.storage().reference().child("Quotes").child(id).child("\(id).png")
        var downloadUrl = ""
        let uploadData = (self.image.image?.jpegData(compressionQuality: 0.5))!
    
        storage.putData(uploadData, metadata: nil) { (metadata, error) in
            
            if error == nil {
                storage.downloadURL { (url, error) in
                    if error == nil {
                        downloadUrl = url!.absoluteString
                        

                        Firestore.firestore().collection("DailyInsights").document(id).setData(["quotes" : sQuotes,"image" :downloadUrl ,"id" : Int(id)!]) { error in
                            self.ProgressHUDHide()
                            if error == nil {
                                self.showToast(message: "Insight Added")
                                self.image.image = UIImage(named: "placeholder1")
                                self.quotes.text = ""
                            }
                            else {
                                
                                
                                self.showError(error!.localizedDescription)
                                
                            }
                        }
                    }
                    else{ self.ProgressHUDHide()
                        
                        self.showError(error!.localizedDescription)
                    }
                   
                    
            
                    
                }
            }
            else {
                self.ProgressHUDHide()
                self.showError(error!.localizedDescription)
            }
            
        }
    }
}

extension AdminAddQuotes : UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.originalImage] as? UIImage {
            isImageChanged = true
            image.image = editedImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension AdminAddQuotes:  UITextFieldDelegate, UITextViewDelegate {
    
    
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
    


    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            textView.text = placeholderText
        }
    }
    
}
