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
            let comment = Comment(commentID: id, uid: cUid, name: UserData.data?.name ?? "Default", image: UserData.data?.profile ?? "", classification: UserData.data?.classification ?? "Student", commentText: commentText, commentAt: Date(), commentLike: 0, commentCount: 0, school: UserData.data?.school ?? "HBCU MADE")
            
           
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
                        
                        self.comments = documents.map({ (snapshot) -> Comment in
                        let comment = try? snapshot.data(as: Comment.self)
                        return comment!
                            
                        })
                        
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
            cell.likeCount.text = String.init(comment.commentLike!)
            
            if (comment.classification?.caseInsensitiveCompare("Alumni") == .orderedSame) {
                cell.classificationImage.image = UIImage(named: "icons8-graduation-cap-50")
            }
            else {
                cell.classificationImage.image = UIImage(named: "icons8-reading-50")
            }
            
            cell.universityName.text = comment.school
            cell.time.text = comment.commentAt?.timeAgoSinceDate()
       
            
            return cell
        }
        
        return CommentPageTableCell()
    }
}
