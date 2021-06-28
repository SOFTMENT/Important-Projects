//
//  AdminHomeViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 22/05/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import SDWebImage

class AdminHomeViewController: UIViewController {

   
    @IBOutlet weak var tableView: UITableView!
    var dailyInsightsModels = Array<DailyInsightsModel>()
    let docId = ""
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //GetDailyInsights
        getDailyInsights()
        
        //addQuotesClicked
        
    }
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
        }
        catch {
            
        }
    }
    
    @IBAction func addInsights(_ sender: Any) {
        
        performSegue(withIdentifier: "addquoteseg", sender: nil)
        
    }
    func getDailyInsights(){
        ProgressHUDShow(text: "Loading...")
        Firestore.firestore().collection("DailyInsights").order(by: "id", descending: true).addSnapshotListener { snap, err in
            self.ProgressHUDHide()
            if err == nil {
                self.dailyInsightsModels.removeAll()
                if let snap = snap {
                    for mySnap in snap.documents {
                        if let dailyInsight = try? mySnap.data(as: DailyInsightsModel.self) {
                            self.dailyInsightsModels.append(dailyInsight)
                        }
                      
                    }
                }
                self.tableView.reloadData()
                
            }
            else {
                self.showError(err!.localizedDescription)
            }
        }
    }
    
    @objc func deleteBtnTapped(myTap : MyTapGesture){
        Firestore.firestore().collection("DailyInsights").document(String(myTap.docId)).delete()
        showToast(message: "Deleted")
        
    }
}

extension AdminHomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        dailyInsightsModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if let cell = tableView.dequeueReusableCell(withIdentifier: "adminhomecell", for: indexPath) as? AdminHomeViewCell {
            
            cell.myview.layer.cornerRadius = 8
            
     
      
        let dailyInsight = dailyInsightsModels[indexPath.row]
        
        
        
        
        cell.image_quote.sd_setImage(with: URL(string: dailyInsight.image), placeholderImage: UIImage(named: "beach"), options: .continueInBackground, completed: nil)
       
        
        cell.quotes.text = dailyInsight.quotes
        
        cell.deleteBtn.isUserInteractionEnabled = true
        
        let myTap = MyTapGesture(target: self, action: #selector(deleteBtnTapped(myTap:)))
        myTap.docId = dailyInsight.id
        cell.deleteBtn.addGestureRecognizer(myTap)
        
        
          return cell
        }
        return AdminHomeViewCell()
    }
    
    
    
}


class MyTapGesture: UITapGestureRecognizer {

    var docId = 0
    
}
