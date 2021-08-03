//
//  TabBarController.swift
//  Awakening Clarity Now
//
//  Created by Vijay on 14/05/21.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    
    @IBOutlet weak var tabbar: UITabBar!
    var tabBarItems = UITabBarItem()
    static var date : Date = Date()
    static var productIds : Set<String> = ["in.softment.dailyinsights"]
    let membershipOverlay = MembershipViewController()
    override func viewDidLoad() {
        setTransparentTabbar()
        self.delegate  = self
       
        
        //CURRENT DATE FETCH
      
        URL.asyncTime { date, timezone, error in
            guard let date = date, let timezone = timezone else {
                print("Error:", error ?? "")
                return
            }
            TabBarController.date = date
            print("Date:", date.description(with: .current))  // "Date: Tuesday, July 28, 2020 at 4:27:36 AM Brasilia Standard Time\n"
            print("Timezone:", timezone)   // "Timezone: America/Sao_Paulo (current)\n"
        }
        
        
        let selectedImage1 = UIImage(named: "home2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.tag = 0
        tabBarItems.image = deSelectedImage1
        tabBarItems.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "fav2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "fav")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![1]
        tabBarItems.tag = 1
        tabBarItems.image = deSelectedImage2
        tabBarItems.selectedImage = selectedImage2
        
        let selectedImage3 = UIImage(named: "insight2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "insight")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![2]
        tabBarItems.tag = 2
        tabBarItems.image = deSelectedImage3
        tabBarItems.selectedImage = selectedImage3
        
        let selectedImage4 = UIImage(named: "video2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage4 = UIImage(named: "video")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![3]
        tabBarItems.tag = 3
        tabBarItems.image = deSelectedImage4
        tabBarItems.selectedImage = selectedImage4
        
        let selectedImage5 = UIImage(named: "IG Feed2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage5 = UIImage(named: "IG Feed-1")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![4]
        tabBarItems.tag = 4
        tabBarItems.image = deSelectedImage5
        tabBarItems.selectedImage = selectedImage5
       
    }
    
    func setTransparentTabbar() {
        tabbar.shadowImage = UIImage()
      //  tabbar.clipsToBounds = true
        tabbar.backgroundImage = UIImage()
        tabbar.backgroundColor = UIColor.clear
        tabbar.barTintColor = UIColor.clear
        
       
        
        
    }
    
   
  
 
    

    func showMembershipController() {
       
        membershipOverlay.modalPresentationStyle = .custom
        membershipOverlay.transitioningDelegate = self
        self.present(membershipOverlay, animated: true, completion: nil)
    }
    
    func restorePurchase() {
        ProgressHUDShow(text: "Restoring...")
        IAPManager.shared.restorePurchases {
            self.ProgressHUDHide()
            
            let hasMebership = self.checkMembershipStatus(currentDate: TabBarController.date , identifier: TabBarController.productIds.first!)
            
            if hasMebership {
                self.showToast(message: "Subscription Restored")
                
            }
            else {
                self.showToast(message: "No Subscription Found")
            }
            
        } failure: { (error) in
           
            self.ProgressHUDHide()
            self.showToast(message: "No Subscription Found")
        }

    }
 
    
    func purchaseMembershipBtnTapped() {
            
        if let product = IAPManager.shared.products?.first {
            ProgressHUDShow(text: "Purchasing...")
            IAPManager.shared.purchaseProduct(product : product) {
                self.ProgressHUDHide()
                if self.checkMembershipStatus(currentDate: TabBarController.date, identifier: TabBarController.productIds.first!) {
                    self.showToast(message: "Subscription Purchased")
                }
                else {
                    self.showToast(message: "Failed")
                }
               
            } failure: { (error) in
                print("Error 1")
                self.ProgressHUDHide()
                self.showToast(message: "Failed")
               
            }
        }

    }
    
}



extension TabBarController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        
       
                return MembershipPresentationController(presentedViewController: presented, presenting: presenting,homeVC: self)
            }

        
       
      
       
    
    
    
    

}
