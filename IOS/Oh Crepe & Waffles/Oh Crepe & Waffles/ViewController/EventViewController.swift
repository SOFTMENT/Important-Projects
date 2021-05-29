//
//  EventViewController.swift
//  Oh Crepe & Waffles
//
//  Created by Vijay on 06/05/21.
//

import UIKit
import AMTabView
import Firebase
import FirebaseFirestoreSwift
import MBProgressHUD

class EventViewController: UIViewController,TabItem {
    
    var events = Array<EventModel>()
    var tabImage: UIImage? {
        return UIImage(named: "calendar")
    }
    
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
       
        
        
    
        //Get Event Data
        getEventData()
        
    }
    

  
    
    func getEventData() {
        ProgressHUDShow(text: "Loading")
        Firestore.firestore().collection("Events").order(by: "rdate", descending: true).addSnapshotListener { snapshot, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                if let snapshot = snapshot {
                    self.events.removeAll()
                    for snap in snapshot.documents {
                        if let cat = try? snap.data(as: EventModel.self) {
                            self.events.append(cat)
                        }
                       
                    }
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(item: self.events.count - 1, section: 0), at: .bottom,
                          animated: false)
                  
                }
                
                
            }
            else {
                self.showError(error.debugDescription)
            }
        }
        
    }
  
}


extension EventViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "eventcell", for: indexPath) as? EventTableViewCell {
            
            let event = events[indexPath.row]
            
            cell.view.dropShadow()
            cell.view.layer.cornerRadius = 6
            
            cell.title.text = event.title
            cell.address.text = event.address
            cell.time.text = event.time
            cell.date.text = event.date
            
           
            return cell
        }
        return EventTableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
}
