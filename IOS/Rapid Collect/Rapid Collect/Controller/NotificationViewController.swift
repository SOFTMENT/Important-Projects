//
//  NotificationViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 13/03/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class NotificationViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var mytableView: UITableView!
     var animationView : AnimationView?
    var root : DatabaseReference!
   var mydata : [[String : String]] = [[String : String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        mytableView.delegate  = self
        mytableView.dataSource = self
        animationView = AnimationView(name: "load")
        mytableView.rowHeight = UITableView.automaticDimension
        mytableView.estimatedRowHeight = 300
        
        root = Database.database().reference()

        animationView!.frame = self.myView.bounds
                self.myView.addSubview(animationView!)
                animationView!.play()
                animationView!.loopMode = .loop
              
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mydata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as? NotificationCell {
            cell.title.text = mydata.reversed()[indexPath.row]["title"]
            cell.desc.text = mydata.reversed()[indexPath.row]["message"]
        
        return cell
        }
        return UITableViewCell()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        
        root.child("Notification").observe(.value) { (snap) in
            self.mydata.removeAll()
            for child in snap.children {
                
                
                
                let s = child as! DataSnapshot
                let value = s.value as! [String : String]
                self.mydata.append(value)
                
                
            }
            self.animationView?.stop()
            self.myView.isHidden = true
            self.mytableView.reloadData()
            
           
        }
    }
    
    

}
