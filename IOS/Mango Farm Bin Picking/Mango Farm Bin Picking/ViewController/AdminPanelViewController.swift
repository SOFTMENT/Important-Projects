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

class AdminPanelViewController: UIViewController, CalendarDateRangePickerViewControllerDelegate,  UITextFieldDelegate {
    

    
    func didTapCancel() {
        dateRangePickerViewController?.dismiss(animated: true, completion:nil)
    }
    
    func didTapDoneWithDateRange(startDate: Date!, endDate: Date!) {
        dateRangePickerViewController?.dismiss(animated: true, completion:nil)
        self.getReportsBasedOnDate(startDate: startDate.timeIntervalSince1970, endDate: endDate.timeIntervalSince1970)
    }
  
     
    @objc func actioncancel() {
       view.endEditing(true)
    }
    var dateRangePickerViewController : CalendarDateRangePickerViewController?
    @IBOutlet weak var crewMemberBtn: UIButton!
    @IBOutlet weak var machineNumber: UITextField!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var binBtn: UIButton!
    
    
    override func viewDidLoad() {
        
       
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        
    
        dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: collectionViewLayout)
        
        dateRangePickerViewController!.minimumDate = Calendar.current.date(byAdding: .month, value: -6, to: Date())
        
        
        dateRangePickerViewController!.maximumDate = Date()
        
        dateRangePickerViewController!.selectedStartDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())
        dateRangePickerViewController!.selectedEndDate = Date()
        
        dateRangePickerViewController!.delegate = self
        
        crewMemberBtn.layer.cornerRadius = 4
        machineNumber.layer.cornerRadius = 4
        binBtn.layer.cornerRadius = 4
        dateBtn.layer.cornerRadius = 4
        
        
        
    }
    
    
    @IBAction func dateSelected(_ sender: Any) {
    
            let navigationController = UINavigationController(rootViewController: dateRangePickerViewController!)
        
            
            self.navigationController?.present(navigationController, animated: true, completion: nil)
    
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
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getReportBasedOnMachineNumber(machineNumber : String) {
        ProgressHUDShow(text: "Downloading...")
        Database.database().reference().child("MangoFarm").child("BinInfo").queryOrdered(byChild: "machineNumber").queryEqual(toValue: machineNumber).observeSingleEvent(of: .value) { (snapshot) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.extractDataFromSnashot(snapshot: snapshot)
           
        }
    }
    
    func getReportBasedOnCrewMember(crewName : String) {
        ProgressHUDShow(text: "Downloading...")
        Database.database().reference().child("MangoFarm").child("BinInfo").queryOrdered(byChild: "scannedByName").queryEqual(toValue: crewName).observeSingleEvent(of: .value) { (snapshot) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.extractDataFromSnashot(snapshot: snapshot)
           
        }
    }
    
    func getReportBasedOBinNumber(binNumber : Int) {
        ProgressHUDShow(text: "Downloading...")
        Database.database().reference().child("MangoFarm").child("BinInfo").queryOrdered(byChild: "binNumber").queryEqual(toValue: binNumber).observeSingleEvent(of: .value) { (snapshot) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.extractDataFromSnashot(snapshot: snapshot)
           
        }
    }
    
    
    func getReportsBasedOnDate(startDate : Double, endDate : Double) {
        ProgressHUDShow(text: "Downloading...")
        Database.database().reference().child("MangoFarm").child("BinInfo").queryOrdered(byChild: "date").queryStarting(atValue: startDate).queryEnding(atValue: endDate).observeSingleEvent(of: .value) { (snapshot) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.extractDataFromSnashot(snapshot: snapshot)
        }
    }
    
   
    
    
    
}
