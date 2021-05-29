//
//  CrewmemberViewController.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 19/04/21.
//
import Firebase
import UIKit
import MBProgressHUD

class CrewmemberViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var userModels =  Array<UserModel>()
   
    override func viewDidLoad() {
        
         tableView.delegate = self
         tableView.dataSource = self
         self.tableView.rowHeight = UITableView.automaticDimension
         self.tableView.estimatedRowHeight = 44
         getAllCrewMembersName()
        
    }
    
    func getAllCrewMembersName() {
        ProgressHUDShow(text: "Loading...")
        Database.database().reference().child("MangoFarm").child("Users").queryOrdered(byChild: "designation").queryEqual(toValue: "machine").observeSingleEvent(of: .value) { (snapshot) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if snapshot.exists() {
                self.userModels.removeAll()
                for snap in snapshot.children {
                    if let s = snap as? DataSnapshot {
                        if  let data = s.value as? [String : Any] {
                           
                            let name = data["name"] as? String
                            let pId = data["pId"] as? String
                            let email = data["email"] as? String
                            let designation = data["designation"] as? String
                    
                            let machineNumber = data["machineNumber"] as? String
                           
                        
                            let userModel = UserModel( email: email!, machineNumber: machineNumber!,name: name!, designation: designation!, pid: pId!)
                            
                            self.userModels.append(userModel)
                            
                        }
                    }
                }
                
                self.tableView.reloadData()
               
            }
            else {
                self.showError("No Report Available")
            }
        }
    }
    @objc func getReportBasedOnCrewmember(csutom : CustomTapGestureRecognizer)  {
        ProgressHUDShow(text: "Downloading...")
        Database.database().reference().child("MangoFarm").child("BinInfo").queryOrdered(byChild: "scannedByName").queryEqual(toValue: csutom.ourCustomValue).observeSingleEvent(of: .value) { (snapshot) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.extractDataFromSnashot(snapshot: snapshot)
           
        }
    }
}

class CustomTapGestureRecognizer: UITapGestureRecognizer {
    var ourCustomValue: String?
}

extension CrewmemberViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "crewmembercell", for: indexPath) as? CrewmemberTableViewCell {
           
            let user = userModels[indexPath.row]
            
            cell.name.text = user.name.capitalized
            cell.email.text = user.email
        
            let custom = CustomTapGestureRecognizer(target: self, action:#selector(getReportBasedOnCrewmember(csutom:)))
            custom.ourCustomValue = user.name
            cell.download.addGestureRecognizer(custom)
            
            
            return cell
            }
          
          
        return CrewmemberTableViewCell()
            
        }
    
    
   
}
    
       


