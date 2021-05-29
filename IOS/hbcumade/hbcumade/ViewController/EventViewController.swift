//
//  EventViewController.swift
//  hbcumade
//
//  Created by Vijay on 09/04/21.
//

import UIKit

class EventViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var moreEvents: UIButton!
    
    @IBOutlet weak var trendingTableViewHeight: NSLayoutConstraint!

    @IBOutlet weak var upcmingTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var upcomingEventTableView: UITableView!
    @IBOutlet weak var trendingEventTableView: UITableView!
    @IBOutlet weak var directorySearchEditField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var gridStack: UIStackView!


    var events = Array<Event>()
    override func viewDidLoad() {
        
        
        directorySearchEditField.attributedPlaceholder = NSAttributedString(string: "Search...",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        directorySearchEditField.setLeftPaddingPoints(10)
        directorySearchEditField.setRightPaddingPoints(10)
       
        //FINDGROUPTABLEVIEW
        upcomingEventTableView.delegate = self
        upcomingEventTableView.dataSource = self
        upcomingEventTableView.isScrollEnabled = false
   
        self.upcomingEventTableView.rowHeight = UITableView.automaticDimension
        self.upcomingEventTableView.estimatedRowHeight = 44
        
  
        //FINDPEOPLETOFOLLOWTABLE
        trendingEventTableView.delegate = self
        trendingEventTableView.dataSource = self
        trendingEventTableView.isScrollEnabled = false
   
        self.trendingEventTableView.rowHeight = UITableView.automaticDimension
        self.trendingEventTableView.estimatedRowHeight = 44
        
        
        //MOREEVENTS
        moreEvents.layer.cornerRadius = 6
        
        events.append(Event(name: "Vijay Rathore", status: "Mobile App Developer", image: "https://i.pravatar.cc/300", date: Date()))
        events.append(Event(name: "Manoj Kumar Verma", status: "Professional Logo Designer", image: "https://i.pravatar.cc/301", date: Date()))
        
        events.append(Event(name: "Vaibhav Sharma", status: "Businessman", image: "https://i.pravatar.cc/302", date: Date()))
        events.append(Event(name: "Akshay Munya", status: "Teacher", image: "https://i.pravatar.cc/303", date: Date()))
        events.append(Event(name: "Salman Khan", status: "Available", image: "https://i.pravatar.cc/304", date: Date()))
        events.append(Event(name: "Akshay Kumar", status: "can't talk whatsapp only", image: "https://i.pravatar.cc/305", date: Date()))
        events.append(Event(name: "Rajkumar Hirani", status: "Website Developer", image: "https://i.pravatar.cc/306", date: Date()))
        events.append(Event(name: "Shashikant Bharti", status: "Artist", image: "https://i.pravatar.cc/307", date: Date()))
        events.append(Event(name: "Amit Giri", status: "Singer", image: "https://i.pravatar.cc/308", date: Date()))
        events.append(Event(name: "Ajay Rathore", status: "Battery about to die", image: "https://i.pravatar.cc/309", date: Date()))
        events.append(Event(name: "Vermaak Petrus", status: "Professional Logo Designer", image: "https://i.pravatar.cc/310", date: Date()))
        events.append(Event(name: "Krishna Yadav", status: "Can't talk whatsapp only", image: "https://i.pravatar.cc/311", date: Date()))
        events.append(Event(name: "Anmol Pandey", status: "YouTuber", image: "https://i.pravatar.cc/312", date: Date()))
        events.append(Event(name: "Naresh Dewra", status: "Freelancer", image: "https://i.pravatar.cc/313", date: Date()))
        events.append(Event(name: "Manyank Gothi", status: "Website Developer", image: "https://i.pravatar.cc/314", date: Date()))
        events.append(Event(name: "Sanju Samson", status: "Hardware Expert", image: "https://i.pravatar.cc/315", date: Date()))
        
      
      
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        self.upcomingEventTableView.reloadData()
        self.upcomingEventTableView.layoutIfNeeded()
        self.upcmingTableViewHeight.constant = CGFloat(105 * events.count)
        
        self.trendingEventTableView.reloadData()
        self.trendingEventTableView.layoutIfNeeded()
        self.trendingTableViewHeight.constant = CGFloat(105 * 3)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == upcomingEventTableView {
            return events.count
        }
        
        return 3
        
      
    }
 
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == upcomingEventTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingEventCell", for: indexPath) as? EventUpcomingCell {
           
            let directory = self.events[indexPath.row]
           
            cell.profilePic.makeRounded()
            cell.name.text = directory.name
            cell.status.text = directory.status
            if directory.image != "" {
                
                cell.profilePic.sd_setImage(with: URL(string: directory.image!), placeholderImage:UIImage(named: "profile-user"))
                cell.profilePic.sd_setImage(with: URL(string: directory.image!), placeholderImage: UIImage(named: "profile-user"), options: .refreshCached) { (uiimgae, error, cache, url) in
                    
                }
            }
          
          
            return cell
            
        }
       
        return EventUpcomingCell()
        
    }
        else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "trendingEventCell", for: indexPath) as? EventTrendingCell {
               
                let directory = self.events[indexPath.row]
               
                cell.profilePic.makeRounded()
                cell.name.text = directory.name
                cell.status.text = directory.status
                if directory.image != "" {
                    
                    cell.profilePic.sd_setImage(with: URL(string: directory.image!), placeholderImage:UIImage(named: "profile-user"))
                    cell.profilePic.sd_setImage(with: URL(string: directory.image!), placeholderImage: UIImage(named: "profile-user"), options: .refreshCached) { (uiimgae, error, cache, url) in
                        
                    }
                }
              
              
                return cell
                
            }
            
            return EventTrendingCell()

        
        }

        
        
       
    }

}

