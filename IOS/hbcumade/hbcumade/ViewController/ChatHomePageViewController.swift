//
//  ChatHomePageViewController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 30/05/21.
//

import FirebaseFirestoreSwift
import Firebase
import UIKit

class ChatHomePageViewController: BaseViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var submitSearchBtn: UIView!
    @IBOutlet weak var noMessageAvailable: UILabel!
    @IBOutlet weak var searchBtn: UIView!
    @IBOutlet weak var searchEditText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var lastMessages = Array<LastMessage>()
    var lastMessagesFilter = Array<LastMessage>()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        searchEditText.attributedPlaceholder = NSAttributedString(string: "Search...",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        searchEditText.setLeftPaddingPoints(10)
        searchEditText.setRightPaddingPoints(10)
        searchEditText.delegate = self
        searchEditText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        submitSearchBtn.isUserInteractionEnabled = true
        submitSearchBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardHide)))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardHide)))
        
        //getAllLastMessages
        getAllLastMessages()
       
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        filter(value: textField.text!)
    }
    
    public func filter(value : String){
        lastMessagesFilter.removeAll()
        lastMessagesFilter =  lastMessages.filter { lastMessages in
            if value == "" ||  lastMessages.name!.lowercased().contains(value.lowercased())  {
                return true
            }
            else {
                return false
            }
        }
      
        tableView.reloadData()
        tableView.layoutIfNeeded()
        
    }
    
    @objc func keyboardHide(){
        view.endEditing(true)
    }
    
    public func getAllLastMessages() {
        
        guard let userData = UserData.data else {
            self.logout()
            return
        }
        
        ProgressHUDShow(text: "Loading...")
        
        Firestore.firestore().collection("Chats").document(userData.uid!).collection("LastMessage").order(by: "time",descending: true).addSnapshotListener { snapshot, error in
            self.ProgressHUDHide()
            if error == nil {
                self.lastMessages.removeAll()
                if let snapshot = snapshot {
                    for  qds in snapshot.documents {
                        if let lastMessage = try? qds.data(as: LastMessage.self) {
                            self.lastMessages.append(lastMessage)
                        }
                    
                    }
                }
                
                self.filter(value: "")
            }
            
        }
    }
    
    @objc func lastMessageClicked(value : MyTapGesture){
        performSegue(withIdentifier: "chatscreenseg", sender: value.index)
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatscreenseg" {
            if let destinationVC = segue.destination as? ChatScreenViewController {
                if let index = sender as? Int  {
                    let lastMessage = lastMessages[index]
                    destinationVC.friendName = lastMessage.name
                    destinationVC.friendImage = lastMessage.image
                    destinationVC.friendUid  = lastMessage.uid
                    destinationVC.friendToken = lastMessage.token
                }
               
            }
           
        }
        else if segue.identifier == "topbarseg" {
            if let topbar = segue.destination as? TopBarViewController {
                    topbar.classificationDelegate = self
            
            }
            
        }
       
    }
    
}

extension ChatHomePageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lastMessagesFilter.count > 0 {
            self.noMessageAvailable.isHidden = true
        }
        else {
            self.noMessageAvailable.isHidden = false
        }
        return lastMessagesFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "homechat", for: indexPath) as? HomeChatTableCell {
            let lastMessage = lastMessagesFilter[indexPath.row]
            
            cell.mImage.makeRounded()
            cell.mImage.layer.borderWidth = 1
            cell.mImage.layer.borderColor = UIColor.darkGray.cgColor
        
            if (lastMessage.isRead ?? false) {
                cell.mView.layer.borderWidth = 0
                cell.mView.layer.borderColor = UIColor.clear.cgColor
            }
            else {
                cell.mView.layer.borderWidth = 1
                cell.mView.layer.borderColor = UIColor.init(red: 189/255, green: 25/255, blue: 30/255, alpha: 1).cgColor
            }
          
            
          
            if let image = lastMessage.image{
                if image != "" {
                    cell.mImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profile-placeholder"), options: .continueInBackground, completed: nil)
                }
                else {
                    cell.mImage.image = UIImage(named: "profile-placeholder")
                }
            }
            else {
                cell.mImage.image = UIImage(named: "profile-placeholder")
            }
            
            cell.mTitle.text = lastMessage.name
            cell.mLastMessage.text = lastMessage.message
            if let time = lastMessage.time {
                cell.mTime.text = time.timeAgoSinceDate()
            }
            
            
            cell.mView.isUserInteractionEnabled = true
            let tappy = MyTapGesture(target: self, action: #selector(lastMessageClicked(value:)))
            tappy.index = indexPath.row
            cell.mView.addGestureRecognizer(tappy)
           
            return cell
        }
        
        return HomeChatTableCell()
    }
    
    
}
