//
//  MainProfile.swift
//  hbcumade
//
//  Created by Vijay on 05/04/21.
//
import Firebase
import FirebaseFirestoreSwift
import UIKit
import MHLoadingButton
import CropViewController

class MainProfile: BaseViewController, UIImagePickerControllerDelegate , CropViewControllerDelegate ,UINavigationControllerDelegate {
    
    @IBOutlet weak var converPic: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var classification: UILabel!
    @IBOutlet weak var classificationImage: UIImageView!
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var messageBtnStack: UIStackView!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var followBtn: LoadingButton!
    @IBOutlet weak var aboutSelf: UILabel!

    var userData : UserData?
    override func viewDidLoad() {
        
       
     
        
        
        profilePic.makeRounded()
        followBtn.layer.cornerRadius = 4
        followBtn.showLoader(userInteraction: false)
       
        
        if userData == nil {
            userData = UserData.data
        }
        
        guard let userData = userData else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        guard let currentUser = Auth.auth().currentUser else {
            self.logout()
            return
        }
        
        
       
        followBtn.isHidden = true
        
        if userData.uid != currentUser.uid {
           
            followBtn.isHidden = false
          
           
        
        }
        else {
            messageBtn.setTitle("Edit Profile")
        }
        
        messageBtn.layer.cornerRadius = 4
        messageBtn.dropShadow()

        
        if let coverImage = userData.coverImage {
            if coverImage != "" {
                converPic.sd_setImage(with: URL(string: coverImage), placeholderImage: UIImage(named: "cover_placeholder"), options: .continueInBackground , completed: nil)
            }
           
        }
        
        if let sProfileLink = userData.profile {
            if sProfileLink != "" {
                profilePic.sd_setImage(with: URL(string: sProfileLink), placeholderImage: UIImage(named: "profile-placeholder"), options: .continueInBackground , completed: nil)
            }
           
        }
        
        name.text = userData.name
        classification.text = userData.classification
        if userData.classification?.lowercased() == "Student" {
            classificationImage.image = UIImage(named: "icons8-reading-50")
        }
        else {
            classificationImage.image = UIImage(named: "icons8-graduation-cap-50")
        }
        
        schoolName.text = userData.school
        designation.text = userData.designation
        followers.text = String(userData.totalFollowers ?? 0)
        following.text = String(userData.totalFollowing ?? 0)
        
        aboutSelf.text = userData.aboutSelf
        
        
       //profileImage
        if userData.uid! == Auth.auth().currentUser!.uid {
            profilePic.isUserInteractionEnabled = true
            profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeProfilePic)))
            
            converPic.isUserInteractionEnabled = true
            converPic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeCoverPic)))
            
        }
        
        
        
        
        let docRef = Firestore.firestore().collection("Users").document(currentUser.uid).collection("Following").document(userData.uid!)
        docRef.getDocument { (document, error) in
            self.followBtn.hideLoader()
            if error == nil {
               if let document  = document {
                if document.exists {
                  
                    self.followBtn.setTitle("Unfollow", for: .normal)
                    self.followBtn.bgColor = UIColor.lightGray
                }
                
              }
               else {
                 print("Document does not exist")
              }
            }
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
            profilePic.image = image
            uploadImageOnFirebase(type: "ProfilePicture") { downloadURL in
               
                UserData.data?.profile = downloadURL
                Firestore.firestore().collection("Users").document(self.userData!.uid!).setData(["profile" : downloadURL], merge: true) { err in
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
            converPic.image = image
            
            uploadImageOnFirebase(type: "CoverPhoto") { downloadURL in
                UserData.data?.coverImage = downloadURL
                Firestore.firestore().collection("Users").document(self.userData!.uid!).setData(["coverImage" : downloadURL], merge: true) { err in
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
            uploadData = (self.profilePic.image?.jpegData(compressionQuality: 0.4))!
        }
        else {
            uploadData  = (self.converPic.image?.jpegData(compressionQuality: 0.4))!
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
    
    @IBAction func instagramBtnClicked(_ sender: Any) {
        
        
        if let instagramUsername = userData!.instagramUsername {
            if instagramUsername != "" {
              
                let Username =  instagramUsername // Your Instagram Username here
                let appURL = URL(string: "instagram://user?username=\(Username)")!
                let application = UIApplication.shared

                if application.canOpenURL(appURL) {
                    application.open(appURL)
                } else {
                    // if Instagram app is not installed, open URL inside Safari
                    let webURL = URL(string: "https://instagram.com/\(Username)")!
                    application.open(webURL)
                }
             
            }
            else {
                if userData!.uid == UserData.data!.uid! {
                    self.showMessage(title: "Not Added", message: "Please Add Instagram Username From My Account")
                }
                else {
                    self.showMessage(title: "Not Found", message: "User Instagram Account Not Found")
                }
              
            }
        }
        else {
            if userData!.uid == UserData.data!.uid! {
                self.showMessage(title: "Not Added", message: "Please Add Instagram Username From My Account")
            }
            else {
                self.showMessage(title: "Not Found", message: "User Instagram Account Not Found")
            }
       
        }
     
    }
    
    
    
    @IBAction func twitterClicked(_ sender: Any) {
        
        if let twitterUsername = userData!.twitterUsername {
            if twitterUsername != "" {
                let screenName = twitterUsername
                  let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
                  let webURL = NSURL(string: "https://twitter.com/\(screenName)")!

                  let application = UIApplication.shared

                  if application.canOpenURL(appURL as URL) {
                       application.open(appURL as URL)
                  } else {
                       application.open(webURL as URL)
                  }
            }
            else {
                if userData!.uid == UserData.data!.uid! {
                    self.showMessage(title: "Not Added", message: "Please Add Twitter Username From My Account")
                }
                else {
                    self.showMessage(title: "Not Found", message: "User Twitter Account Not Found")
                }            }
        }
        else {
            if userData!.uid == UserData.data!.uid! {
                self.showMessage(title: "Not Added", message: "Please Add Twitter Username From My Account")
            }
            else {
                self.showMessage(title: "Not Found", message: "User Twitter Account Not Found")
            }
        }
        
        
    }
    
    @IBAction func emailClicked(_ sender: Any) {
        
        let email = userData?.email ?? ""
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    @IBAction func messageClicked(_ sender: Any) {
        if Auth.auth().currentUser!.uid == userData?.uid {
            performSegue(withIdentifier: "editprofileseg", sender: nil)
        }
        else {
            performSegue(withIdentifier: "chatscreenseg", sender: nil)
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatscreenseg" {
            if let destinationVC = segue.destination as? ChatScreenViewController {
                destinationVC.friendName = userData?.name
                destinationVC.friendImage = userData?.profile
                destinationVC.friendUid  = userData?.uid
                destinationVC.friendToken = userData?.token
            }
        }
    }
    
    @IBAction func followClicked(_ sender: Any) {
        guard let myData = UserData.data else {
            self.logout()
            return
        }
        
        if let userData = userData {
            
            self.followBtn.showLoader(userInteraction: false)
            if followBtn.titleLabel?.text?.lowercased() == "follow" {
                Firestore.firestore().collection("Users").document(userData.uid!).collection("Followers").document(Auth.auth().currentUser!.uid).setData(["name" : myData.name!,"uid" : myData.uid!,"image" : myData.profile!,"time" : FieldValue.serverTimestamp()]) { error in
                    self.followBtn.hideLoader()
                    if error == nil {
                        Firestore.firestore().collection("Users").document(userData.uid!).setData(["totalFollowers": FieldValue.increment(Int64(1))],merge: true)
                    }
                }
                
                Firestore.firestore().collection("Users").document(myData.uid!).collection("Following").document(userData.uid!).setData(["name" : userData.name!,"uid" : userData.uid!,"image" : userData.profile!,"time" : FieldValue.serverTimestamp()]) { error in
                    if error == nil {
                        Firestore.firestore().collection("Users").document(myData.uid!).setData(["totalFollowing": FieldValue.increment(Int64(1))],merge: true)
                    }
                }
                
                userData.totalFollowers = (userData.totalFollowers ?? 0)  + 1;
                followers.text = "\(userData.totalFollowers!)"
                
                UserData.data?.totalFollowing = UserData.data?.totalFollowing ?? 0 + 1
                
                followBtn.setTitle("Unfollow", for: .normal)
                followBtn.bgColor = UIColor.lightGray
                
                Firestore.firestore().collection("UserPosts").document("Posts").collection(userData.uid!).whereField("uid", isEqualTo: userData.uid!).getDocuments { snapshot, error in
                    
                    if error == nil {
                        if let snap = snapshot {
                            for snap in snap.documents {
                                if let post = try? snap.data(as: PostID.self) {
                                    Firestore.firestore().collection("UserPosts").document("Posts").collection(myData.uid!).document(post.postId!).setData(["postAt" : post.postAt!, "postId" : post.postId!])
                                }
                                
                            }
                        }
                    }
                    
                }
                
            }
            else {
                Firestore.firestore().collection("Users").document(userData.uid!).collection("Followers").document(Auth.auth().currentUser!.uid).delete { error in
                    self.followBtn.hideLoader()
                    if error == nil {
                        Firestore.firestore().collection("Users").document(userData.uid!).setData(["totalFollowers": FieldValue.increment(Int64(-1))],merge: true)
                    }
                }
                
                Firestore.firestore().collection("Users").document(myData.uid!).collection("Following").document(userData.uid!).delete { error in
                    if error == nil {
                        Firestore.firestore().collection("Users").document(myData.uid!).setData(["totalFollowing": FieldValue.increment(Int64(-1))],merge: true)
                    }
                }
                
                userData.totalFollowers = (userData.totalFollowers ?? 0 )  - 1;
                followers.text = "\(userData.totalFollowers!)"
                UserData.data?.totalFollowing = UserData.data?.totalFollowing ?? 0 - 1
                followBtn.setTitle("Follow", for: .normal)
                followBtn.bgColor = UIColor.black
                
                Firestore.firestore().collection("UserPosts").document("Posts").collection(userData.uid!).whereField("uid", isEqualTo: userData.uid!).getDocuments { snapshot, error in
                    
                    if error == nil {
                        if let snap = snapshot {
                            for snap in snap.documents {
                                if let post = try? snap.data(as: PostID.self) {
                                    Firestore.firestore().collection("UserPosts").document("Posts").collection(myData.uid!).document(post.postId!).delete()
                                }
                                
                            }
                        }
                    }
                    
                }
               
            }
           
            
        }
      
    }
    
}
