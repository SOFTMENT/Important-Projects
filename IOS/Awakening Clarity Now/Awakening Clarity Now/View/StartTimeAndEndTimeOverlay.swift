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
    
    var isStartDatePickerChanged = false
    var isEndDatePickerChangeed = false
    
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
        else {
            let calendar = Calendar.current
            let now = Date()
            let eight_today = calendar.date(
              bySettingHour: 8,
              minute: 0,
              second: 0,
              of: now)!
            standard.set(eight_today, forKey: "starttime")
            standard.synchronize()
            startTime.text = convertTimeFormater(eight_today)
        }
        if let sEndTime = standard.object(forKey: "endtime") as? Date {
            endTime.text = convertTimeFormater(sEndTime)
        }
        else {
            let calendar = Calendar.current
            let now = Date()
            let eight_evening = calendar.date(
              bySettingHour: 20,
              minute: 0,
              second: 0,
              of: now)!
            standard.set(eight_evening, forKey: "endtime")
            standard.synchronize()
            endTime.text = convertTimeFormater(eight_evening)
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
        self.isStartDatePickerChanged = true
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
        var count = standard.integer(forKey: "alertvalue")
        if count <= 0 {
            count = 1
        }
        settingVC?.clearAllNotifications()
        
        if isStartDatePickerChanged {
            standard.set(datePicker.date, forKey: "starttime")
            standard.synchronize()
            isStartDatePickerChanged = false
            
            
        }
        
        if isEndDatePickerChangeed {

            standard.set(datePicker2.date, forKey: "endtime")
            standard.synchronize()
            isEndDatePickerChangeed = false
            
        }
        
        
        
        if let sStartTime = standard.object(forKey: "starttime") as? Date {
            let sEndTime = standard.object(forKey: "endtime") as? Date
      
            let diffSeconds = sEndTime!.seconds(from: sStartTime )
            let dividedSec = diffSeconds / (count + 1)
            var newDate = sStartTime
           
            for i in 1...count {
                newDate = newDate.addingTimeInterval(TimeInterval(dividedSec))
                let hour = Calendar.current.component(.hour, from: newDate)
                let min = Calendar.current.component(.minute, from: newDate)
                
                if let status = standard.string(forKey: "claritystatus") {
                    if status == "yes" {
                        
                    
                    var value = i - 1
                    print(value)
                        if value >= settingVC?.clarityData.count ?? 0 {
                       value = 0
                    }
                        let message = (self.settingVC?.clarityData[value].clarity)!
                    self.settingVC?.scheduleNotification(hours: hour, minutes: min,message: message)
                    }
                    else {
                        self.settingVC?.scheduleNotification(hours: hour, minutes: min,message: "Check Daily Insight")
                    }
                }
                else {
                    self.settingVC?.scheduleNotification(hours: hour, minutes: min,message: "Check Daily Insight")
                }
            }
        }
    }
    
    @objc func doneBtnTapped1() {
        view.endEditing(true)
        let date = datePicker2.date
        self.isEndDatePickerChangeed = true
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
