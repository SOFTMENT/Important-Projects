//
//  PastTicketsViewController.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 27/07/21.
//

import UIKit

class PastTicketsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
       
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension PastTicketsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ticketcell", for: indexPath) as? Ticket_View_Cell {
            
            cell.mView.layer.cornerRadius = 12
            cell.mView.dropShadow()

            cell.mTicketImage.roundCorners(corners: [.topLeft, .bottomLeft], radius: 12)
            cell.mTicketsNumberView.layer.cornerRadius = cell.mTicketsNumberView.frame.width / 2
            
     
            return cell
        
        }
        return Ticket_View_Cell()
    }
    
    
    
}
