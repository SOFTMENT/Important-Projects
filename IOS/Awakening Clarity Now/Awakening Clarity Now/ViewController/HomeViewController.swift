//
//  HomeViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay on 14/05/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var profileBtn: UIImageView!
    @IBOutlet weak var dailyInsights: UIView!
    @IBOutlet weak var favouriteInsights: UIView!
    @IBOutlet weak var instagram: UIView!
    @IBOutlet weak var videos: UIView!
   
    @IBOutlet weak var settingsView: UIImageView!
    let slideVC = ProfileView()
    
  
    
    
    
    override func viewDidLoad() {
       
        let startDate = Date()
        let jf = startDate.addingTimeInterval(14400)
       

        
     
    
        let seconds = Calendar.current.dateComponents([.second], from: startDate, to: jf).second ?? 0
           
      
 
       print(seconds)
       
        
        dailyInsights.isUserInteractionEnabled = true
        favouriteInsights.isUserInteractionEnabled = true
        instagram.isUserInteractionEnabled = true
        videos.isUserInteractionEnabled = true
        
        dailyInsights.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dailyInsightsClicked)))
        favouriteInsights.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favInsightsClicked)))
        instagram.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instagramClicked)))
        videos.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(videosClicked)))
        
        settingsView.isUserInteractionEnabled = true
        settingsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingsBtnClicked)))
        
      
        
        profileBtn.isUserInteractionEnabled = true
        profileBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileBtnPressed)))
        //FETCH PRODUCT
        
        IAPManager.shared.startWith(arrayOfIds: TabBarController.productIds, sharedSecret:"9f98c36e928946e88afc0b49799be4a0")
        
        
        //Refresh Subscription
        IAPManager.shared.refreshSubscriptionsStatus {
            
        } failure: { (error) in
            
        }

        
        
    }
    
    @objc func profileBtnPressed(){
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    

   
    func updateOverlayUI() {
        let hasMebership = self.checkMembershipStatus(currentDate: TabBarController.date,identifier: TabBarController.productIds.first!)
        if hasMebership {
            let daysleft = self.membershipDaysLeft(currentDate: TabBarController.date,identifier: TabBarController.productIds.first!) + 1
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
    
   
    
    @objc func settingsBtnClicked(){
        performSegue(withIdentifier: "settingsseg", sender: nil)
    }
    
    @objc func dailyInsightsClicked(){
        tabBarController?.selectedIndex = 2
    }
    
    @objc func favInsightsClicked(){
        tabBarController?.selectedIndex = 1
        
    }
    
    @objc func instagramClicked(){
        tabBarController?.selectedIndex = 4
    }
    
    @objc func videosClicked(){
        tabBarController?.selectedIndex = 3
    }
}



extension HomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        
    
       
        return ProfilePresentationController(presentedViewController: presented, presenting: presenting,homeVC: self)
       
    }
    
    
    

}
