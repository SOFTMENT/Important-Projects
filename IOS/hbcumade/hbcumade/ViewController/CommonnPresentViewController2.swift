//
//  CommonnPresentViewController2.swift
//  hbcumade
//
//  Created by Vijay on 18/04/21.
//


import UIKit

class CommonPresentViewController2 : BaseViewController, UINavigationControllerDelegate{
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if let tabBarController = self.tabBarController as? TabBarController {
           
            let vc =  tabBarController.viewControllers![2]
          
                if let nav = vc as? UINavigationController  {
                  
                    if (nav.topViewController is CommonPresentViewController2) {
                      
                        if (Constants.previousSelectedTabIndex == 2){
                          
                            nav.popToRootViewController(animated: false)
                        }
                        else {
                          
                        }
                       
                    }
                    
                }
           
            
            tabBarController.showOverlayView()
        }
    
        tabBarController?.selectedIndex = Constants.previousSelectedTabIndex
        
        
        
        let tabBarItems = tabBarController?.tabBar.items![Constants.previousSelectedTabIndex]
        
        if Constants.previousSelectedTabIndex  == 0{
            tabBarItems!.selectedImage = UIImage(named: "icons8-home-100")?.withRenderingMode(.alwaysOriginal)
        }
       else if Constants.previousSelectedTabIndex  == 1{
        tabBarItems!.selectedImage = UIImage(named: "icons8-add-user-group-man-man-96")?.withRenderingMode(.alwaysOriginal)
        }
       else if Constants.previousSelectedTabIndex  == 3{
        tabBarItems!.selectedImage = UIImage(named: "icons8-facebook-messenger-96")?.withRenderingMode(.alwaysOriginal)
        }
        else if Constants.previousSelectedTabIndex  == 4{
            tabBarItems!.selectedImage = UIImage(named: "icons8-user-96")?.withRenderingMode(.alwaysOriginal)
        }
        
        
        
        let tabBarItems1 = tabBarController?.tabBar.items![2]
        tabBarItems1!.image = UIImage(named: "h")?.withRenderingMode(.alwaysOriginal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewprofileseg" {
            if let destinvationVC = segue.destination as? MainProfile {
                destinvationVC.userData = UserData.data
            }
        }
    }
}

