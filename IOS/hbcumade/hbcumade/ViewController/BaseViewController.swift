//
//  BaseViewController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 28/05/21.
//

import UIKit

class BaseViewController: UIViewController, TopBarDelegate {
    
    
    
    func searchBtnClicked() {
        print("SearchBtnClicked")
    }
    
    func messengerBtnClicked() {
        print("MessengerBtnClicked")
    }
    
    func classificationBtnClicked() {
        
        if tabBarController?.selectedIndex == 0 {
           
            if let homeVC = self as? HomeViewController {
                homeVC.filterPosts()
                
            }
        }
        else {
            
         
            if let navigationVC = tabBarController?.viewControllers![0] as? UINavigationController {
                if let homeVC = navigationVC.viewControllers[0] as? HomeViewController {
                    
                    homeVC.filterPosts()
                    
                    
                }
                
            }
            
            tabBarController?.selectedIndex = 0
          
        }
       
        
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "topbarseg" {
            if let topbar = segue.destination as? TopBarViewController {
            topbar.classificationDelegate = self
            
            }
            
        }
       
    }
}
