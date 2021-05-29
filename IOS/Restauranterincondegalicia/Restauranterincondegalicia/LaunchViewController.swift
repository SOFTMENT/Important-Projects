//
//  LaunchViewController.swift
//  Restauranterincondegalicia
//
//  Created by Vijay on 09/04/21.
//  Copyright © 2021 OriginalDevelopment. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class LaunchViewController: UIViewController {
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadVideo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.performSegue(withIdentifier: "homeVC", sender: nil)
        }
    }

    private func loadVideo() {

        //this line is important to prevent background music stop
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }

        let path = Bundle.main.path(forResource: "NEON Art Animation for Manuelvalenciad", ofType:"mp4")

        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)
        player?.isMuted = true
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.zPosition = -1

        self.view.layer.addSublayer(playerLayer)

        player?.seek(to: CMTime.zero)
        player?.play()
        
        
    }

    
    
 
}

