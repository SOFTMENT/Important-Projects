//
//  SettingsTabViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 14/03/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit

class SettingsTabViewController: UIViewController {
   
    @IBOutlet weak var noti: UISwitch!
    @IBOutlet weak var blackTheme: UIView!
    @IBOutlet weak var blueTheme: UIView!
    
    @IBOutlet weak var greenTheme: UIView!
    @IBOutlet weak var redTheme: UIView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var termsandconditionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        let preferences = UserDefaults.standard

        let currentLevelKey = "notification"

        if preferences.object(forKey: currentLevelKey) == nil {
            noti.isOn = true
            
        } else {
            let currentLevel = preferences.bool(forKey: currentLevelKey)
            if currentLevel {
                noti.isOn = true
            }
            else {
                noti.isOn = false
            }
            
        }
        
        
        
        
        blackTheme.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blackTap)))
        
        blueTheme.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blueTap)))
        
        greenTheme.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(greenTap)))
        
        redTheme.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redTap)))

        aboutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(about)))

        termsandconditionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(terms)))
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        
        tabBarController?.selectedIndex = 0
        
    }
    
     @objc func about() {
         Temp.btnName = "about"
          gotoWeb()
         
     }
     
     @objc func terms() {
         Temp.btnName = "terms"
        gotoWeb()
        
     }
     func gotoWeb() {
          let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "web")
                 self.navigationController!.pushViewController(destViewController, animated: true)
        }
    
    @objc func blackTap() {
       
        writeColor(colorName: "black")
       viewWillAppear(true)
    }
    
    @objc func blueTap() {
        writeColor(colorName: "blue")
       viewWillAppear(true)
    }

    @objc func greenTap() {
        writeColor(colorName: "green")
        viewWillAppear(true)
         
      }
    
    @objc func redTap() {
        writeColor(colorName: "red")
            viewWillAppear(true)
         }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func writeColor(colorName : String) {
        let preferences = UserDefaults.standard

        let colorKey = "colorKey"
        
        preferences.set(colorName, forKey: colorKey)

        preferences.synchronize()

    
    }
    
       override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
     
            
            
            
            var  color = UIColor.init(red: 237/255, green: 27/255, blue: 37/255, alpha: 1)
            
            let preferences = UserDefaults.standard

                 let colorKey = "colorKey"

                 if preferences.object(forKey: colorKey) == nil {
                 
                 } else {
                     
                     let currentLevel = preferences.string(forKey: colorKey)
                     
                     switch currentLevel {
                     case "black":
                         color = UIColor.init(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
                         break;
                         
                     case "green" :
                         color = UIColor.init(red: 22/255, green: 74/255, blue: 42/255, alpha: 1)
                         
                         break
                         
                     case "red" :
                color = UIColor.init(red: 237/255, green: 27/255, blue: 37/255, alpha: 1)
                         
                         break
                     case "blue" :
                         color = UIColor.init(red: 34/255, green: 48/255, blue: 81/255, alpha: 1)
                     
                         break
                         
                     default:
                         print("")
                     }
                 }
            tabBarController?.tabBar.barTintColor = color
            navigationController?.navigationBar.barTintColor = color
        }
    
    @IBAction func notiChanged(_ sender: Any) {
    
        let preferences = UserDefaults.standard

        if noti.isOn {
           preferences.setValue(true, forKey: "notification")
        }
        else {
            preferences.setValue(false, forKey: "notification")
        }
       //  Save to disk
        let didSave = preferences.synchronize()

        if !didSave {
            //  Couldn't save (I've never seen this happen in real world testing)
        }
    
    }
    
    

}
