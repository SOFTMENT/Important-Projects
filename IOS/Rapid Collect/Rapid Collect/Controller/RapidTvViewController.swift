//
//  RapidTvViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 01/05/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import AVKit
import Firebase

class RapidTvViewController: UIViewController {

    var rapidtvmodels =  [RapidTVModel]()
    let wait = ProgressHUD(text: "Wait...")
    var root : DatabaseReference?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
            
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(wait)
        wait.show()
        root = Database.database().reference().child("RapidTv")
        root?.observeSingleEvent(of: .value, with: { (snapshot) in
            self.wait.hide()
            let value = snapshot.value as! [String : String]
            print(value["isVisible"]!)
            let v = value["isVisible"]
            if v == "true" {
                let rapidtvmodel1 = RapidTVModel(title: "Rapid Cash Bundle", desc: "Rapid Cash Bundle, your fully integrated and digital collection solution, powered by Rapid Collect. ", videoUrl: "https://rapidcollect.co.za/Attachment_1586016358.mp4",image: "v2")
           
                
                let rapidtvmodel2 = RapidTVModel(title: "Rapid Collect, Introductory Video", desc: "Rapid Collect, process explainer video.", videoUrl: "https://rapidcollect.co.za/Attachment_1586016367.mp4",image: "v1")
               
                let rapidtvmodel3 = RapidTVModel(title: "Introducing the digiMandate", desc: "Welcome to the digiMandate, powered by Rapid Collect", videoUrl: "https://rapidcollect.co.za/Attachment_1586016321.mp4",image: "v3")
                self.rapidtvmodels.append(rapidtvmodel2)
                self.rapidtvmodels.append(rapidtvmodel1)
                self.rapidtvmodels.append(rapidtvmodel3)
                self.tableView.reloadData()
            }
            else {
                 let rapidtvmodel3 = RapidTVModel(title: "Introducing the digiMandate", desc: "Welcome to the digiMandate, powered by Rapid Collect", videoUrl: "https://rapidcollect.co.za/Attachment_1586016321.mp4",image: "v3")
                 self.rapidtvmodels.append(rapidtvmodel3)
                  self.tableView.reloadData()
            }
            
        })
        
       
        
    }
    

    

}



extension RapidTvViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rapidtvmodels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "rapidtvcell", for: indexPath) as? RapidTVViewCell {
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let rapidtvmodel = rapidtvmodels[indexPath.row]
            cell.name.text = rapidtvmodel.title
            cell.desc.text = rapidtvmodel.desc
            cell.imgView.image = UIImage(named: rapidtvmodel.image)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoURL = URL(string: rapidtvmodels[indexPath.row].videoUrl)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        try! AVAudioSession.sharedInstance().setCategory(.playback, options: [])
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    
    
    
}
