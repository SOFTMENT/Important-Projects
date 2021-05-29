//
//  AdminAllVideoController.swift
//  KaiBall Athletics
//
//  Created by Vijay on 04/05/21.
//



import UIKit
import Firebase
import FirebaseFirestoreSwift
import SDWebImage

class AdminAllVideoController: UIViewController {
    
    var videos = Array<Video>()
    
    @IBOutlet weak var tableView: UITableView!
    
    var cat_id : String?
    var cat_title : String?
    
    override func viewDidLoad() {
        
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.title = cat_title
        
        getVideoData()
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addvideoseg" {
            if let destination = segue.destination as? AddVideoController {
                destination.cat_id = cat_id!
            }
        }
        else if segue.identifier == "editvideoseg" {
            if let dest = segue.destination as? EditVideoViewController {
                if let index = sender as? Int {
                    dest.video = videos[index]
                    dest.cat_id = cat_id
                }
                
            }
        }
    }

    
    @IBAction func addVideoButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "addvideoseg", sender: nil)
        
    }
    
    public func getVideoData() {
        
        Firestore.firestore().collection("Categories").document(cat_id!).collection("Videos").order(by: "date").addSnapshotListener { snapshot, error in
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
    

    

    
    @objc func editVideo(value : My2ndTapGesture) {
       
        performSegue(withIdentifier: "editvideoseg", sender: value.index)
        
    }
    
    @objc func deleteVideo(value : MyTapGesture) {
        
        let alert = UIAlertController(title: "DELETE", message: "Are you sure you want to delete this Video?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { actiondelete in
            self.dismiss(animated: true, completion: nil)
            
            Firestore.firestore().collection("Categories").document(self.cat_id!).collection("Videos").document(value.id).delete { error in
                if error == nil {
                    self.showToast(message: "Video has deleted")
                    
                
                    
                    Firestore.firestore().collection("Categories").document(self.cat_id!).updateData(["totalVideos" : FieldValue.increment(Int64(-1))])
                    Storage.storage().reference().child("Categories").child(self.cat_id!).child("\(value.id).mov").delete(completion: nil)
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
        
    
        
    }
}




extension AdminAllVideoController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "adminvideocell", for: indexPath) as? AdminVideosTableViewCell {

            let video = self.videos[indexPath.row]
            
            cell.title.text = video.title
            cell.duration.text = video.duration
            cell.delete.isUserInteractionEnabled = true
            let tappy = MyTapGesture(target: self, action: #selector(self.deleteVideo(value:)))
            cell.delete.addGestureRecognizer(tappy)
            tappy.id = video.id
           
            
            cell.edit.isUserInteractionEnabled = true
            let editTappy = My2ndTapGesture(target: self, action: #selector(editVideo(value:)))
            cell.edit.addGestureRecognizer(editTappy)
            editTappy.index = indexPath.row
            
            
            
            cell.myView.backgroundColor = UIColor.white
            cell.myView.layer.cornerRadius = 6
            cell.myView.clipsToBounds = true
            cell.myView.dropShadow()
       
            
            return cell
            
        }
       
        return AdminVideosTableViewCell()
    }
    

    
}
