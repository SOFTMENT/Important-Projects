//
//  NetworkViewController.swift
//  hbcumade
//
//  Created by Vijay on 05/04/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class NetworkViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var directorySearchEditField: UITextField!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gridStack: UIStackView!
    @IBOutlet weak var addFilterBtn: UIButton!

    var allUserData = Array<UserData>()

    override func viewDidLoad() {
        
        
        directorySearchEditField.attributedPlaceholder = NSAttributedString(string: "Search...",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        directorySearchEditField.setLeftPaddingPoints(10)
        directorySearchEditField.setRightPaddingPoints(10)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
   
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        //AddFilterButton
        addFilterBtn.layer.cornerRadius = 6
        
        
        //getAllUsers()
        getAllUsers()
     
    }
    
    public func getAllUsers(){
        Firestore.firestore().collection("Users").order(by: "registredAt", descending: false).addSnapshotListener { snapshot, error in
            if error == nil {
                
                self.allUserData.removeAll()
                if let snapshot = snapshot {
                    for qds in snapshot.documents {
                        if let network = try? qds.data(as: UserData.self){
                            if network.uid != Auth.auth().currentUser?.uid {
                                self.allUserData.append(network)
                            }
                           
                        }
                        
                    }
                
                }
                
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
               self.tableViewHeight.constant = CGFloat(105 * self.allUserData.count)
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
    }

    
 
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return allUserData.count
    }
 
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "networkcell", for: indexPath) as? NetworkPageCell {
           
            let userData = self.allUserData[indexPath.row]
           
            cell.profilePic.makeRounded()
            cell.name.text = userData.name
            cell.status.text = userData.school
            if userData.profile != "" {
                
                cell.profilePic.sd_setImage(with: URL(string: userData.profile!), placeholderImage:UIImage(named: "profile-user"))
            
            }
            
            
          
          
            return cell
            
        }
       
        return NetworkPageCell()
        
    }
    
    
    
    
}

