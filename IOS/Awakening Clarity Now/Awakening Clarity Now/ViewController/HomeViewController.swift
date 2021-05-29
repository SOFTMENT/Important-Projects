//
//  HomeViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay on 14/05/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var dailyInsights: UIView!
    @IBOutlet weak var favouriteInsights: UIView!
    @IBOutlet weak var instagram: UIView!
    @IBOutlet weak var videos: UIView!
    
    @IBOutlet weak var settingsView: UIImageView!
    
    
    override func viewDidLoad() {
        
        dailyInsights.isUserInteractionEnabled = true
        favouriteInsights.isUserInteractionEnabled = true
        instagram.isUserInteractionEnabled = true
        videos.isUserInteractionEnabled = true
        
        dailyInsights.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dailyInsightsClicked)))
        favouriteInsights.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favInsightsClicked)))
        instagram.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instagramClicked)))
        videos.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(videosClicked)))
        
        settingsView.isUserInteractionEnabled = true
        settingsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingsBtnClicked)))
        
        
    }
    
    
    @objc func settingsBtnClicked(){
        performSegue(withIdentifier: "settingsseg", sender: nil)
    }
    
    @objc func dailyInsightsClicked(){
        tabBarController?.selectedIndex = 2
    }
    
    @objc func favInsightsClicked(){
        tabBarController?.selectedIndex = 1
        
    }
    
    @objc func instagramClicked(){
        tabBarController?.selectedIndex = 4
    }
    
    @objc func videosClicked(){
        tabBarController?.selectedIndex = 3
    }
}
