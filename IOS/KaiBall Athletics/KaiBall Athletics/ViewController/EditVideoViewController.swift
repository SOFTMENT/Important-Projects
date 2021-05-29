//
//  EditVideoViewController.swift
//  KaiBall Athletics
//
//  Created by Vijay on 08/05/21.
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

class EditVideoViewController : UIViewController {
    var cat_id : String?
    
    @IBOutlet weak var chooseVideo: UIView!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var videoTitle: UITextField!
    
    var isVideoAdded = false
    var videoURL : NSURL?
    var duration : String = "00:00"
    
    var video : Video?
    
    
    
    override func viewDidLoad() {
       
        videoTitle.setLeftPaddingPoints(10)
        videoTitle.setRightPaddingPoints(10)
        
        chooseVideo.isUserInteractionEnabled = true
        chooseVideo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseVideoFromDevice)))
        
        if let video =  video {
            videoTitle.text = video.title
            duration = video.duration
            
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
        
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
        let videoId = video!.id
        if isVideoAdded {
            if sTitle != "" {
                
                ProgressHUDShow(text: "Updating...")
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
            ProgressHUDShow(text: "Updating...")
            self.uploadVideoDataOnFirebase(id: videoId, title: sTitle!, videoLink: video!.videoLink, duration: self.duration)
        }
        
    }
    
    func  uploadVideoDataOnFirebase(id : String, title : String, videoLink : String, duration : String) {
        Firestore.firestore().collection("Categories").document(cat_id!).collection("Videos").document(id)
            .setData(["id" : id, "title" : title, "duration" : duration , "videoLink" : videoLink, "date" : video!.date]) { error in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    self.videoTitle.text = ""
                    self.isVideoAdded = false
                    self.videoName.isHidden = true
                    self.showToast(message: "Video Has Updated")
                    DispatchQueue.main.async {
                        sleep(2)
                        self.navigationController?.popViewController(animated: true)
                    }
                 
                   
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
            self.showToast(message: "Error!")
        }
        

    }
    
}

extension EditVideoViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
        isVideoAdded = true
        videoName.isHidden = false
        
        videoName.text = "Video has replaced."
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




