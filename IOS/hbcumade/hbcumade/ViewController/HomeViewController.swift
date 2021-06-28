//
//  HomeViewController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 17/01/21.
//

import UIKit
import Firebase
import FirebaseStorage
import CropViewController
import SDWebImage
import DropDown

class HomeViewController: BaseViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate{
 
    @IBOutlet weak var nopostavailable: UILabel!
    @IBOutlet weak var halfTextView: UITextView!
    @IBOutlet weak var whatsFullView: UIView!
    @IBOutlet weak var whatsHalfView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var beforePostImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postEditField: UITextView!
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var profilePicImage2: UIImageView!
    @IBOutlet weak var heartBtn: UIImageView!
    @IBOutlet weak var globeBtn: UIImageView!
    @IBOutlet weak var clockBtn: UIImageView!
    @IBOutlet weak var plusBtn: UIImageView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var removeImageBtn: UIButton!
    @IBOutlet weak var viewOfImageView: UIStackView!
    var refReg : ListenerRegistration?
    var refRegs :Array<ListenerRegistration> = []
    var refComment : Array<ListenerRegistration> = []
    
    var cUid : String?
    var followingFriends = Array<FriendList>()
    var followersFriends = Array<FriendList>()
    var postIDs = Array<PostID>()
    var postids = Array<String>()
    var posts_student = [Date : Post]()
    var posts_alumni = [Date : Post]()
    var student : [Dictionary<Date,Post>.Element]?
    var alumni : [Dictionary<Date,Post>.Element]?
    
    let group1 = DispatchGroup()
    
    var cellHeights = [IndexPath: CGFloat]()
    

  
    let menu = DropDown()
    let myMenu = DropDown()
       
    
    
