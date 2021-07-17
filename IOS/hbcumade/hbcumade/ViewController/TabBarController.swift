//
//  TabBarController.swift
//  hbcumade
//
//  Created by Vijay on 23/03/21.
//

import UIKit


class TabBarController: UITabBarController, UITabBarControllerDelegate {

    
    
    
    var tabBarItems = UITabBarItem()

    let slideVC = OverlayView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate  = self
   

        // increment received number by one
        let standard = UserDefaults.standard
        var count  = standard.integer(forKey: "launchCount")
        count = count + 1
        standard.set(count, forKey:"launchCount")
        standard.synchronize()
        
        let selectedImage1 = UIImage(named: "icons8-home-100-3")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "icons8-home-100")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = deSelectedImage1
        tabBarItems.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "icons8-add-user-group-man-man-96-2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "icons8-add-user-group-man-man-96")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![1]
        tabBarItems.image = deSelectedImage2
        tabBarItems.selectedImage = selectedImage2
        
        let selectedImage3 = UIImage(named: "h")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "hwhite")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![2]
        tabBarItems.image = deSelectedImage3
        tabBarItems.selectedImage = selectedImage3
        
        
        let selectedImage11 = UIImage(named: "comment-4")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage11 = UIImage(named: "comment-2")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![3]
        tabBarItems.image = deSelectedImage11
        tabBarItems.selectedImage = selectedImage11

        
        let selectedImage4 = UIImage(named: "icons8-user-96-2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage4 = UIImage(named: "icons8-user-96")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![4]
        tabBarItems.image = deSelectedImage4
        tabBarItems.selectedImage = selectedImage4
        
       
       
        Constants.tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
        Constants.safeAreaHeight = self.view.safeAreaFrame
   
    }
    
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == self.tabBar.items![4] {
            
            item.selectedImage = UIImage(named: "icons8-user-96-2")?.withRenderingMode(.alwaysOriginal)
            Constants.previousSelectedTabIndex = 4
            
        }
        else if item == self.tabBar.items![3] {
            item.selectedImage = UIImage(named: "comment-4")?.withRenderingMode(.alwaysOriginal)
            Constants.previousSelectedTabIndex = 3

        }
        else if item == self.tabBar.items![2] {
           
        }
        else if item == self.tabBar.items![1] {
            item.selectedImage = UIImage(named: "icons8-add-user-group-man-man-96-2")?.withRenderingMode(.alwaysOriginal)
            Constants.previousSelectedTabIndex = 1
        }
        else if item == self.tabBar.items![0] {
            item.selectedImage = UIImage(named: "icons8-home-100-3")?.withRenderingMode(.alwaysOriginal)
            Constants.previousSelectedTabIndex = 0
        }
    }
    
    
     public func showOverlayView() {
        
       
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        if !slideVC.isBeingPresented{
            self.present(slideVC, animated: true, completion: nil)
        }
      
        self.selectedIndex = 0
        
    }
    
   
}



extension TabBarController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    
    

}
      

