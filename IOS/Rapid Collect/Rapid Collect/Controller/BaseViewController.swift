//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import StoreKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(_ name : String) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(name){
        case "home":
            print("Home\n", terminator: "")

            self.openViewControllerBasedOnIdentifier("home")
            
            break
        case "pricing":
            print("Pricing\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("web")
            
            break
            case "notification":
            print("Notification\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("notification")
            
            break
            case "contact":
            print("Contact\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("contact")
            
            break
            case "faqs":
            print("FAQS\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("web")
            
            break
            
           
            case "share":
            print("Share \n", terminator: "")
            
            self.ShareApp()
            break
            
    
            case "rate":
                       print("Rate US\n", terminator: "")
                       
                       self.openViewControllerBasedOnIdentifier("rateus")
                       
                       break
            
            case "settings":
                       print("FAQS\n", terminator: "")
                       
                       self.openViewControllerBasedOnIdentifier("settings")
                       
                       break
            
            case "exit":
                       print("Exit\n", terminator: "")
                       
                       self.createAlert(title: "Exit", message: "Do you want to close app?")
                       break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func createAlert (title:String, message:String)
      {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
          
          //CREATING ON BUTTON
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
              alert.dismiss(animated: true, completion: nil)
              exit(-1)
          }))
          
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
              alert.dismiss(animated: true, completion: nil)
             
          }))
          
          self.present(alert, animated: true, completion: nil)
      }

    
    func ShareApp(){
        let name = URL(string: "https://itunes.apple.com/us/app/myapp/idxxxxxxxx?ls=1&mt=8")
            let objectsToShare = [name]
        let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)

            self.present(activityVC, animated: true, completion: nil)
        }
    
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        self.navigationController!.pushViewController(destViewController, animated: true)
        
    }
    
    func addSlideMenuButton(){
        
      
        
        let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
        btnShowMenu.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 10  , height: 10)
        
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
       
    }

    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
       
        return defaultMenuImage;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex("-1");
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
        

//        if Temp.btnName.isEmpty {
//                menuVC.homeButton.backgroundColor = UIColor.init(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
//                  //  Doesn't exist
//              } else {
//            let name = Temp.btnName
//                switch name {
//                case "home":
//                    menuVC.homeButton.backgroundColor = UIColor.init(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
//                    break
//                case "pricing" :
//                    menuVC.pricingButton.backgroundColor = UIColor.init(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
//                    break
//
//                case "notification" :
//                    menuVC.notificationButton.backgroundColor = UIColor.init(red: 125/255, green: 186/255, blue: 227/255, alpha: 1)
//                                       break
//                case "contact" :
//                    menuVC.contactButton.backgroundColor = UIColor.init(red: 125/255, green: 186/255, blue: 227/255, alpha: 1)
//                                       break
//
//                case "faqs" :
//                    menuVC.faqs.backgroundColor = UIColor.init(red: 125/255, green: 186/255, blue: 227/255, alpha: 1)
//                                       break
//                case "rate" :
//                    menuVC.rateUs.backgroundColor = UIColor.init(red: 125/255, green: 186/255, blue: 227/255, alpha: 1)
//                                       break
//
//                case "settings" :
//                    menuVC.settings.backgroundColor = UIColor.init(red: 125/255, green: 186/255, blue: 227/255, alpha: 1)
//                    break
//
//
//                default:
//                    print("Default")
//                }
//              }
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
            }, completion:nil)
    }
}
