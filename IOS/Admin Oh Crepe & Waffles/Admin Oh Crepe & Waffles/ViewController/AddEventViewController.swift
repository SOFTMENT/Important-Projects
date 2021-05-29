//
//  AddEventViewController.swift
//  Admin Oh Crepe & Waffles
//
//  Created by Vijay on 08/05/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import MBProgressHUD

class AddEventViewController: UIViewController {
    
    
    @IBOutlet weak var eventDate: UITextField!
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventAddress: UITextField!
    let datePicker = UIDatePicker()
    
    var sDate = ""
    var sTime = ""
    
    override func viewDidLoad() {
        
        eventDate.setLeftPaddingPoints(10)
        eventDate.setRightPaddingPoints(10)
        
        eventTitle.setRightPaddingPoints(10)
        eventTitle.setLeftPaddingPoints(10)
        
 
        eventAddress.setRightPaddingPoints(10)
        eventAddress.setLeftPaddingPoints(10)
         
        eventAddress.delegate = self
        eventTitle.delegate = self
        eventDate.delegate = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard)))
        createDatePicker()
        
    }
    
    @objc func hideKeyBoard() {
        view.endEditing(true)
    }
    
   
    func createDatePicker() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
      
        
      
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnTapped))
        toolbar.setItems([done], animated: true)
      
        eventDate.inputAccessoryView = toolbar
        

        datePicker.datePickerMode = .dateAndTime
        eventDate.inputView = datePicker
        
        
    }
    
    @objc func doneBtnTapped() {
        view.endEditing(true)
        let date = datePicker.date
        eventDate.text = convertDateAndTimeFormater(date)
        
        sDate = convertDateFormater(date)
        sTime = convertTimeFormater(date)
        
        
    }
    
    @IBAction func addEventBtnTapped(_ sender: Any) {
        
        let title = eventTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let address = eventAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let dateandtime = eventDate.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    
        
              
        if title != "" && address != "" && dateandtime != "" {
                ProgressHUDShow(text: "Wait...")
                view.endEditing(true)
            
            Firestore.firestore().collection("Events").limit(toLast: 1).order(by: "id").getDocuments(completion: { snapshot, error in
                if let snapshot = snapshot  {
                    if !snapshot.isEmpty {
                       
                    
                   
                    if let cat = try? snapshot.documents.last!.data(as: EventModel.self) {
                        self.addDetailsOnFirebase(eventId: (cat.id + 1), address: address!, title: title!)
                    }
                }
                    else {
                        self.addDetailsOnFirebase(eventId: 1, address: address!, title: title!)
                    }
               
                }
                else {
                    self.addDetailsOnFirebase(eventId: 1, address: address!, title: title!)
                }
                
            })
                
            
            }
            else {
                showToast(message: "All fields is manadatory")
            }
        }
       
        
    public func addDetailsOnFirebase(eventId : Int, address : String, title : String){
        
        Firestore.firestore().collection("Events").document(String(eventId)).setData(["id": eventId,"title": title, "address" : address,"date" : sDate, "time" : sTime,"rdate": Date()], completion: { error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                self.showToast(message: "Event Added")
            
                self.eventTitle.text = ""
            
                self.eventDate.text = ""
                self.eventAddress.text = ""
            }
            else {
                self.showError(error!.localizedDescription)
            }
    
        })
    }
    
}


extension AddEventViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
