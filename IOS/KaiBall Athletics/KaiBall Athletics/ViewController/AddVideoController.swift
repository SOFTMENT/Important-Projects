//
//  AddVideoController.swift
//  KaiBall Athletics
//
//  Created by Vijay on 03/05/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import MBProgressHUD
import AVFoundation
import Photos
import CoreVideo
import AssetsLibrary

class AddVideoController: UIViewController {
    var cat_id : String?
    
    @IBOutlet weak var chooseVideo: UIView!
    
    @IBOutlet weak var videoName: UILabel!
    
    @IBOutlet weak var videoTitle: UITextField!
    
    var isVideoAdded = false
    
    var videoURL : NSURL?
    var duration : String = "00:00"
    
    
    
    override func viewDidLoad() {
       
        videoTitle.setLeftPaddingPoints(10)
        videoTitle.setRightPaddingPoints(10)
        
        chooseVideo.isUserInteractionEnabled = true
        chooseVideo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseVideoFromDevice)))
        
        
    }
    
    @objc func chooseVideoFromDevice() {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.mediaTypes = ["public.movie"]
        self.present(image,animated: true)
    }
    @IBAction func addVideoBtnTapped(_ sender: Any) {
        
        let sTitle = videoTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let dr =  Firestore.firestore().collection("Categories").document(cat_id!).collection("Videos").document()
        let videoId = dr.documentID
        if isVideoAdded {
            if sTitle != "" {
                
                ProgressHUDShow(text: "Uploading...")
                uploadVideoOnFirebase(videoId: videoId) { downloadURL in
                    if downloadURL != "" {
                        self.uploadVideoDataOnFirebase(id: videoId, title: sTitle!, videoLink: downloadURL, duration: self.duration)
                    }
                    else {
                        self.showToast(message: "Video Upload Failed.")
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
            else {
              
                self.showToast(message: "Please Enter Video Title")
            }
        }
        else {
            self.showToast(message: "Please choose video")
        }
        
    }
    
    func  uploadVideoDataOnFirebase(id : String, title : String, videoLink : String, duration : String) {
        Firestore.firestore().collection("Categories").document(cat_id!).collection("Videos").document(id)
            .setData(["id" : id, "title" : title, "duration" : duration , "videoLink" : videoLink, "date" : Date()]) { error in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    self.videoTitle.text = ""
                    self.isVideoAdded = false
                    self.videoName.isHidden = true
                    self.showToast(message: "Video Has Added")
                     
                    Firestore.firestore().collection("Categories").document(self.cat_id!).updateData(["totalVideos" : FieldValue.increment(Int64(1))])
                    
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
    }
    
    func uploadVideoOnFirebase(videoId : String, completion : @escaping (String) -> Void ) {
        
        let storage = Storage.storage().reference().child("Categories").child(cat_id!).child("\(videoId).mov")
        var downloadUrl = ""
      
        
        let metadata = StorageMetadata()
        //specify MIME type
        
        metadata.contentType = "video/*"

    

        if let videoData = try? NSData(contentsOf: videoURL! as URL, options: .mappedIfSafe) as Data {
            
              storage.putData(videoData, metadata: metadata) { metadata, error in
                  if error == nil {
                      storage.downloadURL { (url, error) in
                          if error == nil {
                              downloadUrl = url!.absoluteString
                          }
                          completion(downloadUrl)
                      }
                  }
                  else {
                      print(error!.localizedDescription)
                      completion(downloadUrl)
                  }
              }
        }
        else {
            completion(downloadUrl)
            self.showToast(message: "Error YR")
        }
        

    }
    
}

extension AddVideoController : UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
        isVideoAdded = true
        videoName.isHidden = false
        
        videoURL = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerMediaURL") ] as? NSURL
      
        
     
        let avplayeritem = AVPlayerItem(url: videoURL! as URL)
       
           let totalSeconds = avplayeritem.asset.duration.seconds
           let hours = Int(totalSeconds / 3600)
           let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
           let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))

           if hours > 0 {
              duration =  String(format: "%i:%02i:%02i", hours, minutes, seconds)
           } else {
              duration = String(format: "%02i:%02i", minutes, seconds)
               print(duration)
           }

        
        self.dismiss(animated: true, completion: nil)
    }
    
}




