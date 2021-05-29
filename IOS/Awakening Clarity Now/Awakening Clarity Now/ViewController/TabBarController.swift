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
    
    override func viewDidLoad() {
        setTransparentTabbar()
        self.delegate  = self
       
        let selectedImage1 = UIImage(named: "home2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = deSelectedImage1
        tabBarItems.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "fav2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "fav")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![1]
        tabBarItems.image = deSelectedImage2
        tabBarItems.selectedImage = selectedImage2
        
        let selectedImage3 = UIImage(named: "insight2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "insight")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![2]
        tabBarItems.image = deSelectedImage3
        tabBarItems.selectedImage = selectedImage3
        
        let selectedImage4 = UIImage(named: "video2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage4 = UIImage(named: "video")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![3]
        tabBarItems.image = deSelectedImage4
        tabBarItems.selectedImage = selectedImage4
        
        let selectedImage5 = UIImage(named: "insta2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage5 = UIImage(named: "insta")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![4]
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
}
