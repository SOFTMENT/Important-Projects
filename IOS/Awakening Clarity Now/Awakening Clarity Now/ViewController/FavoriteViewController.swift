//
//  FavoriteViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 22/05/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import SDWebImage

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var noFavoriteAvailable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsBtn: UIImageView!
    var favoritesInsights = Array<FavoriteInsightsModel>()
  
    override func viewDidLoad() {
        
        
        //SettingsBtn
        settingsBtn.isUserInteractionEnabled = true
        settingsBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingsBtnClicked)))
        
        tableView.delegate = self
        tableView.dataSource = self
        let hasMebership = self.checkMembershipStatus(currentDate: TabBarController.date,identifier: TabBarController.productIds.first!)
   
    
        
        if (UserModel.data!.emailAddress == "fredsdavis@gmail.com" || UserModel.data!.emailAddress == "jeffreykgross@gmail.com" || UserModel.data!.emailAddress == "iamvijay67@gmail.com")  ||  hasMebership {
            getFavoriteInsights()
        }
       
    }
    
 
    public func getFavoriteInsights(){
        
        ProgressHUDShow(text: "")
        Firestore.firestore().collection("Users").document(UserModel.data!.uid).collection("Favorites").order(by: "date",descending: true).addSnapshotListener { snap, error in
            
            self.ProgressHUDHide()
            if error == nil {
                self.favoritesInsights.removeAll()
                if let snap = snap {
                    for s in snap.documents {
                        if let favoriteInsight = try? s.data(as: FavoriteInsightsModel.self) {
                            self.favoritesInsights.append(favoriteInsight)
                        }
                    }
                    
                }
                self.tableView.reloadData()
                
        }
            
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let hasMebership = self.checkMembershipStatus(currentDate: TabBarController.date,identifier: TabBarController.productIds.first!)
        
        if (UserModel.data!.emailAddress != "fredsdavis@gmail.com" && UserModel.data!.emailAddress != "jeffreykgross@gmail.com" )  && !hasMebership {
            if let tabVC = tabBarController as? TabBarController {
                tabVC.selectedIndex = 0
                tabVC.showMembershipController()
                
            }
        }
        
    }

  
    @objc func settingsBtnClicked(){
        performSegue(withIdentifier: "settingsseg", sender: nil)
    }
}


extension FavoriteViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favoritesInsights.count > 0 {
            noFavoriteAvailable.isHidden = true
            
        }
        else {
            noFavoriteAvailable.isHidden = false
        }
       
        return favoritesInsights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favoritecell", for: indexPath) as? FavoriteCell{
            
            cell.quoteImage.layer.cornerRadius = 8
            let fav = favoritesInsights[indexPath.row]
            cell.quote.text = fav.quotes
            cell.quoteImage.sd_setImage(with: URL(string: fav.image), placeholderImage: UIImage(named: "beach"), options: .continueInBackground, completed: nil)
            let day = Calendar.current.component(.day, from: fav.date)
            let month = Calendar.current.monthSymbols[Calendar.current.component(.month, from: fav.date) - 1]
            
            cell.date.text = String(day)
            cell.month.text = month
            return cell
        }
        return FavoriteCell()
    }
    
    
    
}
