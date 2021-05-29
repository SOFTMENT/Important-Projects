//
//  ViewController.swift
//  Oh Crepe & Waffles
//
//  Created by Vijay on 06/05/21.
//


import UIKit
import AMTabView
import Firebase
import FirebaseMessaging

class ViewController: AMTabsViewController {

  // MARK: - ViewController lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setTabsControllers()

    selectedTabIndex = 2
    
    //SUBSCRIBE TO TOPIC
    Messaging.messaging().subscribe(toTopic: "SOFTMENT"){ error in
                if error == nil{
                    print("Subscribed to topic")
                }
                else{
                    print("Not Subscribed to topic")
                }
            }
  }

  private func setTabsControllers() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let bookViewController = storyboard.instantiateViewController(withIdentifier: "bookVC")
    let aboutUsViewController = storyboard.instantiateViewController(withIdentifier: "aboutus")
    let menuViewController = storyboard.instantiateViewController(withIdentifier: "menu")
    let eventViewController = storyboard.instantiateViewController(withIdentifier: "event")
    let chatViewController = storyboard.instantiateViewController(withIdentifier: "chatVC")
 
    viewControllers = [
        bookViewController,
      aboutUsViewController,
      menuViewController,
      eventViewController,
        chatViewController
  
    ]
  }

    
  
}


