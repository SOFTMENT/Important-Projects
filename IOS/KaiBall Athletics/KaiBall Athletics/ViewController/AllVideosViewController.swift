//
//  AllVideosViewController.swift
//  KaiBall Athletics
//
//  Created by Vijay on 04/05/21.
//


import UIKit
import Firebase
import FirebaseFirestoreSwift
import SDWebImage
import MBProgressHUD
import AVKit


class AllVideosViewController: UIViewController {
    
    var videos = Array<Video>()
    var  hasMebership = false
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var navigationCont: UINavigationBar!
    var cat_id : String?
    var cat_title : String?
    var cat_index : Int?
    
    override func viewDidLoad() {
        
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.navigationCont.topItem?.title = cat_title
        
        hasMebership = self.checkMembershipStatus(currentDate: Date(), identifier: "in.softment.KaiBallAthletics.videoaccess")
        //GetVideoData
        getVideoData()
    }
    
    
    public func getVideoData() {
        
        ProgressHUDShow(text: "Loading...")
        
        Firestore.firestore().collection("Categories").document(cat_id!).collection("Videos").order(by: "date").addSnapshotListener { snapshot, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                if let snapshot = snapshot {
                    self.videos.removeAll()
                    for snap in snapshot.documents {
                        if let cat = try? snap.data(as: Video.self) {
                            self.videos.append(cat)
                        }
                       
                    }
                
                    self.tableView.reloadData()
                 
                    
                }
                
            }
            else {
                self.showError(error.debugDescription)
            }
        }
        
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    

    
    @objc func playVideo(value : My2ndTapGesture) {
        
        if hasMebership || (cat_index == 0 && value.index == 0)  {
            
        let player = AVPlayer(url: URL(string: value.url)!)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            vc.player?.play()
        }
    
        }
        else {
            self.showMessage(title: "Required Premium Membership", message: "Please buy premium membership and unlock all videos.")
        }
    }
}

class My2ndTapGesture: UITapGestureRecognizer {
    var url = String()
    var index = Int()
}


extension AllVideosViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "videocell", for: indexPath) as? VideoTableViewcell {

            let video = self.videos[indexPath.row]
            
            
            cell.title.text = video.title
            cell.duration.text = video.duration
                
            if hasMebership {
                cell.lockImg.isHidden = true
            }
            else if cat_index == 0 && indexPath.row == 0 {
                cell.lockImg.isHidden = true
            }
            else {
                cell.lockImg.isHidden = false
            }
            
            cell.playBtn.isUserInteractionEnabled = true
            let tappy = My2ndTapGesture(target: self, action: #selector(self.playVideo(value:)))
            tappy.url = video.videoLink
            tappy.index = indexPath.row
            cell.playBtn.addGestureRecognizer(tappy)
            cell.myview.backgroundColor = UIColor.white
            cell.myview.layer.cornerRadius = 6
            cell.myview.clipsToBounds = true
            cell.myview.dropShadow()
       
            
            return cell
            
        }
       
        return VideoTableViewcell()
    }
    

    
    
}
