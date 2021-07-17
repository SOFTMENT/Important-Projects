//
//  SchoolWaitListController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 14/07/21.
//

import UIKit
import FirebaseFirestore
import Firebase

class SchoolWaitListController : UIViewController {
    
    @IBOutlet weak var no_user_in_waitlist: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var pendingUsers = [UserData]()
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight =  300
        
        
        getPendingUsers()
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func approvedBtnClicked(value : MyTapGesture){
        ProgressHUDShow(text: "")
        Firestore.firestore().collection("Users").document(self.pendingUsers[value.index].uid!).setData(["hasApproved" : true,"school" : self.pendingUsers[value.index].customSchoolName ?? "Oxford University"], merge: true) { error in
            self.ProgressHUDHide()
            if error == nil {
                self.showToast(message: "Approved")
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
    }
}



extension SchoolWaitListController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pendingUsers.count > 0 {
            no_user_in_waitlist.isHidden = true
            return pendingUsers.count
        }
        no_user_in_waitlist.isHidden = false
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if let cell = tableView.dequeueReusableCell(withIdentifier: "waitlistcell", for: indexPath) as?  WaitlistViewCell{
            let user  = pendingUsers[indexPath.row]
            cell.profile.makeRounded()
            cell.name.text = user.name
            cell.schoolName.text = user.customSchoolName
            cell.approveBtn.layer.cornerRadius = 6
            
            
            cell.approveBtn.isUserInteractionEnabled = true
            let myTap = MyTapGesture(target: self, action: #selector(approvedBtnClicked(value:)))
            myTap.index = indexPath.row
            cell.approveBtn.addGestureRecognizer(myTap)
            if user.profile != "" {
                
                cell.profile.sd_setImage(with: URL(string: user.profile ?? ""), placeholderImage: UIImage(named: "profile-placeholder"), options: .continueInBackground, completed: nil)
            
            }
            else {
                cell.profile.image = UIImage(named: "profile-user")!
            }
            
            if (user.classification?.caseInsensitiveCompare("Alumni") == .orderedSame) {
                cell.classificationImage.image = UIImage(named: "icons8-graduation-cap-50")
            }
            else {
                cell.classificationImage.image = UIImage(named: "icons8-reading-50")
            }
            
            return cell

        }
        
    
        return WaitlistViewCell()
        
    }
    
    public func getPendingUsers(){
        
        Firestore.firestore().collection("Users").order(by: "registredAt", descending: false).whereField("hasApproved", isEqualTo: false).addSnapshotListener { snapshot, error in
            if error == nil {
                
                self.pendingUsers.removeAll()
                if let snapshot = snapshot {
                    for qds in snapshot.documents {
                        if let network = try? qds.data(as: UserData.self){
                            if let customSchool = network.customSchoolName {
                                if customSchool != "" {
                                    if let school = network.school {
                                        if school == "" {
                                            self.pendingUsers.append(network)
                                        }
                                    }
                                    else {
                                        self.pendingUsers.append(network)
                                    }
                                    
                                }
                                
                            }
                           
                        }
                        
                    }
                
                }
                
                self.tableView.reloadData()
                
                
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
    }

}