    var tempHeight : CGFloat = 0
    var hasImageChanged : Bool = false
    var postVisibility : String = "all"
    override func viewDidLoad() {
   
        cUid = Auth.auth().currentUser?.uid
        
        
        self.setUploadPostImage(image: UIImage(named: "placeholder-1")!)
       
       
        halfTextView.delegate = self
        
        postEditField.delegate = self
        postEditField.textColor = UIColor.lightGray
    
        
        postBtn.layer.cornerRadius = 6
        removeImageBtn.layer.cornerRadius = 6
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        tableView.contentInsetAdjustmentBehavior = .never

   
        definesPresentationContext = true

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(tapRecognizer)
       
        
        //TapToChangeImage
        plusBtn.isUserInteractionEnabled = true
        plusBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImages)))
        
        //TapToChangeVisibility
        globeBtn.isUserInteractionEnabled = true
        globeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeVisibility)))
       
        
        
        
        
        Constants.selected_classification = UserData.data?.classification ?? "student"
        
        ProgressHUDShow(text: "Loading…")
        getMyPostsID()
        getFollowingFriendsData()
        getFollowersFriendsData()
        updateUI()
        updateFCMToken()
       
        
        menu.dataSource = ["Send Message"]
        menu.textFont = UIFont(name: "RobotoCondensed-Regular", size: 13)!
        menu.direction = .bottom
        menu.setCornerBorder(color: .none, cornerRadius: 10, borderWidth: 0)
        
        
        myMenu.dataSource = ["Delete"]
        myMenu.textFont = UIFont(name: "RobotoCondensed-Regular", size: 13)!
        myMenu.direction = .bottom
        myMenu.setCornerBorder(color: .none, cornerRadius: 10, borderWidth: 0)
        
    
     
        
    }
    
  
    
    

   
    
    func updateFCMToken(){
        Firestore.firestore().collection("Users").document(cUid!).setData(["token" : Messaging.messaging().fcmToken ?? ""], merge: true)
    }
    

    
   
    @IBAction func removeImageBtnClicked(_ sender: Any) {
        beforePostImage.image = nil
        hasImageChanged = false
        viewOfImageView.isHidden = true
    }
    
    
    @objc func hideKeyBoard() {
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
       
      
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.tintColor = UIColor.darkGray
            textView.textColor = UIColor.black
        }
        else if textView == halfTextView {
      
            whatsHalfView.isHidden = true
            whatsFullView.isHidden = false
            
        
            DispatchQueue.main.async {
                self.postEditField.becomeFirstResponder()
            }
            
        }
        else {
            
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  {
            textView.text = "What's on your mind?"
        
            textView.textColor = UIColor.lightGray
        
        }
        
        
    }
    
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
   
    @IBAction func postBtnClicked(_ sender: Any) {
        var postText = postEditField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if postText == "What's on your mind?" {
            postText = ""
        }
        if postText != ""  || hasImageChanged{
           
            addNewPost(postText: postText)
        }
    }
    
    func addNewPost(postText : String) {
        ProgressHUDShow(text: "Posting...")
        postBtn.isEnabled = false
        let ref = FirebaseStoreManager.db.collection("AllPosts")
        let docID = ref.document().documentID
        let time = FieldValue.serverTimestamp()
       
        uploadImageOnFirebase(postId: docID, completion: { downloadURL in
        
                
            let data = ["postId" : docID, "uid" : self.cUid!, "name" : UserData.data?.name ?? "Default", "classification" : UserData.data?.classification ?? "Student","image" : UserData.data?.profile ?? "", "postText" : postText, "postImage" : downloadURL,
                        "postLike" : [] ,"postVisibility" : self.postVisibility , "postAt" : time ,"commentCount" : 0, "school": UserData.data?.school ?? "", "token" : UserData.data?.token ?? ""] as [String : Any]
        
        ref.document(docID).setData(data) { (error) in
            self.ProgressHUDHide()
            self.postBtn.isEnabled = true
            if error != nil {
                self.showError(error!.localizedDescription)
            }
            else {
                
                self.whatsHalfView.isHidden = false
                self.whatsFullView.isHidden = true
                
                self.hasImageChanged = false
                self.beforePostImage.image = nil
                self.viewOfImageView.isHidden = true
                self.postEditField.text = "What's on your mind?"
            
                self.postEditField.textColor = UIColor.lightGray
                self.postEditField.resignFirstResponder()
                
                
            
                
                let mydata = [ "postAt" : time,"postId" : docID, "uid" : self.cUid!] as [String : Any]
                if self.followersFriends.count < 499 {
                    let batch = FirebaseStoreManager.db.batch()
                    
                    let nycRef = FirebaseStoreManager.db.collection("UserPosts").document("Posts").collection(self.cUid!).document(docID)
                    batch.setData(mydata, forDocument: nycRef)
                    for friend in self.followersFriends {
                        let nycRef = FirebaseStoreManager.db.collection("UserPosts").document("Posts").collection(friend.uid!).document(docID)
                        batch.setData(mydata, forDocument: nycRef)
                    }
                   
                    
                    // Commit the batch
                    batch.commit() { err in
                        if let err = err {
                            print("Error writing batch \(err)")
                        } else {
                            print("Batch write succeeded.")
                        }
                    }
                    
                }
                else {
                    
                }
            
                
                self.showToast(message: "Post has been added")
            }
        }
          
        })
        
    }
    
    
    func getFollowingFriendsData() {
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("Following").addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("Error Retriving Friends")
            }
            else {
                self.followingFriends.removeAll()
                guard let documents = snapshot?.documents else {
                           print("Error fetching documents: \(error!)")
                           return
                       }
                self.followingFriends = documents.map { (snapshot) -> FriendList in
                    
                    let friendData = try? snapshot.data(as: FriendList.self)
                 
                    return friendData!
                    
                }
            }
        }
    }
    
    func getFollowersFriendsData() {
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("Followers").addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("Error Retriving Friends")
            }
            else {
                self.followersFriends.removeAll()
                guard let documents = snapshot?.documents else {
                           print("Error fetching documents: \(error!)")
                           return
                       }
                self.followersFriends = documents.map { (snapshot) -> FriendList in
                    
                    let friendData = try? snapshot.data(as: FriendList.self)
                 
                    return friendData!
                    
                }
            }
        }
    }
    
    func updateUI() {
        setProfilePic()
    }
    
   
    
    func getMyPostsID() {
      
        FirebaseStoreManager.db.collection("UserPosts").document("Posts").collection(cUid!).order(by: "postAt",descending: true).addSnapshotListener(includeMetadataChanges: false, listener: { snapshot, error in
            
           
            
            if error != nil {
                self.ProgressHUDHide()
                self.showError(error.debugDescription)
            }
            else {
               
                if let snapshot = snapshot {
                   
                    let documents  = snapshot.documents
                    self.postIDs.removeAll()
                    self.postids.removeAll()
 
                    self.postIDs = documents.map { (snapshot) -> PostID in
                        let post = try? snapshot.data(as: PostID.self)
                        self.postids.append((post?.postId)!)
                        return post!
                        
                    }
                 
                   
                  
                        if self.postids.count > 0 {
                            for re in self.refRegs {
                                re.remove()
                            }
                             
                             
                            self.getPosts()
                        }
                        else {
                            self.ProgressHUDHide()
                        }
    
                    
                        
                      
                }
                else {
                  
                    self.ProgressHUDHide()
                }
               
              
                
            }
            
        })
        
        
    }
    
    func getPosts()  {
    
       
        self.posts_student.removeAll()
        self.posts_alumni.removeAll()
        refRegs.removeAll()

       
        for postId in self.postids {
            
           
              
   
           let ref =  FirebaseStoreManager.db.collection("AllPosts").whereField("postId", isEqualTo: postId).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
              
           
             
              if error != nil {
                  self.showError(error!.localizedDescription)
              }
                  else {
                      if let snapshot = snapshot {
                      
                          if !(snapshot.metadata.hasPendingWrites) {
                            
                            if snapshot.isEmpty  {
                                FirebaseStoreManager.db.collection("UserPosts").document("Posts").collection(self.cUid!).document(postId).delete()
                            }
                            snapshot.documentChanges.forEach { document in
                              
                                if let post = try? document.document.data(as: Post.self) {
                                    
                                    
                                    if document.type == .removed {
                                        
                                        print("REMOVED")
                                        if post.classification!.lowercased().elementsEqual("student"){
                                            
                                            self.posts_student.removeValue(forKey: post.postAt!)
                                            
                                        }
                                        else {
                                            self.posts_alumni.removeValue(forKey: post.postAt!)
                                        }
                                    }
                                    else {
                                        print("ADDDED, MODIFIED")
                                      
                                        if post.classification!.lowercased().elementsEqual("student"){
                                            
                                            self.posts_student[post.postAt!]  = post
                                            
                                        }
                                        else {
                                            self.posts_alumni[post.postAt!]  = post
                                        }
                                        
                                      
                                    }
                                   
                                }
                                
                               
                                }
                           
                          
                           
                            
                               
                            self.ProgressHUDHide()
                            self.reloadTableView()
                             
                                
                              
                          }
                          
                      }
                      else {
                          self.ProgressHUDHide()
                          print("Error fetching documents: \(error!)")
                          
                      }
                      

                  }
                    
            
           
            
            
           }
                 
            
            
            
            self.refRegs.append(ref)
              
        }
        

    }
    
    
 
    func reloadTableView(){
       
        
        
        student = posts_student.sorted(by: {$0.value.postAt! > $1.value.postAt!} )
        alumni = posts_alumni.sorted(by: {$0.value.postAt! > $1.value.postAt!} )
    
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
      
    }
 
    
    func setProfilePic() {
        
        self.profilePicImage2.makeRounded()
         if let profileImageLink = UserData.data?.profile {
         
             self.profilePicImage2.sd_setImage(with: URL(string: profileImageLink), placeholderImage: UIImage(named: "profile-user"))
           
         }
        
       self.profilePicImage.makeRounded()
        if let profileImageLink = UserData.data?.profile {
        
            self.profilePicImage.sd_setImage(with: URL(string: profileImageLink), placeholderImage: UIImage(named: "profile-user"))
          
        }
    }
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if Constants.selected_classification.lowercased().elementsEqual("alumni") {
            if self.posts_alumni.count > 0 {
                self.nopostavailable.isHidden = true
                return posts_alumni.count
               
            }
            else {
                
                self.nopostavailable.isHidden = false
                return 0
            }
          
        }
        else {
            if self.posts_student.count > 0 {
                self.nopostavailable.isHidden = true
                return posts_student.count
            }
            else {
              
                self.nopostavailable.isHidden = false
                return 0
            }
        }
        
    }
    
    
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        print(indexPath.row)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "homeviewcell", for: indexPath) as? HomePageTableCell {
            
            
        
           
            let post =  Constants.selected_classification.lowercased().elementsEqual("student") ? self.student![indexPath.row].value : self.alumni![indexPath.row].value
         
            cell.postProfile.makeRounded()
            cell.writeACommentImage.makeRounded()
            cell.writeCommentEditField.layer.borderWidth  = 1.5
            cell.writeCommentEditField.layer.borderColor = UIColor.black.cgColor
            cell.writeCommentEditField.layer.cornerRadius = 8
            cell.writeCommentEditField.attributedPlaceholder = NSAttributedString(string: "Write a comment",
                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
           
            cell.self.writeCommentEditField.setRightPaddingPoints(10)
            cell.self.writeCommentEditField.setLeftPaddingPoints(10)
            let recog = UITapGestureRecognizer(target: self, action: #selector(self.gotoCommentPage(gesture:)))
            let recog1 = UITapGestureRecognizer(target: self, action: #selector(self.gotoCommentPage(gesture:)))
            cell.commentBtn.tag = indexPath.row
            cell.commentBtn.isUserInteractionEnabled = true
            cell.commentBtn.addGestureRecognizer(recog1)
           
          
            cell.writeCommentEditField.tag = indexPath.row
            cell.writeCommentEditField.isUserInteractionEnabled = true
            cell.writeCommentEditField.addGestureRecognizer(recog)
            
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.isUserInteractionEnabled = true
            cell.likeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeButtonTapped(sender:))))
            
            
            cell.writeCommentEditField.delegate = cell.self
            
            
            cell.name.text = post.name
            
            cell.schoolName.text = post.school
            
            cell.commentCount.text = String.init(post.commentCount!)
         

            cell.likeCount.text = String.init(post.postLike!.count)
            
            cell.shareBtn.isUserInteractionEnabled = true
            let shareGest = MyTapPassViewGesture(target: self, action: #selector(sharePost(value:)))
            shareGest.post = post
            cell.shareBtn.addGestureRecognizer(shareGest)
            
            
            cell.viewForViewProfile.isUserInteractionEnabled = true
            let tappy = MyTapGesture(target: self, action: #selector(showUserProfile(tappy:)))
            tappy.id = post.uid!
            cell.viewForViewProfile.addGestureRecognizer(tappy)
          
            
            cell.postMore.isUserInteractionEnabled = true
            let myTapViewPass = MyTapPassViewGesture(target: self, action: #selector(postMoreClicked(view:)))
            myTapViewPass.myview = cell.postMore
            myTapViewPass.post = post
            cell.postMore.addGestureRecognizer(myTapViewPass)
            
            
            if post.postLike!.contains(where: { (postLike) -> Bool in
                if postLike == cUid! {
                    return true
                }
                return false
            }) {
                cell.likeBtn.image = UIImage(named: "icons8-heart-48")
            }
            else {
                cell.likeBtn.image = UIImage(named: "icons8-heart-64")
            }
            
           
            if (post.classification?.caseInsensitiveCompare("Alumni") == .orderedSame) {
                cell.classificationImage.image = UIImage(named: "icons8-graduation-cap-50")
            }
            else {
                cell.classificationImage.image = UIImage(named: "icons8-reading-50")
            }
            
            if post.postImage == "" {
                cell.postImage.isHidden = true
            }
            else {
                cell.setCustomImage(image: UIImage(named: "placeholder-1")!)
                cell.postImage.isHidden = false
              
                cell.postImage.sd_setImage(with: URL(string: post.postImage!), placeholderImage: UIImage(named: "placeholder-1"), options: .continueInBackground)
 
            }
            
          

         
            
            if post.postText == "" {
                cell.postText.isHidden = true
            }
            else {
                cell.postText.isHidden = false
                cell.postText.text = post.postText
            }
            
            if post.image != "" {
                
                
                cell.postProfile.sd_setImage(with: URL(string: post.image!), placeholderImage: UIImage(named: "profile-user"))
              
                
            }
            
            if let sProfile = UserData.data?.profile  {
       
                cell.writeACommentImage.sd_setImage(with: URL(string: sProfile), placeholderImage: UIImage(named: "profile-user"))
            }
            
            cell.postTime.text = post.postAt?.timeAgoSinceDate()
          
            
            let totalRow = tableView.numberOfRows(inSection: indexPath.section)
                    if(indexPath.row == totalRow - 1)
                    {
                        DispatchQueue.main.async {
                            self.updateTableViewHeight()
                        }
                    }

           return cell
        }
        
        return HomePageTableCell()
        
    }
    
    
  
  
    func deletePost(postId : String, uid : String, imageURL : String){
        self.ProgressHUDShow(text: "Deleting...")
        Firestore.firestore().collection("AllPosts").document(postId).delete { err in
            if err == nil {
                
                Firestore.firestore().collection("UserPosts").document("Posts").collection(uid).document(postId).delete()
                if imageURL != "" {
                    Storage.storage().reference(forURL: imageURL).delete(completion: nil)
                }
               
                
                self.ProgressHUDHide()
            }
            else {
                self.showError(err!.localizedDescription)
            }
        }
    }
    
    
    @objc func sharePost(value : MyTapPassViewGesture){
        if let post = value.post {
            let someText:String = post.postText ?? ""
            let objectsToShare:URL = URL(string: post.postImage ?? "")!
           let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
           let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
           activityViewController.popoverPresentationController?.sourceView = self.view

           self.present(activityViewController, animated: true, completion: nil)
        }
    
    }
    
    @objc func showUserProfile(tappy : MyTapGesture){
        self.ProgressHUDShow(text: "")
        Firestore.firestore().collection("Users").document(tappy.id).getDocument { snap, err in
            self.ProgressHUDHide()
            if err == nil {
                if let snap = snap {
                    if let user = try? snap.data(as: UserData.self) {
                        self.performSegue(withIdentifier: "viewprofileseg", sender: user)
                    }
                }
            }
            else {
                self.showError(err!.localizedDescription)
            }
        }
    }
    
    @objc func postMoreClicked(view : MyTapPassViewGesture){
       
        if let post = view.post {
            if post.uid! == UserData.data!.uid {
                myMenu.anchorView = view.myview
                myMenu.bottomOffset = CGPoint(x: -80, y:(myMenu.anchorView?.plainView.bounds.height)!)
               
                 myMenu.selectionAction = { [unowned self] (index: Int, item: String) in
                    if index == 0 {
                        self.deletePost(postId: post.postId!, uid: post.uid!,imageURL: post.postImage ?? "")
                    }
                }
                DispatchQueue.main.async {
                    self.myMenu.show()
                }
            }
            else {
                menu.anchorView = view.myview
                menu.bottomOffset = CGPoint(x: -80, y:(menu.anchorView?.plainView.bounds.height)!)
               
                menu.selectionAction = { [unowned self] (index: Int, item: String) in
                    if index == 0 {
                        self.performSegue(withIdentifier: "chatscreenseg", sender: view.post)
                    }
                }
                DispatchQueue.main.async {
                    self.menu.show()
                }
            }
         
        }
      
        
    }
    
    
    
    
    public func updateTableViewHeight(){
       
        self.tableViewHeight.constant = self.tableView.contentSize.height
        self.tableView.layoutIfNeeded()
    }
   
    @objc func gotoCommentPage(gesture : UIGestureRecognizer) {
 
        let post =  Constants.selected_classification.lowercased().elementsEqual("alumni") ? self.alumni![(gesture.view?.tag)!].value : self.student![(gesture.view?.tag)!].value
        self.performSegue(withIdentifier: "commentseg", sender: post.postId)
    }
   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == "topbarseg" {
            if let topbar = segue.destination as? TopBarViewController {
            topbar.classificationDelegate = self
            
            }
            
        }
        else if segue.identifier == "commentseg" {
            if let destination = segue.destination as? CommentViewController {
                if let postId = sender as? String {
 
                    destination.postId = postId
                }
            }
        }
        else if segue.identifier == "chatscreenseg" {
            if let chatscreen  = segue.destination as? ChatScreenViewController {
                if  let post  = sender as? Post {
                    chatscreen.friendImage = post.image
                    chatscreen.friendName = post.name
                    chatscreen.friendUid = post.uid
                    chatscreen.friendToken = post.token
                }
            }
        }
        else if segue.identifier == "viewprofileseg" {
            if let mainProfileVC =  segue.destination as? MainProfile {
                if let user = sender as? UserData {
                    mainProfileVC.userData = user
                }
            }
        }
    }
    
  
    @objc func likeButtonTapped(sender : UIGestureRecognizer) {
      
        if let btn = sender.view as? UIImageView {
            
            let post =  Constants.selected_classification.lowercased().elementsEqual("alumni") ? self.alumni![btn.tag].value : self.student![btn.tag].value
            btn.isUserInteractionEnabled = false
            let ref = FirebaseStoreManager.db.collection("AllPosts")
            if btn.image == UIImage(named: "icons8-heart-64") {
            btn.image = UIImage(named: "icons8-heart-48")
                
                post.postLike?.append(cUid!)
               
            }
            else {
                btn.image = UIImage(named: "icons8-heart-64")
               let index =  post.postLike!.firstIndex { (postLike) -> Bool in
                if postLike == cUid {
                    return true
                }
                return false
              
               }
                post.postLike!.remove(at: index!)
            }
            
            ref.document(post.postId!).updateData(["postLike" : post.postLike!]) { (error) in
                btn.isUserInteractionEnabled = true
                if (error != nil) {
                    self.showError(error!.localizedDescription)
                }
            }
     
        
    }
        else {
           
        }
    }
  
    
   
    
 
    

    @objc func changeVisibility() {
        let alert = UIAlertController(title: "Select Post Visibility Option", message: "", preferredStyle: .alert)
    
        
        
        let action1 = UIAlertAction(title: "Friends", style: .default) { (action) in
            self.postVisibility = "friends"

        }
        
        let action2 = UIAlertAction(title: "All", style: .default) { (action) in
            
            self.postVisibility = "all"
        }
        
        let action4 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action4)
        
        self.present(alert,animated: true,completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
       
        hasImageChanged = true
        self.viewOfImageView.isHidden = false
        aspectConstraint = nil
        self.setUploadPostImage(image: image)
        self.dismiss(animated: true, completion: nil)
        }
    
    
   
    @objc func changeImages() {
        
        let alert = UIAlertController(title: "Upload Profile Picture", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Using Camera", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = .camera
            
            self.present(image,animated: true)
            
            
        }
        
        
        
        let action2 = UIAlertAction(title: "From Photo Library", style: .default) { (action) in
           
                let image = UIImagePickerController()
                image.delegate = self
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
                cropViewController.delegate = self
                cropViewController.customAspectRatio = CGSize(width: 1, height: 1)
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.aspectRatioPickerButtonHidden = true
                self.present(cropViewController, animated: true, completion: nil)
            }
    
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func uploadImageOnFirebase(postId : String, completion : @escaping (String) -> Void ) {
        
        if !hasImageChanged {
            completion("")
        }
        else {
            let storage = Storage.storage().reference().child("Posts").child(cUid!).child("\(postId).png")
        var downloadUrl = ""
        let uploadData = (self.beforePostImage.image?.jpegData(compressionQuality: 0.5))!
        
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
    
    func showOverlayView() {
        let slideVC = OverlayView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
   
    func setUploadPostImage(image : UIImage) {

      
        let constraint = NSLayoutConstraint(item: beforePostImage!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: beforePostImage!, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0.0)
         
         constraint.priority = UILayoutPriority.init(1000)

     
        aspectConstraint = constraint

        beforePostImage.image = image
     
        beforePostImage.layoutIfNeeded()
      
   
       
    }
    
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                beforePostImage.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                beforePostImage.addConstraint(aspectConstraint!)
            }
        }
    }
    
}




extension HomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
    



class MyTapPassViewGesture: UITapGestureRecognizer {
    var myview = UIView()
    var post  : Post?
}
class MyTapGesture: UITapGestureRecognizer {
    
    var index : Int = -1
    var id : String = ""
    
}

