//
//  SecurityInfoViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 29/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit

class SecurityInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

     
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
    
        navigationController?.navigationBar.barTintColor = color
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
