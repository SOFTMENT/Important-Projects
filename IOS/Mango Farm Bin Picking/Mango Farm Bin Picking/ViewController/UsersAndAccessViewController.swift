//
//  UsersAndAccessViewController.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 20/04/21.
//

import UIKit
import Firebase
import MBProgressHUD

class UsersAndAccessViewController: UIViewController {
    var userModels = Array<UserModel>()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addUserBtn: RoundedUIView!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        getAllCrewMembersName()
        
        addUserBtn.isUserInteractionEnabled = true
        addUserBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addUserBtnClicked)))
    }
    
    @objc func addUserBtnClicked() {
        performSegue(withIdentifier: "createuserseg", sender: nil)
    }
    
    func getAllCrewMembersName(){
        ProgressHUDShow(text: "Loading...")
        Database.database().reference().child("MangoFarm").child("Users").queryOrdered(byChild: "designation").queryEqual(toValue: "crewmember").observe(.value) { (snapshot) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.userModels.removeAll()
            if snapshot.exists() {
               
                for snap in snapshot.children {
                    if let s = snap as? DataSnapshot {
                        if  let data = s.value as? [String : Any] {
                           
                            let name = data["name"] as? String
                            let pId = data["pId"] as? String
                            let email = data["email"] as? String
                            let designation = data["designation"] as? String
                        
                           let machineNumber = data["machineNumber"] as? String
                        
                            let userModel = UserModel( email: email!, machineNumber: machineNumber!, name: name!, designation: designation!, pid: pId!)
                            
                            self.userModels.append(userModel)
                            
                        }
                    }
                }
                
               
               
            }
            self.tableView.reloadData()
        }
    }
    

    @objc func removeCrewMember(custom : CustomTapGestureRecognizer) {
        Database.database().reference().child("MangoFarm").child("Users").child(custom.ourCustomValue!).setValue(nil)
    }
}


extension UsersAndAccessViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "userandaccesscell", for: indexPath) as? UserAndAccessTableViewCell {
           
            let user = userModels[indexPath.row]
            
            cell.name.text = user.name.capitalized
            cell.email.text = user.email
            let custom = CustomTapGestureRecognizer(target: self, action:#selector(removeCrewMember(custom:)))
            custom.ourCustomValue = String(user.pId)
            cell.removeBtn.addGestureRecognizer(custom)
            
            
            return cell
            }
          
          
        return UserAndAccessTableViewCell()
            
        }
    
    
   
}
    
       



