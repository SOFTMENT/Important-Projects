//
//  StartTimeAndEndTimeOverlay.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 22/05/21.
//

import UIKit

class StartTimeAndEndTimeOverlay: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var slide: UIView!
    
    @IBOutlet weak var startTime: UITextField!
    
    @IBOutlet weak var endTime: UITextField!
    

    @IBOutlet weak var saveBtn: UIButton!
    
    let datePicker = UIDatePicker()
    let datePicker2 = UIDatePicker()
    let standard = UserDefaults.standard
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var settingVC : SettingsViewController?
    
    public func initializeSettingVC(settingVC : SettingsViewController){
        self.settingVC = settingVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard)))
        createDatePicker1()
        createDatePicker2()
        
        startTime.delegate = self
        endTime.delegate = self
        
        startTime.layer.cornerRadius = 12
        endTime.layer.cornerRadius = 12
        
        slide.layer.cornerRadius = 6
        
        if let sStartTime = standard.object(forKey: "starttime") as? Date {
            startTime.text = convertTimeFormater(sStartTime)
        }
        if let sEndTime = standard.object(forKey: "endtime") as? Date {
            endTime.text = convertTimeFormater(sEndTime)
        }
        
        saveBtn.layer.cornerRadius = 12
    
    }
    
    @objc func hideKeyBoard() {
        view.endEditing(true)
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
      
        startTime.inputAccessoryView = toolbar
        

        datePicker.datePickerMode = .time
        startTime.inputView = datePicker
        
        
        
        
    }
    
    @objc func doneBtnTapped() {
        view.endEditing(true)
        let date = datePicker.date
        startTime.text = convertTimeFormater(date)
      
        
      
   
        
    
        
    }

    
    func createDatePicker2() {
        if #available(iOS 13.4, *) {
            datePicker2.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
      
        
      
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnTapped1))
        toolbar.setItems([done], animated: true)
      
        endTime.inputAccessoryView = toolbar
        

        datePicker2.datePickerMode = .time
        endTime.inputView = datePicker2
        
        
    }
    
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        
        showToast(message: "Saved")
        let startD = datePicker.date
        
        let hour = Calendar.current.component(.hour, from: startD)
        let min = Calendar.current.component(.minute, from: startD)
            
     
        
        
         let endD = datePicker2.date
        
          let hour1 = Calendar.current.component(.hour, from: endD)
          let min1 = Calendar.current.component(.minute, from:endD)
        
       
        standard.set(startD, forKey: "starttime")
        standard.set(endD, forKey: "endtime")
        
        standard.synchronize()
        
        
        
        if let alertvalue = standard.string(forKey: "alertvalue") {
            if alertvalue == "1x" {
                settingVC?.scheduleNotification(hours: hour, minutes: min, shouldClear: true)
            }
            else if alertvalue == "2x" {
                settingVC?.scheduleNotification(hours: hour, minutes: min, shouldClear: true)
                settingVC?.scheduleNotification(hours: hour1, minutes: min1, shouldClear: false)
            }
            else if alertvalue == "3x" {
                settingVC?.scheduleNotification(hours: hour, minutes: min, shouldClear: true)
                settingVC?.scheduleNotification(hours: hour1, minutes: min1, shouldClear: false)
                
                let hours2 = (hour1 + hour) / 2
                let min2  = (min1 + min) / 2
                
                settingVC?.scheduleNotification(hours: hours2, minutes: min2, shouldClear: false)
                
            }
        }
        else {
            settingVC?.scheduleNotification(hours: hour, minutes: min, shouldClear: true)
            settingVC?.scheduleNotification(hours: hour1, minutes: min1, shouldClear: false)
        }
        
    }
    
    @objc func doneBtnTapped1() {
        view.endEditing(true)
        let date = datePicker2.date
        
        endTime.text = convertTimeFormater(date)
       
        
    }
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
         view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
    
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        view.endEditing(true)
        return true
    }
}
