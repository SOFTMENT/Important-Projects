//
//  ChatViewController.swift
//  Oh Crepe & Waffles
//
//  Created by Vijay on 15/05/21.
//

import AMTabView
import Firebase
import FirebaseFirestoreSwift
import UIKit
import MBProgressHUD

class ChatViewController: UIViewController, TabItem, UITextViewDelegate {
    
    var tabImage: UIImage? {
        return UIImage(named: "comment")
    }
    
    
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var viewCons: NSLayoutConstraint!
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var messages = Array<MessageModel>()

    override func viewDidLoad() {
        
        tableView.estimatedRowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        
        messageField.delegate = self
        messageField.sizeToFit()
        messageField.isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
              
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
              
              let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tap.cancelsTouchesInView = true
              view.addGestureRecognizer(tap)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            
            self.moveToBottom()
        }
        
        sendMessageBtn.isUserInteractionEnabled = true
        sendMessageBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendMessageBtnTapped)))
        
        //GETMESSAGES
        getAllChats()
    }
    
    @objc func sendMessageBtnTapped(){
      
    
            
            let message = messageField.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if message != "" {
                sendMessage(name: User.data!.name!, message: message)
            
            
        }
        
        
    }
    
    func sendMessage(name : String, message : String) {
        
        let id = Firestore.firestore().collection("Chats").document().documentID
        Firestore.firestore().collection("Chats").document(id).setData(["name": name,"message":message,"mId":id,"date" : FieldValue.serverTimestamp()]) {
 error in
            if error == nil {
                self.messageField.text = ""
            
            }
            else {
                self.showError(error!.localizedDescription)
            }
            
        }
    }
    
    func getAllChats(){
        
       
        ProgressHUDShow(text: "Loading...")
        Firestore.firestore().collection("Chats").order(by: "date").addSnapshotListener { snapshot, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                self.messages.removeAll()
                if let snapshot = snapshot {
                    for documentsnap in snapshot.documents {
                        if let message = try? documentsnap.data(as: MessageModel.self) {
                            self.messages.append(message)
                        }
                    }
                }
                self.tableView.reloadData()
                self.moveToBottom()
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
    }
    
    @objc func dismissKeyboard() {
         
        view.endEditing(true)
     }
    
    @objc func keyboardWillShow(notify: NSNotification) {
         
        if let keyboardSize = (notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
           
            viewCons.constant  = keyboardSize.height
            UIView.animate(withDuration: 0.5) {
               self.view.layoutIfNeeded()
            }
             
            
         }
     }
     
     @objc func keyboardWillHide(notify: NSNotification) {
         
       
        
            viewCons.constant  = 60
         UIView.animate(withDuration: 0.5) {
                      self.view.layoutIfNeeded()
        }
        
             moveToBottom()
                   
     }
    
    
    func moveToBottom() {
           
           if messages.count > 0  {
               
               let indexPath = IndexPath(row: messages.count - 1, section: 0)
               
               tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
           }
       }
    
 
}




extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messagecell", for: indexPath) as? MessagesCell {
        
            cell.view.layer.cornerRadius = 8
            cell.view.dropShadow()
            let message = messages[indexPath.row]
            cell.name.text = message.name
            cell.message.text = message.message
            cell.date.text = self.convertDateFormater(message.date)
            
            return cell
        }
        
        return MessagesCell()
    }
    
    
    
}
