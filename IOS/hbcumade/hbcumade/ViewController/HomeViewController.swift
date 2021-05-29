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

class HomeViewController: BaseViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate{
 
    
    
    
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
    @IBOutlet weak var viewOfImageView: UIView!
    var refReg : ListenerRegistration?
    var refComment : Array<ListenerRegistration> = []
    
    var cUid : String?
    var friends = Array<FriendList>()
    var postIDs = Array<PostID>()
    var postids = Array<String>()
    var posts = Array<Post>()
    var posts_filter = Array<Post>()
    
    var tempHeight : CGFloat = 0
    var hasImageChanged : Bool = false
    var postVisibility : String = "all"
    override func viewDidLoad() {
   
        cUid = Auth.auth().currentUser?.uid


        halfTextView.delegate = self
        
        postEditField.delegate = self
        postEditField.textColor = UIColor.lightGray
    
        
        postBtn.layer.cornerRadius = 6
        removeImageBtn.layer.cornerRadius = 6
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
   
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
       
        
        
        ProgressHUDShow(text: "Loading…")
        getMyPostsID()
        getFriendData()
        updateUI()
        
        
       
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
       
        uploadImageOnFirebase { (downloadURL) in
                
            let data = ["postId" : docID, "uid" : self.cUid!, "name" : UserData.data?.name ?? "Default", "classification" : UserData.data?.classification ?? "Student","image" : UserData.data?.profile ?? "", "postText" : postText, "postImage" : downloadURL,
                        "postLike" : [] ,"postVisibility" : self.postVisibility , "postAt" : time ,"commentCount" : 0, "school": UserData.data?.school ?? ""] as [String : Any]
        
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
                
                let mydata = [ "postAt" : time,"postId" : docID ] as [String : Any]
                if self.friends.count < 499 {
                    let batch = FirebaseStoreManager.db.batch()
                    
                    let nycRef = FirebaseStoreManager.db.collection("UserPosts").document("Posts").collection(self.cUid!).document(docID)
                    batch.setData(mydata, forDocument: nycRef)
                    for friend in self.friends {
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
          
        }
        
    }
    
    
    func getFriendData() {
        FirebaseStoreManager.db.collection("Friends").document("narwJgQR0aUL134pm1tF").collection("MyFriends").addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("Error Retriving Friends")
            }
            else {
                self.friends.removeAll()
                guard let documents = snapshot?.documents else {
                           print("Error fetching documents: \(error!)")
                           return
                       }
                self.friends = documents.map { (snapshot) -> FriendList in
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
        FirebaseStoreManager.db.collection("UserPosts").document("Posts").collection(cUid!).order(by: "postAt").limit(toLast: 10).addSnapshotListener { (snapshot, error) in
           
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
                 
                    if !snapshot.metadata.hasPendingWrites {
                        if self.postids.count > 0 {
                            if let reg = self.refReg{
                                reg.remove()
                            }
                            self.getPosts()
                        }
                    }
                        
                      
                }
                else {
                    self.ProgressHUDHide()
                }
               
              
                
            }
        }
    }
    
    func getPosts()  {
       
      refReg =  FirebaseStoreManager.db.collection("AllPosts").whereField("postId", in: self.postids).order(by: "postAt", descending: true).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
        
        if error != nil {
            
            self.ProgressHUDHide()
                self.showError(error!.localizedDescription)
        }
            else {
                if let snapshot = snapshot {
                    if !(snapshot.metadata.hasPendingWrites) {
                        
                        self.ProgressHUDHide()
                        
                        let documents = snapshot.documents
                        self.posts.removeAll()
                        
                        self.posts = documents.map({ (snapshot) -> Post in
                            let post = try? snapshot.data(as: Post.self)
                            return post!
                            
                        })
                        
                        self.filterPosts()
                           
                        
                    }
                }
                else {
                    self.ProgressHUDHide()
                    print("Error fetching documents: \(error!)")
                    
                }
                

            }
                
            }
        
    }
    
    
    func filterPosts() {
        
        self.posts_filter.removeAll()
        
        self.posts_filter =  posts.filter { post in
            if post.classification!.lowercased().elementsEqual(Constants.selected_classification) {
                
                return true
            }
        
            return false
        }
        
        print(self.posts_filter.count)
        
        
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        self.tableViewHeight.constant = self.tableView.contentSize.height
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
       
        return posts_filter.count
    }
    
  
    


    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "homeviewcell", for: indexPath) as? HomePageTableCell {
           
            
            let post = posts_filter[indexPath.row]
            
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
                cell.postImage.isHidden = false
               
                
                cell.postImage.sd_setImage(with: URL(string: post.postImage!), placeholderImage: UIImage(named: "placeholder"))
               
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
            
           
      
            return cell
            
        }
        
        return HomePageTableCell()
        
    }
    
    
    
    @objc func gotoCommentPage(gesture : UIGestureRecognizer) {
 
        self.performSegue(withIdentifier: "commentseg", sender: self.posts[(gesture.view?.tag)!].postId!)
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
                    print(postId)
                    destination.postId = postId
                }
            }
        }
    }
    
  
    @objc func likeButtonTapped(sender : UIGestureRecognizer) {
      
        if let btn = sender.view as? UIImageView {
            let post = posts[btn.tag]
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
        let action1 = UIAlertAction(title: "Only Me", style: .default) { (action) in
            
            self.postVisibility = "onlyme"
        }
        
        
        
        let action2 = UIAlertAction(title: "Only My Friends", style: .default) { (action) in
            self.postVisibility = "friends"

        }
        
        let action3 = UIAlertAction(title: "All", style: .default) { (action) in
            
            self.postVisibility = "all"
        }
        
        let action4 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        
        self.present(alert,animated: true,completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
       
        hasImageChanged = true
        self.viewOfImageView.isHidden = false
        beforePostImage.image = image
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
               
                self.present(cropViewController, animated: true, completion: nil)
            }
    
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func uploadImageOnFirebase( completion : @escaping (String) -> Void ) {
        
        if !hasImageChanged {
            completion("")
        }
        else {
            let storage = Storage.storage().reference().child("Posts").child(cUid!).child("\(UUID().uuidString).png")
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
    
   
    
}



extension HomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
    



