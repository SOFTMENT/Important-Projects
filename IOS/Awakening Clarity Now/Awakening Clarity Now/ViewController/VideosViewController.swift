//
//  VideosViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay on 14/05/21.
//

import UIKit
import AVKit

class VideosViewController: UIViewController {
    
    @IBOutlet weak var settingsBtn: UIImageView!
    
    
    @IBOutlet weak var homecoming: UIView!
    @IBOutlet weak var selfInquery: UIView!
    @IBOutlet weak var lookingGlass: UIView!
    
    @IBOutlet weak var selfInqueryPlay: UIImageView!
    @IBOutlet weak var lookingGlassPlay: UIImageView!
    @IBOutlet weak var homecomingPlay: UIImageView!
    override func viewDidLoad() {
        
        homecoming.layer.cornerRadius = 12
        selfInquery.layer.cornerRadius = 12
        lookingGlass.layer.cornerRadius = 12
        
        selfInqueryPlay.isUserInteractionEnabled = true
        lookingGlassPlay.isUserInteractionEnabled = true
        homecomingPlay.isUserInteractionEnabled = true
        
        selfInqueryPlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfInqueryVideoPlay)))
        lookingGlassPlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lookingGlassVideoPlay)))
        homecomingPlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(homecomingVideoPlay)))
        
        //SettingsBtn
        settingsBtn.isUserInteractionEnabled = true
        settingsBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingsBtnClicked)))
    }
    
    @objc func settingsBtnClicked(){
        performSegue(withIdentifier: "settingsseg", sender: nil)
    }
    
    @objc func homecomingVideoPlay(){
        playVideo(url: "https://softment.in/AwakeningClarityNow/homecoming.mp4")
    }
    
    @objc func lookingGlassVideoPlay(){
        playVideo(url: "https://softment.in/AwakeningClarityNow/looking-glass.mp4")
    }
    
    @objc func selfInqueryVideoPlay(){
        playVideo(url: "https://softment.in/AwakeningClarityNow/selfinquiry.mp4")
    }
    
    func playVideo(url : String) {
        let player = AVPlayer(url: URL(string: url)!)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            vc.player?.play()
        }
    }
}
