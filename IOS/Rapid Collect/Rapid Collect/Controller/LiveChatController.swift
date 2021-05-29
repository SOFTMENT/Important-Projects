//
//  LoginViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 17/03/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import Firebase
import Lottie
import SwiftyJSON


class LiveChatController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UITextFieldDelegate {

  
    @IBOutlet weak var viewCons: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var mytextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var messages  = [Messages]()
    var uids : String?
    var root : DatabaseReference?
    @IBOutlet weak var animation: UIView!
    var anim : AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
                  let btnBack = UIButton(type: UIButton.ButtonType.custom)
                   
                   btnBack.setImage(UIImage(named: "icons8-back-100"), for: .normal)
                   btnBack.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
                   btnBack.addTarget(self, action: #selector(backClicked), for: UIControl.Event.touchUpInside)
        
                   
                   let backBarItem = UIBarButtonItem(customView: btnBack)
                   navigationItem.leftBarButtonItems = [backBarItem];
                   navigationItem.title = "LIVE CHAT"
        
        anim = AnimationView(name: "load")
        mytextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        
   
        if Auth.auth().currentUser == nil {
            
          
        }
        else {
        uids = Auth.auth().currentUser?.uid
        root = Database.database().reference().child("Livechat").child(uids!)
    
       loadData()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
              
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
              
              let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
              
              view.addGestureRecognizer(tap)
              
              DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                  
                  self.moveToBottom()
              }
        
                    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       view.endEditing(true)
        
        return false
    }
    
    func moveToBottom() {
           
           if messages.count > 0  {
               
               let indexPath = IndexPath(row: messages.count - 1, section: 0)
               
               tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
           }
       }
       
    @objc func keyboardWillShow(notify: NSNotification) {
         
        if let keyboardSize = (notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
             let h = tabBarController?.tabBar.frame.height
    
            viewCons.constant  = -keyboardSize.height + h!
            UIView.animate(withDuration: 0.5) {
               self.view.layoutIfNeeded()
            }
             
            
         }
     }
     
     @objc func keyboardWillHide(notify: NSNotification) {
         
       
        
            viewCons.constant  = 0
         UIView.animate(withDuration: 0.5) {
                      self.view.layoutIfNeeded()
        }
        
             moveToBottom()
                   
     }
     
    @objc func dismissKeyboard() {
         
         view.endEditing(true)
     }
    
    func loadData() {
        
        if anim!.isAnimationPlaying {
                   anim?.stop()
               }
               
                
                 anim!.frame = self.animation.bounds
                 self.animation.addSubview(anim!)
                 anim!.play()
                 anim!.loopMode = .loop
        
        root?.observe(.value, with: { (snapshot) in
           
                self.messages.removeAll()
                
            for data in snapshot.children {
                    
                    let data = data as! DataSnapshot
                
    
               
                for da in data.children {
                        
                 let s = da as! DataSnapshot
                let value = s.value as! [String : String]
                let message = value["message"]
                let sender = value["sender"]
                let messageObj = Messages(message: message!, sender: sender!)
                self.messages.append(messageObj)
                 
                    
                    
                    }
                    
                
               
            }

            self.anim?.stop()
            self.animation.isHidden = true
            
             self.tableView.reloadData()
            self.moveToBottom()
           
        })
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message  = messages[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messagecell", for: indexPath) as? MessagesCell {
            
            cell.config(message: message, uid: uids!)
            
            return cell
            
        }
        
        
        
        return MessagesCell()
        
    }
            
    
    @IBAction func backBtnTapped(_ sender: Any) {
        
        tabBarController?.selectedIndex = 0
        
    }
    
                
        
        @objc func backClicked() {
          
    }
            
    
       override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        if Auth.auth().currentUser == nil {
            let resendAlert = UIAlertController(title: "Rapid Collect", message: "Sign In is Required to Use Live Chat", preferredStyle: .alert)
            
            let  resendAction1 = UIAlertAction(title: "Sign In", style: .default) { (alert) in
                let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signin")
                UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)
                
            }
            
            let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.tabBarController?.selectedIndex = 0
            }
            resendAlert.addAction(resendAction1)
            resendAlert.addAction(cancelAlert)
            
            self.present(resendAlert,animated: true,completion: nil)
        }
        
        
        var  color = UIColor.init(red: 237/255, green: 27/255, blue: 37/255, alpha: 1)
       
        let preferences = UserDefaults.standard

        let colorKey = "colorKey"

        if preferences.object(forKey: colorKey) == nil {
        
        } else {
            
            let currentLevel = preferences.string(forKey: colorKey)
            
            switch currentLevel {
            case "black":
                color = UIColor.init(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
                break;
                
            case "green" :
                color = UIColor.init(red: 22/255, green: 74/255, blue: 42/255, alpha: 1)
                
                break
                
            case "red" :
                color = UIColor.init(red: 237/255, green: 27/255, blue: 37/255, alpha: 1)
                
                break
            case "blue" :
                color = UIColor.init(red: 34/255, green: 48/255, blue: 81/255, alpha: 1)
            
                break
                
            default:
                print("")
            }
        }
        
        if #available(iOS 13.0, *) {
         
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let statusBarHeight: CGFloat = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = color
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = color
        }
        
        navigationBar.barTintColor = color
    }
    
 
    
    @IBAction func sendMessage(_ sender: Any) {
        if !mytextField.text!.isEmpty {
                
                let post: Dictionary<String, AnyObject> = [
                    "message": mytextField.text as AnyObject,
                    "sender": uids as AnyObject
                ]
                
            let messageId = root?.childByAutoId().key
               
            let firebaseMessage = root?.child("admin").child(messageId!)
                
            firebaseMessage!.setValue(post)
            
              
            mytextField.text = ""
          
        }
            
            
        
    }
    
    

}
