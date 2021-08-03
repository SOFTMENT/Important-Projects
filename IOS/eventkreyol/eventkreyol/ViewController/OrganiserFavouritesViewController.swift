//
//  OrganiserFavouritesViewController.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 27/07/21.
//

import UIKit

class OrganiserFavouritesViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
}


extension OrganiserFavouritesViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favorganisercell", for: indexPath) as? FavouriteOrganiserViewCell {
            
            cell.mView.layer.cornerRadius = 12
            cell.mView.dropShadow()
            
            cell.mImage.layer.cornerRadius = 8
            
            
            
           
            return cell
        
        }
        return FavouriteOrganiserViewCell()
    }
    
    
    
}
