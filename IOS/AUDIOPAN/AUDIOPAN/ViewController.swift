//
//  ViewController.swift
//  AUDIOPAN
//
//  Created by Vijay on 27/04/21.
//

import UIKit
import AVFoundation
import MobileCoreServices
import MediaPlayer
import Lottie
import VerticalSlider

class ViewController: UIViewController, UIDocumentPickerDelegate,UINavigationControllerDelegate {
    var player: AVAudioPlayer?
    @IBOutlet weak var lottieAnim1: AnimationView!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var playPause1: UIImageView!
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var startTime1: UILabel!
    @IBOutlet weak var endTime1: UILabel!
    @IBOutlet weak var volumeSlider1: VerticalSlider!
    
    @IBOutlet weak var volumeRighSlider1: VerticalSlider!
    var timer1 = Timer()
    
    var player2: AVAudioPlayer?
    @IBOutlet weak var lottieAnim2: AnimationView!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var playPause2: UIImageView!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var startTime2: UILabel!
    @IBOutlet weak var volumeSlider2: VerticalSlider!
    
    @IBOutlet weak var volumeRightSlider2: VerticalSlider!
    @IBOutlet weak var endTime2: UILabel!
    var timer2 = Timer()
    
    
    @IBOutlet weak var mainView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.lottieAnim1.loopMode = .loop
        playPause1.isUserInteractionEnabled = true
        playPause1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playAudio1)))
        volumeSlider1.addTarget(self, action: #selector(volumne1SliderChanged), for: .valueChanged)

        slider1.addTarget(self, action: #selector(player1SliderChanged), for: .valueChanged)
        scheduledTimerWithTimeInterval1()
        
        
        self.lottieAnim2.loopMode = .loop
        playPause2.isUserInteractionEnabled = true
        playPause2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playAudio2)))
        volumeSlider2.addTarget(self, action: #selector(volumne2SliderChanged), for: .valueChanged)
        slider2.addTarget(self, action: #selector(player2SliderChanged), for: .valueChanged)
        scheduledTimerWithTimeInterval2()
    }
    
    func scheduledTimerWithTimeInterval1(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    func scheduledTimerWithTimeInterval2(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting2), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        guard let player = player else { return }
        if !player.isPlaying {
            playPause1.image = UIImage(named: "play (1)")
        }
        slider1.value = Float(player.currentTime)
        let seconds = Int(player.currentTime) % 60 ;
        let minutes =  Int(player.currentTime / 60 ) % 60;
        
        startTime1.text = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
       
      
        
    }
    
    @objc func updateCounting2(){
        guard let player = player2 else { return }
        if !player.isPlaying {
            playPause2.image = UIImage(named: "play (1)")
        }
        slider2.value = Float(player.currentTime)
        let seconds = Int(player.currentTime) % 60 ;
        let minutes =  Int(player.currentTime / 60 ) % 60;
        
        startTime2.text = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
       
      
        
    }
    
    @IBAction func equalTap(_ sender: Any) {
        self.performSegue(withIdentifier: "equal", sender: nil)
    }
    @objc func player1SliderChanged() {
        
        guard let player = player else { return }
        player.currentTime = TimeInterval(slider1.value)
    }
    
    @objc func volumne1SliderChanged() {
        
        guard let player = player else { return }
        player.pan = volumeSlider1.value
        
    }
    
  

    @objc func playAudio1() {
        
        guard let player = player else { return }
        
        if player.isPlaying {
            lottieAnim1.pause()
            playPause1.image = UIImage(named: "play (1)")
            player.pause()
        }
        else {
            lottieAnim1.play()
            playPause1.image = UIImage(named: "pause")
            player.play()
        }
       
    }
    
    @objc func player2SliderChanged() {
        
        guard let player = player2 else { return }
        player.currentTime = TimeInterval(slider2.value)
    }
    
    @objc func volumne2SliderChanged() {
        
        guard let player = player2 else { return }
        player.pan = volumeSlider2.value
    }

   
    
    @objc func playAudio2() {
        
        guard let player = player2 else { return }
        
        if player.isPlaying {
            lottieAnim2.pause()
            playPause2.image = UIImage(named: "play (1)")
            player.pause()
        }
        else {
            lottieAnim2.play()
            playPause2.image = UIImage(named: "pause")
            player.play()
        }
       
    }
    
    
    @IBAction func importAudioBtnTapped(_ sender: Any) {
       
        
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypeAudio),String(kUTTypeMPEG4Audio)], in: .import)
            importMenu.delegate = self
            self.present(importMenu, animated: true, completion: nil)
                
        }
    
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            
            playSound(url: urls.first!)
            playSound2(url: urls.first!)
               
        }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func playSound(url : URL) {
       // guard let url = Bundle.main.url(forResource: "soundName", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            
            slider1.maximumValue = Float(player!.duration)
            title1.text = url.lastPathComponent
            let seconds = Int(slider1.maximumValue ) % 60 ;
            let  minutes =  Int(slider1.maximumValue / 60 ) % 60;
            endTime1.text = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
            
            
            mainView.isHidden = false
            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */


        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSound2(url : URL) {
       // guard let url = Bundle.main.url(forResource: "soundName", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player2 = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            
            slider2.maximumValue = Float(player2!.duration)
            title2.text = url.lastPathComponent
            let seconds = Int(slider2.maximumValue ) % 60 ;
            let  minutes =  Int(slider2.maximumValue / 60 ) % 60;
            endTime2.text = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
            
            

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */


        } catch let error {
            print(error.localizedDescription)
        }
    }

    
}

