//
//  ConnectViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 14/03/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {

    
    @IBOutlet weak var navigationBar: UINavigationBar!

    @IBOutlet weak var youtube: UIView!
    @IBOutlet weak var twitter: UIView!
    @IBOutlet weak var facebook: UIView!
    @IBOutlet weak var instagram: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        youtube.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(youtubeOpen)))
        twitter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(twitterOpen)))
        facebook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facebookOpen)))
        instagram.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instagramOpen)))
        
        

        // Do any additional setup after loading the view.
    }
    
    @objc func facebookOpen() {
        UIApplication.tryURL(urls: [
        "fb://profile/RapidCollectRSA", // App
        "http://www.facebook.com/RapidCollectRSA" // Website if app fails
        ])
    }
    
    @objc func twitterOpen() {
        
        let screenName =  "Rapid_Collect"
          let appURL = URL(string: "twitter://user?screen_name=\(screenName)")!
          let webURL = URL(string: "https://twitter.com/\(screenName)")!

          if UIApplication.shared.canOpenURL(appURL as URL) {
              if #available(iOS 10.0, *) {
                  UIApplication.shared.open(appURL)
              } else {
                  UIApplication.shared.openURL(appURL)
              }
          } else {
              //redirect to safari because the user doesn't have Instagram
              if #available(iOS 10.0, *) {
                  UIApplication.shared.open(webURL)
              } else {
                  UIApplication.shared.openURL(webURL)
              }
          }
        
    }
    
    @objc func youtubeOpen() {
        
        let YoutubeUser =  "UC_KDLi644TdNzJi35-__CYg"
           let appURL = NSURL(string: "youtube://www.youtube.com/channel/\(YoutubeUser)")!
           let webURL = NSURL(string: "https://www.youtube.com/channel/\(YoutubeUser)")!
           let application = UIApplication.shared

           if application.canOpenURL(appURL as URL) {
               application.open(appURL as URL)
           } else {
               // if Youtube app is not installed, open URL inside Safari
               application.open(webURL as URL)
           }
        
    }
    
    @objc func instagramOpen() {
        
     let Username =  "rapid_collect" // Your Instagram Username here
     let appURL = URL(string: "instagram://user?username=\(Username)")!
     let application = UIApplication.shared

     if application.canOpenURL(appURL) {
         application.open(appURL)
     } else {
         // if Instagram app is not installed, open URL inside Safari
         let webURL = URL(string: "https://instagram.com/\(Username)")!
         application.open(webURL)
     }
        
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
        
        if #available(iOS 13.0, *) {
         
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let statusBarHeight: CGFloat = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = color
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = color
        }
        
        navigationBar.barTintColor = color
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


extension UIApplication {
    class func tryURL(urls: [String]) {
            let application = UIApplication.shared
            for url in urls {
                if application.canOpenURL(URL(string: url)!) {
                    //application.openURL(URL(string: url)!)
                    application.open(URL(string: url)!, options: [:], completionHandler: nil)
                    return
                }
            }
        }
}
