//
//  NewsRoomViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 17/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import Lottie

class NewsRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var loadingView: UIView!
     var animationView : AnimationView?
    @IBOutlet weak var tableView: UITableView!
    var arrayData = [WordpressModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        animationView = AnimationView(name: "load")
      
        tableView.tableFooterView = UIView()
        
        
 
        // Do any additional setup after loading the view.
    }likeBtn
    
    @IBAction func backBtnTapped(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "wpcell", for: indexPath) as? WPViewCell {
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let item = arrayData[indexPath.row]
            let imgUrl = URL(string: item.thumbnail)
            cell.img.kf.setImage(with: imgUrl)
            cell.date.text = item.date
            cell.title.text = item.title
            
            return cell
        }
        
        return UITableViewCell()
        
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "shownews", sender: arrayData[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "shownews" {
            guard let wpm = sender as? WordpressModel else {
                return
            }
            
            if let dest = segue.destination as? ShowNewRoomContent {
                dest.wordpressmodel  = wpm
            }
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
          
          super.viewWillAppear(animated)

        if animationView!.isAnimationPlaying {
            animationView?.stop()
        }
        
         
          animationView!.frame = self.loadingView.bounds
          self.loadingView.addSubview(animationView!)
          animationView!.play()
          animationView!.loopMode = .loop

          
           AF.request("https://rapidcollect.co.za/wp-json/wp/v2/posts?_embed&categories=96&fields=title,content,_embedded").responseJSON { response in
                if let value = response.value {
                let data = JSON(value)
                self.arrayData.removeAll()
                for arr in data.arrayValue {
                    
                    self.arrayData.append(WordpressModel(json: arr))
         
                    
                    
                }
        
                self.animationView?.stop()
                self.loadingView.isHidden = true
                self.tableView.reloadData()
                
             
                }
            
                
            }
        
          
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
      

}


