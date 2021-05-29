//
//  SettingsViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 21/05/21.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
  
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
       return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Helvetica", size: 30)
            pickerLabel?.textAlignment = .center
        }
        
      
        pickerLabel?.text = pickerData[row]
        pickerLabel?.textColor = UIColor.white
       
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    var pickerData: [String] = [String]()
    @IBOutlet weak var mycircleview: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
   
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var closeBtn: UIImageView!
    
    @IBOutlet weak var dailyClarityInsightsBtn: UIView!
    
    @IBOutlet weak var startAndEndTimeBtn: UIView!
    let standard = UserDefaults.standard
    
    let slideVC = OverlayView()
    let startAndEndSlideVC = StartTimeAndEndTimeOverlay()
    override func viewDidLoad() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerData = ["1X", "2X", "3X"]
        
        //SAVEBTN
        saveBtn.layer.cornerRadius = 12
        
        //CloseBtn
        closeBtn.isUserInteractionEnabled = true
        closeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeBtnClicked)))
        
        //DailyClarityInsights
        dailyClarityInsightsBtn.isUserInteractionEnabled = true
        dailyClarityInsightsBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dailyClarityInsightsClicked)))
        
        //StartAndEndTime
        startAndEndTimeBtn.isUserInteractionEnabled = true
        startAndEndTimeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startAndEndTimeClicked)))
        
        if let alertvalue = standard.string(forKey: "alertvalue") {
            if alertvalue == "1x" {
                pickerView.selectRow(0, inComponent: 0, animated: false)
            }
            else if alertvalue == "2x" {
                pickerView.selectRow(1, inComponent: 0, animated: false)
            }
            else if alertvalue == "3x" {
                pickerView.selectRow(2, inComponent: 0, animated: false)
            }
        }
        else {
            pickerView.selectRow(1, inComponent: 0, animated: false)
        }
        
        
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
               // self.scheduleNotification()
            } else {
               
            }
        }
        
       
       
        
    }
    
    func scheduleNotification(hours : Int, minutes : Int, shouldClear : Bool) {
        
        print("WOW YOU CLICKED ME")
        
        let center = UNUserNotificationCenter.current()
        
        if shouldClear {
            center.removeAllPendingNotificationRequests()
        }

        let content = UNMutableNotificationContent()
        content.title = "Awakening Clarity Now"
        content.body = "Check Daily Insight"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = hours
        dateComponents.minute = minutes
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        
       
        
    }
    
 
  

  
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        mycircleview.layer.cornerRadius = mycircleview.frame.size.width/2
        mycircleview.layer.borderWidth = 1
        mycircleview.layer.borderColor = UIColor.white.cgColor
   
        
    }


    @IBAction func saveBtnClicked(_ sender: Any) {
        let selectedrow = pickerView.selectedRow(inComponent: 0)
        if selectedrow == 0 {
            standard.set("1x", forKey: "alertvalue")
            standard.synchronize()
            
            
            if let sStartTime = standard.object(forKey: "starttime") as? Date {
                
                let hour = Calendar.current.component(.hour, from: sStartTime)
                let min = Calendar.current.component(.minute, from: sStartTime)
                
                scheduleNotification(hours: hour, minutes: min, shouldClear: true)
            }
            else {
                let hour = Calendar.current.component(.hour, from: Date())
                let min = Calendar.current.component(.minute, from: Date())
                
                scheduleNotification(hours: hour, minutes: min, shouldClear: true)
            }
            
            
        }
        else if selectedrow == 1 {
            standard.set("2x", forKey: "alertvalue")
            standard.synchronize()
            
            if let sStartTime = standard.object(forKey: "starttime") as? Date {
                
                let hour = Calendar.current.component(.hour, from: sStartTime)
                let min = Calendar.current.component(.minute, from: sStartTime)
                
                scheduleNotification(hours: hour, minutes: min, shouldClear: true)
            }
            else {
                let hour = Calendar.current.component(.hour, from: Date())
                let min = Calendar.current.component(.minute, from: Date())
                
                scheduleNotification(hours: hour, minutes: min, shouldClear: true)
            }
            
            if let sEndTime = standard.object(forKey: "endtime") as? Date {
                
                let hour = Calendar.current.component(.hour, from: sEndTime)
                let min = Calendar.current.component(.minute, from: sEndTime)
                
                scheduleNotification(hours: hour, minutes: min, shouldClear: false)
            }
            else {
                let hour = Calendar.current.component(.hour, from: Date().addingTimeInterval(43200000))
                let min = Calendar.current.component(.minute, from: Date().addingTimeInterval(43200000))
                scheduleNotification(hours: hour, minutes: min, shouldClear: false)
            }
            
         
        }
        else if selectedrow == 2 {
            standard.set("3x", forKey: "alertvalue")
            standard.synchronize()
            
            
            if let sStartTime = standard.object(forKey: "starttime") as? Date {
                
                let hour = Calendar.current.component(.hour, from: sStartTime)
                let min = Calendar.current.component(.minute, from: sStartTime)
                
                scheduleNotification(hours: hour, minutes: min, shouldClear: true)
            }
            else {
                let hour = Calendar.current.component(.hour, from: Date())
                let min = Calendar.current.component(.minute, from: Date())
                
                scheduleNotification(hours: hour, minutes: min, shouldClear: true)
            }
            
            if let sEndTime = standard.object(forKey: "endtime") as? Date {
                
                let hour = Calendar.current.component(.hour, from: sEndTime)
                let min = Calendar.current.component(.minute, from: sEndTime)
                
                scheduleNotification(hours: hour, minutes: min, shouldClear: false)
            }
            else {
                let hour = Calendar.current.component(.hour, from: Date().addingTimeInterval(43200000))
                let min = Calendar.current.component(.minute, from: Date().addingTimeInterval(43200000))
                scheduleNotification(hours: hour, minutes: min, shouldClear: false)
            }
            
            
           
            
        }
        showToast(message: "Saved")
    }
    
    @objc func closeBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dailyClarityInsightsClicked(){
     
            slideVC.modalPresentationStyle = .custom
            slideVC.transitioningDelegate = self
            self.present(slideVC, animated: true, completion: nil)
          
        
    }
    
    @objc func startAndEndTimeClicked(){
        startAndEndSlideVC.initializeSettingVC(settingVC: self)
        startAndEndSlideVC.modalPresentationStyle = .custom
        startAndEndSlideVC.transitioningDelegate = self
        self.present(startAndEndSlideVC, animated: true, completion: nil)
    }
    
}


extension SettingsViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        
        if let name =  presented.nibName {
            if name != "OverlayView" {
                return StartAndEndTimePresentationViewController(presentedViewController: presented, presenting: presenting,settingsVC: self)
            }

        }
       
        return PresentationController(presentedViewController: presented, presenting: presenting,settingsVC: self)
       
 
    }
    
    
    

}
