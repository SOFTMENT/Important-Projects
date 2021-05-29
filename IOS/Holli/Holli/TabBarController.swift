//
//  TabBarController.swift
//  Sweet Tooth
//
//  Created by Vijay Rathore on 20/03/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//
import UIKit
import Firebase


class TabBarController: UITabBarController, UITabBarControllerDelegate {

  
    
    var tabBarItems = UITabBarItem()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate  = self
        
        //SUBSCRIBE TO TOPIC
        Messaging.messaging().subscribe(toTopic: "holli"){ error in
                    if error == nil{
                        print("Subscribed to topic")
                    }
                    else{
                        print("Not Subscribed to topic")
                    }
                }
      
        
      
        
        
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 255/256, green: 92/256, blue: 92/256, alpha: 1)], for: .selected)
        
        let selectedImage1 = UIImage(named: "icons8-home-100-8")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "icons8-home-100-7")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = deSelectedImage1
        tabBarItems.selectedImage = selectedImage1
        
    
        
       
        let selectedImage5 = UIImage(named: "icons8-share-100-3")?.withRenderingMode(.alwaysOriginal)
             let deSelectedImage5 = UIImage(named: "icons8-share-100")?.withRenderingMode(.alwaysOriginal)
             tabBarItems = self.tabBar.items![1]
             tabBarItems.image = deSelectedImage5
             tabBarItems.selectedImage = selectedImage5
            
             
        
        let selectedImage6 = UIImage(named: "icons8-star-100-32")?.withRenderingMode(.alwaysOriginal)
             let deSelectedImage6 = UIImage(named: "icons8-star-100-2")?.withRenderingMode(.alwaysOriginal)
             tabBarItems = self.tabBar.items![2]
             tabBarItems.image = deSelectedImage6
             tabBarItems.selectedImage = selectedImage6
            
             
        
        let selectedImage7 = UIImage(named: "icons8-exit-100-3")?.withRenderingMode(.alwaysOriginal)
             let deSelectedImage7 = UIImage(named: "icons8-exit-100-2")?.withRenderingMode(.alwaysOriginal)
             tabBarItems = self.tabBar.items![3]
             tabBarItems.image = deSelectedImage7
             tabBarItems.selectedImage = selectedImage7
            
             
            
            
        }
        
        
      
    
    
   
    
}
