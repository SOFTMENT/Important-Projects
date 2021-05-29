//
//  EventViewController.swift
//  Admin Oh Crepe & Waffles
//
//  Created by Vijay on 08/05/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import MBProgressHUD

class EventViewController: UIViewController {
    
    var events = Array<EventModel>()
   
    @IBOutlet weak var addEventBtn: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addEventBtn.isUserInteractionEnabled = true
        addEventBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addEventBtnTapped)))
        
        
        //GetEventData
        getEventData()
        
    }
    
    @objc func addEventBtnTapped() {
        performSegue(withIdentifier: "addeventseg", sender: nil)
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

                }
                
            }
            else {
                self.showError(error.debugDescription)
            }
        }
        
        
    }
    
    @objc func deleteBtnTapped(value : MyTapGesture){
        let alert = UIAlertController(title: "Event Delete", message: "Are you sure you want to delete event?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            let id = value.eventId
                    self.ProgressHUDShow(text: "Deleting...")
                    Firestore.firestore().collection("Events").document(id).delete { error in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if error == nil {
                            self.showToast(message: "Deleted...")
                        }
                        else {
                            self.showError(error!.localizedDescription)
                        }
                    }
            
          
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        

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
            
            cell.delete.isUserInteractionEnabled = true
            let myTapGesture = MyTapGesture(target: self, action: #selector(deleteBtnTapped(value:)))
            myTapGesture.eventId = String(event.id)
            cell.delete.addGestureRecognizer(myTapGesture)
            
            return cell
        }
        return EventTableViewCell()
    }
    
    


   
    
    
    
}

class MyTapGesture: UITapGestureRecognizer {
    
    var eventId = ""
}

