//
//  ViewController.swift
//  Admin Oh Crepe & Waffles
//
//  Created by Vijay on 07/05/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var addDish: UIButton!
    @IBOutlet weak var addEvent: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDish.isUserInteractionEnabled = true
        
        addDish.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addDishBtnTapped)))
        
        addEvent.isUserInteractionEnabled = true
        addEvent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addEventBtnTapped)))
        
    }


    @objc func addDishBtnTapped() {
        
        performSegue(withIdentifier: "menuseg", sender: nil)
    }
    
    @objc func addEventBtnTapped() {
        performSegue(withIdentifier: "eventseg", sender: nil)
    }
    
    
    
    @IBAction func sendPushNotification(_ sender: Any) {
        sendPushNotification()
    }
}

