//
//  CreateUserViewController.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 20/04/21.
//

import UIKit
import MBProgressHUD
import Firebase

class CreateUserViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource , UITextFieldDelegate {
    var selectedWarehouseName: String = ""
    var wareHouseList = ["Darwin", "K1", "K2", "Mataranka"]
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var enterMachineNumber: UITextField!
    
    @IBOutlet weak var wareHouse: UITextField!
    
    override func viewDidLoad() {
        
        addBtn.layer.cornerRadius = 4
        createPickerView()
        dismissPickerView()
        
      
        name.delegate = self
        enterMachineNumber.delegate = self
       
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        let sName = name.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sMachinenumber = enterMachineNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let intMach = Int(sMachinenumber!) {
            if intMach > 22 {
                self.showError("Machine Number Can not greater than 22")
                return
            }
        }
        if selectedWarehouseName == "" || sName == ""  || sMachinenumber == "" {
            self.showToast(message: "Fill All Fields")
            return
        }
        else {
           
            ProgressHUDShow(text: "Wait...")
            
            let designation = "crewmember"
            
           
            let dbRef = Database.database().reference().child("MangoFarm").child("Users")
           
            let data = ["name" : sName,"pId":sMachinenumber,"designation":designation,"farmHouseName":selectedWarehouseName,"machineNumber" : sMachinenumber,"email" : "\(String(describing: sMachinenumber))@mangobin.com"]
            
            dbRef.child(sMachinenumber!).setValue(data) { (error, dbref) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    self.name.text = ""
                
                    self.wareHouse.text = ""
                    self.enterMachineNumber.text = ""
                    self.showToast(message: "Machine profile Added")
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
            
        }
        
    }
    
    func createPickerView() {
          let pickerView = UIPickerView()
          pickerView.delegate = self
          wareHouse.inputView = pickerView
      }
    
    @objc func action() {
        view.endEditing(true)
    
     }
    
    
    
    
  

      func dismissPickerView() {
          let toolBar = UIToolbar()
          toolBar.sizeToFit()
          
          let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.action))
        
        
          toolBar.setItems([button], animated: true)
        
          toolBar.isUserInteractionEnabled = true
        wareHouse.inputAccessoryView = toolBar
      }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return wareHouseList.count
      }
      
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return wareHouseList[row]
        
         
      }
      
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          selectedWarehouseName = wareHouseList[row]
        wareHouse.text = selectedWarehouseName
            
      }
    
}
