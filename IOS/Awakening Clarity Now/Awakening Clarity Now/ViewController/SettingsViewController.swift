//
//  SettingsViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 21/05/21.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseFirestoreSwift

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    public var clarityData  = Array<ClarityModel>()
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
        pickerData = ["1X", "2X", "3X", "4X", "5X", "6X","7X","8X","9X"]
        
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
        
        

        
        //getAllClarity
        self.getAllDailyClarity()
        
        var alertvalue = standard.integer(forKey: "alertvalue")
        if alertvalue <= 0 {
            alertvalue = 1
        }
        pickerView.selectRow((alertvalue - 1), inComponent: 0, animated: false)
        
    
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
               // self.scheduleNotification()
            } else {
               
            }
        }
    }
    
    func getAllDailyClarity() {
        
        Firestore.firestore().collection("Clarity").getDocuments { snap, error in
            if error == nil {
                self.clarityData.removeAll()
                if let snap = snap {
                    for s in snap.documents {
                        if let clarity = try? s.data(as: ClarityModel.self) {
                            self.clarityData.append(clarity)
                          
                        }
                    }
                }
            }
            
        }
    }
    
    func clearAllNotifications(){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    
    }
    
    func scheduleNotification(hours : Int, minutes : Int,message : String) {
    
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Awakening Clarity Now"
        content.body = message
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
       
        setAlert(count: selectedrow + 1)
        showToast(message: "Saved")
    }
    
    public func setAlert(count : Int) {
        let s = count
        standard.set(s, forKey: "alertvalue")
        standard.synchronize()
        
        self.clearAllNotifications()
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
                        if value >= clarityData.count {
                           value = 0
                        }
                        let message = self.clarityData[value].clarity
                        self.scheduleNotification(hours: hour, minutes: min,message: message)
                        }
                        else {
                            self.scheduleNotification(hours: hour, minutes: min, message: "Check Daily Insight")
                        }
                    }
                    else {
                        self.scheduleNotification(hours: hour, minutes: min,message: "Check Daily Insight")
                    }
                  
                }
            }
 
        else {
            
            
            let calendar = Calendar.current
            let now = Date()
            let eight_today = calendar.date(
              bySettingHour: 8,
              minute: 0,
              second: 0,
              of: now)!
            
            let eight_today_evening = calendar.date(
              bySettingHour: 20,
              minute: 0,
              second: 0,
              of: now)!
            
            let diffSeconds = eight_today_evening.seconds(from: eight_today)
            let dividedSec = diffSeconds / (count + 1)
            var newDate = eight_today
           
            for i in 1...count {
                newDate = newDate.addingTimeInterval(TimeInterval(dividedSec))
                let hour = Calendar.current.component(.hour, from: newDate)
                let min = Calendar.current.component(.minute, from: newDate)
                if let status = standard.string(forKey: "claritystatus") {
                    if status == "yes" {
                        
                    
                    var value = i - 1
                    print(value)
                    if value >= clarityData.count {
                       value = 0
                    }
                    let message = self.clarityData[value].clarity
                    self.scheduleNotification(hours: hour, minutes: min,message: message)
                    }
                    else {
                        self.scheduleNotification(hours: hour, minutes: min,message: "Check Daily Insight")
                    }
                }
                else {
                    self.scheduleNotification(hours: hour, minutes: min,message: "Check Daily Insight")
                }
            }
            
            
        }
        
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
