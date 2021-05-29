//
//  AdminAddQuotes.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 22/05/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class AdminAddQuotes: UIViewController {
    
    
    @IBOutlet weak var close: UIImageView!
    @IBOutlet weak var addInsightBtn: UIButton!
    @IBOutlet weak var quotes: UITextView!
    @IBOutlet weak var selectDate: UITextField!
    
    let datePicker = UIDatePicker()
    
    let placeholderText = "Enter Quote"
    override func viewDidLoad() {
        
        addInsightBtn.layer.cornerRadius = 8
        quotes.layer.cornerRadius = 8
        selectDate.layer.cornerRadius = 8
        
        
        quotes.textColor = UIColor.lightGray
        quotes.text = placeholderText
        quotes.delegate = self
        
        createDatePicker1()
        
        //Close
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeBtnTapped)))
        
    }
    
    
    @objc func closeBtnTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    func createDatePicker1() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
      
        
      
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnTapped))
        toolbar.setItems([done], animated: true)
      
        selectDate.inputAccessoryView = toolbar
        

        datePicker.datePickerMode = .date
        selectDate.inputView = datePicker
        
    }
    
    @objc func doneBtnTapped() {
        view.endEditing(true)
        let date = datePicker.date
        selectDate.text = convertDateFormater(date)
    }
    
    @IBAction func addInsightsBtnClicked(_ sender: Any) {
        let sQuotes = quotes.text
        let sDate = selectDate.text
        
        if sQuotes == "" {
            showToast(message: "Enter Quote")
        }
        else {
            if sDate == "" {
                showToast(message: "Select Date")
            }
            else {
                
                let id = Firestore.firestore().collection("DailyInsights").document().documentID
                self.ProgressHUDShow(text: "Adding...")
                Firestore.firestore().collection("DailyInsights").document(id).setData(["quotes" : sQuotes!,"date" : datePicker.date,"id" : id]) { error in
                    self.ProgressHUDHide()
                    if error == nil {
                        self.showToast(message: "Insight Added")
                        self.selectDate.text = ""
                        self.quotes.text = ""
                    }
                    else {
                        
                    }
                }
                
            }
        }
        
       
    }
}

extension AdminAddQuotes:  UITextFieldDelegate, UITextViewDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true;
    }
  
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == placeholderText {
            textView.textColor = UIColor.darkGray
            textView.text = ""
        }
        return true
    }
    


    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            textView.text = placeholderText
        }
    }
    
}
