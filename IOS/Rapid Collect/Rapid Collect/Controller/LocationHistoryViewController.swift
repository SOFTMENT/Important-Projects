//
//  LocationHistoryViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 27/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class LocationHistoryViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var root = Database.database().reference().child("LocationHistory")
    var locationModels  =  [LocationModel]()
    
    @IBOutlet weak var myView: UIView!
    
    var animationView : AnimationView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
         animationView = AnimationView(name: "load")
        
        tableview.rowHeight = UITableView.automaticDimension
       tableview.estimatedRowHeight = 300
        
    
          animationView!.frame = self.myView.bounds
          self.myView.addSubview(animationView!)
          animationView!.play()
          animationView!.loopMode = .loop
        
        if let user = Auth.auth().currentUser {
            
            root.child(user.uid).queryLimited(toLast: 25).observeSingleEvent(of: .value) { (snapshot) in
                self.locationModels.removeAll()
                for snap in snapshot.children {
                    
                    if let snap = snap as? DataSnapshot {
                        
                        let s = snap.value as! [String : String]
                        
                        let locationmodel = LocationModel(address: s["message"]!, date: s["date"]!)
                        self.locationModels.append(locationmodel)
                        
                        
                    }
                    
                    
                    
                }
                self.animationView?.stop()
                self.myView.isHidden = true
                self.tableview.reloadData()
            }
        }
      
        
    }
    
    
}


extension LocationHistoryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "addresscell", for: indexPath) as? AddressCell {
            let locationmodel = locationModels[locationModels.count - indexPath.row - 1]
            cell.addressLabel.text = locationmodel.address
            cell.dateLabel.text = locationmodel.date
            return cell
        
        }
        
        return UITableViewCell()
    }
    
    
    
}
