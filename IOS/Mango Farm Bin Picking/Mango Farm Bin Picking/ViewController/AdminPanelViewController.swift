//
//  AdminPanelViewController.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 19/04/21.
//

import UIKit
import MBProgressHUD
import CalendarDateRangePickerViewController
import Firebase

class AdminPanelViewController: UIViewController, UITextFieldDelegate {
    

//
//    func didTapCancel() {
//        dateRangePickerViewController?.dismiss(animated: true, completion:nil)
//    }
//
//    func didTapDoneWithDateRange(startDate: Date!, endDate: Date!) {
//        dateRangePickerViewController?.dismiss(animated: true, completion:nil)
//        self.getReportsBasedOnDate(startDate: startDate.timeIntervalSince1970, endDate: endDate.timeIntervalSince1970)
//    }
  
     
    @objc func actioncancel() {
       view.endEditing(true)
    }
    //var dateRangePickerViewController : CalendarDateRangePickerViewController?
    @IBOutlet weak var crewMemberBtn: UIButton!
    @IBOutlet weak var machineNumber: UITextField!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var binBtn: UIButton!
    @IBOutlet weak var machineStatusBtn: UIButton!
    
 
    
    override func viewDidLoad() {
        
       
        
//        let collectionViewLayout = UICollectionViewFlowLayout()
//
//
//        dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: collectionViewLayout)
//
//        dateRangePickerViewController!.minimumDate = Calendar.current.date(byAdding: .month, value: -6, to: Date())
//
//
//        dateRangePickerViewController!.maximumDate = Date()
//
//        dateRangePickerViewController!.selectedStartDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())
//        dateRangePickerViewController!.selectedEndDate = Date()
//
//        dateRangePickerViewController!.delegate = self
        
        crewMemberBtn.layer.cornerRadius = 4
        machineNumber.layer.cornerRadius = 4
        binBtn.layer.cornerRadius = 4
        machineStatusBtn.layer.cornerRadius = 4
        machineStatusBtn.isUserInteractionEnabled = true
        machineStatusBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(machineStatusClicked(_:))))
        dateBtn.layer.cornerRadius = 4
        
        
        
    }
    
    
    @IBAction func dateSelected(_ sender: Any) {
    
        let picker : UIDatePicker = UIDatePicker()
    
        
        picker.datePickerMode = UIDatePicker.Mode.date
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .inline
            
        }
        
        picker.backgroundColor = .black
        picker.tintColor = .red
   
        picker.setDate(Date().addingTimeInterval(60*60*24), animated: false)
        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: .valueChanged)
            let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
        picker.frame = CGRect(x:(view.layer.bounds.width / 2) - (pickerSize.width / 2) , y:(view.layer.bounds.height / 2) - (230), width:pickerSize.width, height:460)
            // you probably don't want to set background color as black
            // picker.backgroundColor = UIColor.blackColor()
            self.view.addSubview(picker)
    }
    
    @objc func dueDateChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        sender.isHidden = true
        let startDate = sender.date.addingTimeInterval(60 * 60 * (-12))
        let endDate = sender.date.addingTimeInterval(60 * 60 * 12)
        self.getReportsBasedOnDate(startDate: startDate.timeIntervalSince1970, endDate: endDate.timeIntervalSince1970)
        
        print(sender.date)
        
    }
    
   
    @IBAction func machineSelected(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "MACHINE NUMBER REPORT", message: "", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Machine Number"
            textField.keyboardType = .numberPad
        }
            
      
            
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Download", style: .default, handler: { [weak alert] (_) in
            let machineNo = alert?.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines) // Force unwrapping
            
            if (!machineNo!.isEmpty) {
                self.getReportBasedOnMachineNumber(machineNumber: machineNo!)
                
            }
            else {
                self.showToast(message: "Please Enter Machine Number")
            }
            
         
        }))
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Download All", style: .default, handler: { [weak alert] (_) in
            
                self.getReportBasedOnAllMachines()
                
           
            
         
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func crewMemberSelected(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "CREW MEMBER REPORT", message: "", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Crew Member Name"
        }
            
      
            
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Download", style: .default, handler: { [weak alert] (_) in
            let crew = alert?.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines) // Force unwrapping
            
            if (!crew!.isEmpty) {
                self.getReportBasedOnCrewMember(crewName: crew!)
                
            }
            else {
                self.showToast(message: "Please Enter Crew Member Name")
            }
            
          
        }))
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Download All Members Report", style: .default, handler: { [weak alert] (_) in
         
            
            
                self.getReportBasedOnAllCrewMembers()
                
           
            
          
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    
    }
    
    @IBAction func binNumberSeelected(_ sender: Any) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "BIN NUMBER REPORT", message: "", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Bin Number"
            textField.keyboardType = .numberPad
        }
            
      
            
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Download", style: .default, handler: { [weak alert] (_) in
            let binNo = alert?.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines) // Force unwrapping
            
            if (!binNo!.isEmpty) {
                self.getReportBasedOBinNumber(binNumber: Int(binNo!)!)
                
            }
            else {
                self.showToast(message: "Please Enter Bin Number")
            }
            
         
        }))
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Download All Bin Report", style: .default, handler: { [weak alert] (_) in
            
           
                self.getReportBasedOnAllBinNumber()
                
            
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getReportBasedOnMachineNumber(machineNumber : String) {
        ProgressHUDShow(text: "Downloading...")
        Constants.getFirestoreDB().collection("BinInfo").whereField("machineNumber", isEqualTo: machineNumber).getDocuments(completion: { snapshot, err in
            MBProgressHUD.hide(for: self.view, animated: true)
        
            self.extractDataFromSnashot(snapshot: snapshot)
        })
 
    }
    
    func getReportBasedOnAllMachines()  {
        ProgressHUDShow(text: "Downloading...")
        Constants.getFirestoreDB().collection("BinInfo").getDocuments(completion: { snapshot, err in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.extractDataFromSnashot(snapshot: snapshot)
        })
    }
    
    func getReportBasedOnCrewMember(crewName : String) {
        ProgressHUDShow(text: "Downloading...")
       
        
        Constants.getFirestoreDB().collection("BinInfo").whereField("scannedByName", isEqualTo: crewName).getDocuments(completion: { snapshot, err in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.extractDataFromSnashot(snapshot: snapshot)
        })
    }
    
    func getReportBasedOnAllCrewMembers(){
        ProgressHUDShow(text: "Downloading...")
       
        
        Constants.getFirestoreDB().collection("BinInfo").getDocuments(completion: { snapshot, err in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.extractDataFromSnashot(snapshot: snapshot)
        })
    }
    
    func getReportBasedOBinNumber(binNumber : Int) {
        ProgressHUDShow(text: "Downloading...")
       
        Constants.getFirestoreDB().collection("BinInfo").whereField("binNumber", isEqualTo: binNumber).getDocuments(completion: { snapshot, err in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.extractDataFromSnashot(snapshot: snapshot)
        })
    }
    
    
    func getReportBasedOnAllBinNumber() {
        ProgressHUDShow(text: "Downloading...")
       
        Constants.getFirestoreDB().collection("BinInfo").getDocuments(completion: { snapshot, err in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.extractDataFromSnashot(snapshot: snapshot)
        })
    }
    
    func getReportsBasedOnDate(startDate : Double, endDate : Double) {
        ProgressHUDShow(text: "Downloading...")
       
        Constants.getFirestoreDB().collection("BinInfo").whereField("date", isGreaterThanOrEqualTo: startDate).whereField("date", isLessThanOrEqualTo : endDate).getDocuments(completion: { snapshot, err in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.extractDataFromSnashot(snapshot: snapshot)
        })
    }
    
    
    
    
    @objc func machineStatusClicked(_ sender: Any) {
        
        print("HELLO")
        ProgressHUDShow(text: "Downloading...")
       
        Constants.getFirestoreDB().collection("MachineStatus").getDocuments(completion: { snapshot, err in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.extractDataFromSnashotForMachineStatus(snapshot: snapshot)
        })
    }
    
    
   
    
    
    
}


