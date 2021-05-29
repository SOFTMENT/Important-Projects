//
//  ToDoAddViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 11/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import TTGSnackbar

extension UITextField  {

enum PaddingSpace {
    case left(CGFloat)
    case right(CGFloat)
    case equalSpacing(CGFloat)
}

func addPadding(padding: PaddingSpace) {

    self.leftViewMode = .always
    self.layer.masksToBounds = true

    switch padding {

    case .left(let spacing):
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always

    case .right(let spacing):
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
        self.rightView = rightPaddingView
        self.rightViewMode = .always

    case .equalSpacing(let spacing):
        let equalPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
        // left
        self.leftView = equalPaddingView
        self.leftViewMode = .always
        // right
        self.rightView = equalPaddingView
        self.rightViewMode = .always
    }
}
    
}




class ToDoAddViewController: UIViewController ,UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var name: UITextField!
  
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textDetails: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btn: UIButton!
    var todoDelegate : ToDoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

         view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        let navigationItem = UINavigationItem(title: "Add Task")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationBar.setItems([navigationItem], animated: true)
        
        name.layer.borderColor = UIColor.lightGray.cgColor
        name.layer.borderWidth = CGFloat(1)
        name.layer.cornerRadius = CGFloat(6)
        
        textDetails.layer.borderColor = UIColor.lightGray.cgColor
        textDetails.layer.borderWidth = CGFloat(1)
        textDetails.layer.cornerRadius = CGFloat(6)
        
        name.addPadding(padding: .equalSpacing(10))
    
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = CGFloat(1)
        btn.layer.cornerRadius = CGFloat(6)
        
        datePicker.layer.borderColor = UIColor.lightGray.cgColor
               datePicker.layer.borderWidth = CGFloat(1)
               datePicker.layer.cornerRadius = CGFloat(6)
        
        textDetails.delegate = self
        name.delegate = self
        
        datePicker.minimumDate = Date()
       
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          view.endEditing(true)
          
          return false
      }
      
      @objc func dismissKeyboard() {
          view.endEditing(true)
      }
      
        
    
    
      func textFieldDidBeginEditing(_ textField: UITextField) {
             
             
             let distanceToBottom = self.scrollView.frame.size.height - (textField.frame.origin.y) - (textField.frame.size.height)
             let collapseSpace = 250 - distanceToBottom
             if collapseSpace < 0 {
                 // no collapse
                 return
             }
             scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
         }
         
         func textFieldDidEndEditing(_ textField: UITextField) {
             scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
         }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
         let distanceToBottom = self.scrollView.frame.size.height - (textView.frame.origin.y) - (textView.frame.size.height)
                    let collapseSpace = 250 - distanceToBottom
                    if collapseSpace < 0 {
                        // no collapse
                        return
                    }
                    scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         
         super.viewWillAppear(animated)
         
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
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addTapped(_ sender: Any) {
        
        guard let sName = name.text, !name.text!.isEmpty else {
            showToast(messages: "Task Name is Required.")
            return
        }
        
        guard let sDetails = textDetails.text , !textDetails.text.isEmpty else {
            showToast(messages: "Task Details is Required.")
            return
        }
        
        let completionDate = datePicker.date
        
        guard let realm  = LocalDatabase.realm else {
            showToast(messages: "Can not add item")
            return
            
        }
        
        
        let nextId = (realm.objects(Task.self).max(ofProperty: "id") as Int? ?? 0) + 1
        
        let newTask = Task()
        newTask.id = nextId
        newTask.name = sName
        newTask.details = sDetails
        newTask.completionDate = completionDate as NSDate
        
        self.todoDelegate?.addValue(todoitem: newTask)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func showToast(messages : String) {
        
        
        let snackbar = TTGSnackbar(message: messages, duration: .long)
        snackbar.messageLabel.textAlignment = .center
        snackbar.show()
    }
}
