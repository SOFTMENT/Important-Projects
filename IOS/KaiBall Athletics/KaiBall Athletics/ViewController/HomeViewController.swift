//
//  HomeViewController.swift
//  KaiBall Athletics
//
//  Created by Vijay on 22/04/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import MBProgressHUD

class HomeViewController: UIViewController {
    
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileViewBtn: UIView!
    var date : Date = Date()
    var categories = Array<Category>()

    let slideVC = OverlayView()
    let membershipOverlay = MembershipOverlay()
    private var productIds : Set<String> = ["in.softment.KaiBallAthletics.videoaccess"]

    override func viewDidLoad() {
        profileViewBtn.layer.cornerRadius = 8
       
        profileViewBtn.dropShadow()
        profileViewBtn.isUserInteractionEnabled = true
        profileViewBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPresentationController)))
      
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.headerView.frame
        rectShape.position = self.headerView.center
        rectShape.path = UIBezierPath(roundedRect: self.headerView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight ], cornerRadii: CGSize(width: 50, height: 50)).cgPath

        
        //Here I'm masking the textView's layer with rectShape layer
        self.headerView.layer.mask = rectShape
        
        self.headerText.dropShadow()
        
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        
   
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        
      
        //FETCH PRODUCT
        
        IAPManager.shared.startWith(arrayOfIds: productIds, sharedSecret:"b39194966b134b919bb081120f3d55c1")
        
        
        //Refresh Subscription
        IAPManager.shared.refreshSubscriptionsStatus {
            
        } failure: { (error) in
            
        }

        
        //CURRENT DATE FETCH
      
        URL.asyncTime { date, timezone, error in
            guard let date = date, let timezone = timezone else {
                print("Error:", error ?? "")
                return
            }
            self.date = date
            print("Date:", date.description(with: .current))  // "Date: Tuesday, July 28, 2020 at 4:27:36 AM Brasilia Standard Time\n"
            print("Timezone:", timezone)   // "Timezone: America/Sao_Paulo (current)\n"
        }
        
        //getCategoryData
        getCategoryData()
        
        
    }
        
    
    public func getCategoryData() {
        ProgressHUDShow(text: "Loading...")
        Firestore.firestore().collection("Categories").addSnapshotListener { snapshot, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                if let snapshot = snapshot {
                    self.categories.removeAll()
                    for snap in snapshot.documents {
                        if let cat = try? snap.data(as: Category.self) {
                            self.categories.append(cat)
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
    
    func updateOverlayUI() {
        let hasMebership = self.checkMembershipStatus(currentDate: date,identifier: productIds.first!)
        if hasMebership {
            let daysleft = self.membershipDaysLeft(currentDate: self.date,identifier: productIds.first!) + 1
            if daysleft > 1 {
                slideVC.goPremiumText.text = "\(daysleft) Days Left"
            }
            else {
                slideVC.goPremiumText.text = "\(daysleft) Day Left"
            }
            slideVC.accountType.text = "Premium"
            slideVC.goPremiumView.isUserInteractionEnabled = false
           
            slideVC.img.image = UIImage(named: "crown (5)")
            slideVC.membershipImg.image = UIImage(named: "clock")
            slideVC.img.makeRounded()
           
        }
        else {
            slideVC.goPremiumView.isUserInteractionEnabled = true
            slideVC.accountType.text = "Free"
            slideVC.goPremiumText.text = "Go Premium"
            slideVC.img.image = UIImage(named: "lock (4)")
            slideVC.membershipImg.image = UIImage(named: "crown (4)")
            print("Free")
        }
    }

    
    @objc func showPresentationController() {
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
      
    }
    
    func showMembershipController() {
        membershipOverlay.modalPresentationStyle = .custom
        membershipOverlay.transitioningDelegate = self
        self.present(membershipOverlay, animated: true, completion: nil)
    }
    
    func restorePurchase() {
        ProgressHUDShow(text: "Restoring...")
        IAPManager.shared.restorePurchases {
            MBProgressHUD.hide(for: self.view, animated: true)
            let hasMebership = self.checkMembershipStatus(currentDate: self.date, identifier: self.productIds.first!)
            if hasMebership {
                self.showToast(message: "Subscription Restored")
                
            }
            else {
                self.showToast(message: "No Subscription")
            }
            
        } failure: { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print("Failed")
         //   print("Restore Failed \(error?.localizedDescription ?? "")")
        }

    }
 
    
    func purchaseMembershipBtnTapped() {
            
      
        if let product = IAPManager.shared.products?.first {
            ProgressHUDShow(text: "Purchasing...")
            IAPManager.shared.purchaseProduct(product : product) {
                MBProgressHUD.hide(for: self.view, animated: true)
                if self.checkMembershipStatus(currentDate: self.date, identifier: self.productIds.first!) {
                    self.showToast(message: "Subscription Purchased")
                }
                else {
                    self.showToast(message: "Failed")
                }
               
            } failure: { (error) in
                print("Error 1")
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showToast(message: "Failed")
               
            }
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allvideoseg" {
            if let index = sender as? Int {
                if let destination = segue.destination as? AllVideosViewController {
                    destination.cat_id = self.categories[index].id
                    destination.cat_title = self.categories[index].title
                    destination.cat_index = index
                    
                }
            }
        }
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "allvideoseg", sender: indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesviewcell", for: indexPath) as? CategoriesTableViewCell {
        
            let category = categories[indexPath.row]
            cell.itemView.layer.cornerRadius = 6
            
            cell.title.text = category.title
            cell.subtitle.text = category.desc
            cell.cat_image.sd_setImage(with: URL(string: category.image), completed: nil)
            cell.cat_image.layer.cornerRadius = 6
            cell.totalVideos.text = "Videos Available : \(category.totalVideos)"
            cell.itemView.dropShadow()
            
            
          
            return cell
            
        }
       
        return CategoriesTableViewCell()
    }
    

    
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        
        if let name =  presented.nibName {
            if name != "OverlayView" {
                return MembershipPresentationController(presentedViewController: presented, presenting: presenting,homeVC: self)
            }
            
        }
       
        return PresentationController(presentedViewController: presented, presenting: presenting,homeVC: self)
       
 
    }
    
    
    

}


//        MembershipPresentationController(presentedViewController: presented, presenting: presenting, homeVC:self)


    
    

      
