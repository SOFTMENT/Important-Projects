//
//  PeoplesViewController.swift
//  hbcumade
//
//  Created by Vijay on 08/04/21.
//
import UIKit

class ExploreViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var morePeople: UIButton!
    @IBOutlet weak var peopleToFollowTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var findGroupTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var findGroupTable: UITableView!
    @IBOutlet weak var peopleToFollowTable: UITableView!
    @IBOutlet weak var directorySearchEditField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var gridStack: UIStackView!


    var peoples = Array<Peoples>()
    var gropus = Array<Group>()
    override func viewDidLoad() {
        
        
        directorySearchEditField.attributedPlaceholder = NSAttributedString(string: "Search...",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        directorySearchEditField.setLeftPaddingPoints(10)
        directorySearchEditField.setRightPaddingPoints(10)
       
        //FINDGROUPTABLEVIEW
        findGroupTable.delegate = self
        findGroupTable.dataSource = self
        findGroupTable.isScrollEnabled = false
   
        self.findGroupTable.rowHeight = UITableView.automaticDimension
        self.findGroupTable.estimatedRowHeight = 44
        
  
        //FINDPEOPLETOFOLLOWTABLE
        peopleToFollowTable.delegate = self
        peopleToFollowTable.dataSource = self
        peopleToFollowTable.isScrollEnabled = false
   
        self.peopleToFollowTable.rowHeight = UITableView.automaticDimension
        self.peopleToFollowTable.estimatedRowHeight = 44
        
        
        //MOREPEOPLE
        morePeople.layer.cornerRadius = 6
        
        
        peoples.append(Peoples(name: "Vijay Rathore", information: "Mobile App Developer", image: "https://i.pravatar.cc/300"))
        peoples.append(Peoples(name: "Manoj Kumar Verma", information: "Professional Logo Designer", image: "https://i.pravatar.cc/301"))
        peoples.append(Peoples(name: "Vaibhav Sharma", information: "Businessman", image: "https://i.pravatar.cc/302"))
        peoples.append(Peoples(name: "Akshay Munya", information: "Teacher", image: "https://i.pravatar.cc/303"))
        peoples.append(Peoples(name: "Salman Khan", information: "Available", image: "https://i.pravatar.cc/304"))
        peoples.append(Peoples(name: "Akshay Kumar", information: "can't talk whatsapp only", image: "https://i.pravatar.cc/305"))
        peoples.append(Peoples(name: "Rajkumar Hirani", information: "Website Developer", image: "https://i.pravatar.cc/306"))
        peoples.append(Peoples(name: "Shashikant Bharti", information: "Artist", image: "https://i.pravatar.cc/307"))
        peoples.append(Peoples(name: "Amit Giri", information: "Singer", image: "https://i.pravatar.cc/308"))
        peoples.append(Peoples(name: "Ajay Rathore", information: "Battery about to die", image: "https://i.pravatar.cc/309"))
        peoples.append(Peoples(name: "Vermaak Petrus", information: "Professional Logo Designer", image: "https://i.pravatar.cc/310"))
        peoples.append(Peoples(name: "Krishna Yadav", information: "Can't talk whatsapp only", image: "https://i.pravatar.cc/311"))
        peoples.append(Peoples(name: "Anmol Pandey", information: "YouTuber", image: "https://i.pravatar.cc/312"))
        peoples.append(Peoples(name: "Naresh Dewra", information: "Freelancer", image: "https://i.pravatar.cc/313"))
        peoples.append(Peoples(name: "Manyank Gothi", information: "Website Developer", image: "https://i.pravatar.cc/314"))
        peoples.append(Peoples(name: "Sanju Samson", information: "Hardware Expert", image: "https://i.pravatar.cc/315"))
        
      
        
        gropus.append(Group(name: "SOFTMENT", information: "Mobile App Developer", image: "https://picsum.photos/200"))
        gropus.append(Group(name: "7RINDIA", information: "Digital Marketing", image: "https://picsum.photos/201"))
        gropus.append(Group(name: "RVCJ", information: "Entertainment", image: "https://picsum.photos/202"))
        gropus.append(Group(name: "SNAPDEAL", information: "E-Commerce", image: "https://picsum.photos/203"))
        gropus.append(Group(name: "HOTSTAR", information: "Streaming Platfrom", image: "https://picsum.photos/204"))
        gropus.append(Group(name: "FACEBOOK", information: "Social Networking", image: "https://picsum.photos/205"))
        gropus.append(Group(name: "INSTAGRAM", information: "Entertainment", image: "https://picsum.photos/206"))
        gropus.append(Group(name: "MYSIRG", information: "Education", image: "https://picsum.photos/207"))
        gropus.append(Group(name: "NAIDUNIA", information: "News Channel", image: "https://picsum.photos/208"))
        gropus.append(Group(name: "DANIK BHASKAR", information: "Food And Drink", image: "https://picsum.photos/209"))
        gropus.append(Group(name: "TIMES OF INIDA", information: "News Channel", image: "https://picsum.photos/210"))
       
        

      
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        self.findGroupTable.reloadData()
        self.findGroupTable.layoutIfNeeded()
        self.findGroupTableViewHeight.constant = CGFloat(105 * gropus.count)
        
        self.peopleToFollowTable.reloadData()
        self.peopleToFollowTable.layoutIfNeeded()
        self.peopleToFollowTableViewHeight.constant = CGFloat(105 * 3)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == findGroupTable {
            return gropus.count
        }
        
        return 3
        
      
    }
 
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == findGroupTable {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "exploreFindGroupCell", for: indexPath) as? ExploreFindGroupCell {
           
            let directory = self.gropus[indexPath.row]
           
            cell.profilePic.makeRounded()
            cell.name.text = directory.name
            cell.status.text = directory.information
            if directory.image != "" {
                
                cell.profilePic.sd_setImage(with: URL(string: directory.image!), placeholderImage:UIImage(named: "profile-user"))
                cell.profilePic.sd_setImage(with: URL(string: directory.image!), placeholderImage: UIImage(named: "profile-user"), options: .refreshCached) { (uiimgae, error, cache, url) in
                    
                }
            }
          
          
            return cell
            
        }
       
        return ExploreFindGroupCell()
        
    }
        else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "explorePeopleToFollowCell", for: indexPath) as? ExplorePeopleToFollowCell {
               
                let directory = self.peoples[indexPath.row]
               
                cell.profilePic.makeRounded()
                cell.name.text = directory.name
                cell.information.text = directory.information
                if directory.image != "" {
                    
                    cell.profilePic.sd_setImage(with: URL(string: directory.image!), placeholderImage:UIImage(named: "profile-user"))
                    cell.profilePic.sd_setImage(with: URL(string: directory.image!), placeholderImage: UIImage(named: "profile-user"), options: .refreshCached) { (uiimgae, error, cache, url) in
                        
                    }
                }
              
              
                return cell
                
            }
            
            return ExplorePeopleToFollowCell()

        
        }

        
        
       
    }

}

