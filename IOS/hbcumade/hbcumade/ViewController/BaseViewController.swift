//
//  BaseViewController.swift
//  hbcumade
//
//  Created by Vijay Rathore on 28/05/21.
//

import UIKit

class BaseViewController: UIViewController, TopBarDelegate {
    
    
    
    func searchBtnClicked() {
        if tabBarController?.selectedIndex == 1 {
           
            if let networkVC = self as? NetworkViewController {
              
                networkVC.searchEditTextActivate()
                
            }
        }
        else {
           
          
         
//            if let navigationVC = tabBarController?.viewControllers![1] as? UINavigationController {
//                if let networkVC = navigationVC.viewControllers[0] as? NetworkViewController {
//
//
//
//
//                }
//
//            }
//
            
            tabBarController?.selectedIndex = 1
           
        }
       
    }
    
    func messengerBtnClicked() {

        tabBarController?.selectedIndex = 3
    }
    
    func classificationBtnClicked() {
        
        if tabBarController?.selectedIndex == 0 {
           
            if let homeVC = self as? HomeViewController {
              
                homeVC.reloadTableView()
                
            }
        }
        else {
          
         
            if let navigationVC = tabBarController?.viewControllers![0] as? UINavigationController {
                if let homeVC = navigationVC.viewControllers[0] as? HomeViewController {
                    
                    homeVC.reloadTableView()
                  
                    
                    
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
