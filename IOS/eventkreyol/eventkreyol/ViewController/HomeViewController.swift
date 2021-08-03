//
//  HomeViewController.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 19/07/21.
//

import UIKit
import SDWebImage




class HomeViewController: UIViewController {
    
   
 
    
    var userData : UserData!
    var categoriesModels : [CategorisModel] = [CategorisModel]()
   
    @IBOutlet weak var tableViewEvent2Height: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewEvent2: UITableView!
    
    
    @IBOutlet weak var categories_collectionView: UICollectionView!

    @IBOutlet weak var top_organiser_collectionView: UICollectionView!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var notificationBtn: UIView!
    @IBOutlet weak var searchBtn: UIView!
    @IBOutlet weak var eventNotifyView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    

    //Recommended
    @IBOutlet weak var recommendedView: UIView!
    @IBOutlet weak var recommededImage: UIImageView!
    @IBOutlet weak var recommendedTime: UILabel!
    @IBOutlet weak var recommendedTitle: UILabel!
    @IBOutlet weak var recommendedAbout: UILabel!
    @IBOutlet weak var recommendedFullView: UILabel!
    @IBOutlet weak var recommendedAgeView: UIView!
    @IBOutlet weak var recommendedGenderView: UIView!
    @IBOutlet weak var recommendedTimeView: UIView!
    @IBOutlet weak var recommendedJoinedView: UIView!
    @IBOutlet weak var recommendedPrice: UILabel!
    @IBOutlet weak var recommendedBookNowBtn: UIButton!
    @IBOutlet weak var recommendedGenderImgView: UIView!
    @IBOutlet weak var recommendedTimeImgView: UIView!
    @IBOutlet weak var recommendedAgeImgView: UIView!
    @IBOutlet weak var recommendedJoinedImgView: UIView!
    
    
    override func viewDidLoad() {
        
        guard let userdata  = UserData.data else {
            self.logout()
            return
        }
        
    
       
        self.userData = userdata
        
        let categoriesModel1 = CategorisModel()
        categoriesModel1.categoryName = "Music"
        categoriesModel1.cat_image = "musical-notes"
        
        categoriesModels.append(categoriesModel1)
        
        let categoriesModel2 = CategorisModel()
        categoriesModel2.categoryName = "Business"
        categoriesModel2.cat_image = "pie-chart"
        
        categoriesModels.append(categoriesModel2)
        
        let categoriesModel3 = CategorisModel()
        categoriesModel3.categoryName = "Art"
        categoriesModel3.cat_image = "art"
        
        categoriesModels.append(categoriesModel3)
        
        let categoriesModel4 = CategorisModel()
        categoriesModel4.categoryName = "Food & Drink"
        categoriesModel4.cat_image = "food"
        
        categoriesModels.append(categoriesModel4)
        
        let categoriesModel5 = CategorisModel()
        categoriesModel5.categoryName = "Education"
        categoriesModel5.cat_image = "education"
        
        categoriesModels.append(categoriesModel5)
        
        fullName.text  = ("Hi, \(String(describing: self.userData.fullName ?? "Eventkreyol"))")
        
        notificationBtn.layer.cornerRadius = 12
        searchBtn.layer.cornerRadius = 12
        profileImage.layer.cornerRadius = 12
        eventNotifyView.layer.cornerRadius = 12
        
        if let imageURL = userdata.profilePic {
            profileImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "profile-placeholder"), options: .continueInBackground, completed: nil)
        }
        
        
        eventNotifyView.layer.borderWidth = 1.4
        eventNotifyView.layer.borderColor = UIColor.init(red: 176/255, green: 179/255, blue: 199/255, alpha: 1).cgColor
        
        categories_collectionView.delegate = self
        categories_collectionView.dataSource = self
        
        top_organiser_collectionView.delegate = self
        top_organiser_collectionView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.contentInsetAdjustmentBehavior = .never
        definesPresentationContext = true
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 4
        
        tableViewEvent2.delegate = self
        tableViewEvent2.dataSource = self
        tableViewEvent2.isScrollEnabled = false
        tableViewEvent2.contentInsetAdjustmentBehavior = .never
        self.tableViewEvent2.rowHeight = UITableView.automaticDimension
        self.tableViewEvent2.estimatedRowHeight = 4
        
        //RECOMMENDEDVIEW
        recommendedView.layer.cornerRadius = 12
        recommendedView.dropShadow()
        recommededImage.layer.cornerRadius = 8
        
        recommendedGenderView.layer.cornerRadius = 12
        recommendedGenderView.dropShadow()
        
        recommendedAgeView.layer.cornerRadius = 12
        recommendedAgeView.dropShadow()
        
        recommendedTimeView.layer.cornerRadius = 12
        recommendedTimeView.dropShadow()
        
        recommendedJoinedView.layer.cornerRadius = 12
        recommendedJoinedView.dropShadow()
       
        recommendedBookNowBtn.layer.cornerRadius = 12
        recommendedBookNowBtn.dropShadow()

        
     
        recommendedGenderImgView.layer.cornerRadius = 12
        recommendedAgeImgView.layer.cornerRadius = 12
        recommendedTimeImgView.layer.cornerRadius = 12
        recommendedJoinedImgView.layer.cornerRadius = 12
        
        
        
        
    }
    
    public func updateTableViewHeight(){
       
        self.tableViewHeight.constant = self.tableView.contentSize.height
        self.tableView.layoutIfNeeded()
    }
    
    public func updateTableViewEvent2Height(){
       
        self.tableViewEvent2Height.constant = self.tableViewEvent2.contentSize.height
        self.tableViewEvent2.layoutIfNeeded()
    }
    

   

}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewEvent2 {
            return 16
        }
        return 4
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewEvent2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "eventviewcell", for: indexPath) as? Event_View_Cell {
                
                cell.eventView.layer.cornerRadius  = 12
                cell.eventView.dropShadow()
                
                cell.eventImage.layer.cornerRadius = 8
                
                let totalRow = tableView.numberOfRows(inSection: indexPath.section)
                if(indexPath.row == totalRow - 1)
                        {
                            DispatchQueue.main.async {
                                self.updateTableViewEvent2Height()
                            }
                        }
                return cell
            }
            
            return Event_View_Cell()
        }
        else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "eventviewcell", for: indexPath) as? Event_View_Cell {
                
                cell.eventView.layer.cornerRadius  = 12
                cell.eventView.dropShadow()
                
                cell.eventImage.layer.cornerRadius = 8
                
                let totalRow = tableView.numberOfRows(inSection: indexPath.section)
                if(indexPath.row == totalRow - 1)
                        {
                            DispatchQueue.main.async {
                                self.updateTableViewHeight()
                            }
                        }
                return cell
            }
            
            return Event_View_Cell()
        }
 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventseg", sender: nil)
    }
    
    
    
}


extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == top_organiser_collectionView {
           return 10
        }
        else {
          return categoriesModels.count
        }
  
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == top_organiser_collectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toporganisercell", for: indexPath) as? Top_Organiser_Cell {
                
            
                cell.view.layer.cornerRadius = 12
                cell.view.dropShadow()
                
                cell.profile_image.layer.cornerRadius = 8
                
                cell.followBtn.layer.cornerRadius = 6
                return cell
            }
            
            return Top_Organiser_Cell()
        }
        else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category_cell", for: indexPath) as? Categories_View_Cell {
                
                
                let categoryModel = categoriesModels[indexPath.row]
                cell.view.layer.cornerRadius = 12
                cell.view.dropShadow()
                cell.categoryName.text = categoryModel.categoryName!
                cell.imageView.image  = UIImage(named: categoryModel.cat_image!)
                return cell
            }
            
            return Categories_View_Cell()
        }
       
    
    }
    
    
}
