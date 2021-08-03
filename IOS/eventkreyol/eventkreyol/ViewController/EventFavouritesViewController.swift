//
//  EventFavouritesViewController.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 27/07/21.
//

import UIKit

class EventFavouritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        
        tableView.delegate = self
        tableView.dataSource = self
       
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 4
        
        
    }
}



extension EventFavouritesViewController : UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
            if let cell = tableView.dequeueReusableCell(withIdentifier: "eventviewcell", for: indexPath) as? Event_View_Cell {
                
                cell.eventView.layer.cornerRadius  = 12
                cell.eventView.dropShadow()
                
                cell.eventImage.layer.cornerRadius = 8
                
               
                return cell
            }
            
            return Event_View_Cell()
        
 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventseg", sender: nil)
    }
    
    
    
}
