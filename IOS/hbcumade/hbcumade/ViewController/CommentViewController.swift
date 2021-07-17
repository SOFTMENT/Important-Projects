//
//  CommentViewController.swift
//  hbcumade
//
//  Created by Vijay on 18/04/21.
//


import UIKit
import Firebase

class CommentViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var postBtn: UIImageView!
    @IBOutlet weak var myEditField: UITextView!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var reg : ListenerRegistration?
    var comments = Array<Comment>()
    var cUid  = ""
    var postId = "0"
    
    override func viewDidLoad() {
        
        cUid = Auth.auth().currentUser!.uid
        myEditField.delegate = self
        myEditField.sizeToFit()
        myEditField.isScrollEnabled = false
        myEditField.backgroundColor = UIColor.white
        self.myEditField.contentInset = UIEdgeInsets(top: 5 , left: 10, bottom: 5, right: 10);
    //self.myEditField.becomeFirstResponder()
        
        tableView.delegate = self
        tableView.dataSource = self
     
     
              
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tap.cancelsTouchesInView = true
              view.addGestureRecognizer(tap)
        
        
        //POSTBUTTON
        postBtn.isUserInteractionEnabled = true
        postBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewCommnet)))
        
        //POSTBUTTON
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnTapped)))
        
        getAllComment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    @objc func backBtnTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addNewCommnet() {
        
        let commentText  = myEditField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if commentText != "" {
            
            let ref =  FirebaseStoreManager.db.collection("AllPosts").document(postId).collection("Comments")
                    let id = ref.document().documentID
            let commentData = ["commentID" : id, "uid" : cUid, "name" : UserData.data?.name ?? "Default", "school" : UserData.data?.school ?? "HBCU MADE","classification" : UserData.data?.classification ?? "Student","commentAt" : FieldValue.serverTimestamp() , "commentLike" : 0 , "commentCount" : 0 , "image" : UserData.data?.profile ?? "", "commentText" : commentText] as [String : Any]
            
            
            self.myEditField.text = ""
            self.showToast(message: "Comment has been added")
           
            let comment = Comment(commentID: id, uid: cUid, name: UserData.data?.name ?? "Default", image: UserData.data?.profile ?? "", classification: UserData.data?.classification ?? "Student", commentText: commentText, commentAt: Date(), commentLike: Array<String>(), commentCount: 0, school: UserData.data?.school ?? "HBCU MADE")
            
           
            self.comments.append(comment)
            
          
        
            self.tableView.reloadData()
            if self.comments.count > 0 {
                self.scrollToBottom()
            }
            
                    ref.document(id).setData(commentData) { (err) in
                        if err != nil {
                            print(err!.localizedDescription)
                        }
                        else {
                            FirebaseStoreManager.db.collection("AllPosts").document(self.postId).getDocument { (snapshot, error) in
                                if error != nil {
                                    self.showError(error!.localizedDescription)
                                   
                                }
                                else {
                                    
                                    if let post = try? snapshot?.data(as: Post.self) {
                                        FirebaseStoreManager.db.collection("AllPosts").document(self.postId).updateData(["commentCount" : (post.commentCount! + 1)])
                                        
                                    }
                            }
                           
                        }
                    }
        }
    }
}
    
    func getAllComment() {
        
        reg =  FirebaseStoreManager.db.collection("AllPosts").document(postId).collection("Comments").order(by: "commentAt",descending: true).limit(toLast: 100).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
            if error != nil {
                self.showError(error!.localizedDescription)
            }
            else {
                
                if let snapshot = snapshot {
                    if !(snapshot.metadata.hasPendingWrites) {
                        let documents = snapshot.documents
                        self.comments.removeAll()
                    
                        
                        for snap in documents {
                           
                            do {
                                if let comment = try snap.data(as: Comment.self) {
                                    self.comments.append(comment)
                                }
                            }
                            catch let err{
                                print(err.localizedDescription)
                        
                            }
                        }
                        
                        
                        self.comments.reverse()
                        self.tableView.reloadData()
                        if self.comments.count > 0 {
                            self.scrollToBottom()
                        }
                    
                     
                        
                    }
                }
              
              
            }
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.comments.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    

    
      @objc func likeButtonTapped(sender : UIGestureRecognizer) {
        
          if let btn = sender.view as? UIImageView {
              
            
            let comment = comments[btn.tag]
            var commentLike = comment.commentLike ?? Array<String>()
            
                
                
                btn.isUserInteractionEnabled = false
              let ref = FirebaseStoreManager.db.collection("AllPosts").document(postId).collection("Comments")
                
              if btn.image == UIImage(named: "icons8-heart-64") {
                btn.image = UIImage(named: "icons8-heart-48")
                    
                  commentLike.append(cUid)
                   
                }
                else {
                    btn.image = UIImage(named: "icons8-heart-64")
                    let index =  commentLike.firstIndex { (postLike) -> Bool in
                    if postLike == cUid {
                        return true
                    }
                    return false
                  
                   }
                    if let index = index {
                        commentLike.remove(at: index)
                    }
                  
                }
                
            ref.document(comment.commentID!).setData(["commentLike" : commentLike], merge: true) { (error) in
                    btn.isUserInteractionEnabled = true
                    if (error != nil) {
                        self.showError(error!.localizedDescription)
                    }
                }
            }
            

          else {
             
          }
      }
    
      
     

    @objc func showKeyboard(){
        myEditField.becomeFirstResponder()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
     }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentPageTableCell {
            
            let comment = comments[indexPath.row]
            
            cell.prrofilePic.makeRounded()
            if comment.image != "" {
                cell.prrofilePic.sd_setImage(with: URL(string: comment.image!), placeholderImage: UIImage(named: "profile-user"))
            }
           
            cell.name.text = comment.name
            cell.commentText.text = comment.commentText!
            cell.commentCount.text = String.init(comment.commentCount!)
          
            if let commentLike = comment.commentLike {
                cell.likeCount.text = String.init(commentLike.count)
                
                if commentLike.contains(where: { (commentLike) -> Bool in
                    if commentLike == cUid {
                        return true
                    }
                    return false
                })
                {
                    cell.likeImage.image = UIImage(named: "icons8-heart-48")
                }
              
                else {
                    cell.likeImage.image = UIImage(named: "icons8-heart-64")
                }
            }
            else {
                cell.likeCount.text = "0"
            }
           
            
            if (comment.classification?.caseInsensitiveCompare("Alumni") == .orderedSame) {
                cell.classificationImage.image = UIImage(named: "icons8-graduation-cap-50")
            }
            else {
                cell.classificationImage.image = UIImage(named: "icons8-reading-50")
            }
            
            cell.universityName.text = comment.school
            cell.time.text = comment.commentAt?.timeAgoSinceDate()
            
            cell.likeImage.tag = indexPath.row
            cell.likeImage.isUserInteractionEnabled = true
            cell.likeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeButtonTapped(sender:))))
            
          
            cell.replyBtn.isUserInteractionEnabled = true
            cell.replyBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showKeyboard)))
            
            return cell
        }
        
        return CommentPageTableCell()
    }
}
