//
//  AdminHomeViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 22/05/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

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
        Firestore.firestore().collection("DailyInsights").order(by: "date", descending: true).addSnapshotListener { snap, err in
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
        Firestore.firestore().collection("DailyInsights").document(myTap.docId).delete()
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
            
        if indexPath.row % 3 == 0 {
            cell.image_quote.image = #imageLiteral(resourceName: "tree_insight")
        }
        else if indexPath.row % 3 == 1 {
            cell.image_quote.image = #imageLiteral(resourceName: "beach")
        }
        else if indexPath.row % 3 == 2 {
            cell.image_quote.image = #imageLiteral(resourceName: "desert_tab")
        }
      
        let dailyInsight = dailyInsightsModels[indexPath.row]
        let day = Calendar.current.component(.day, from: dailyInsight.date)
        let month = Calendar.current.monthSymbols[Calendar.current.component(.month, from: dailyInsight.date) - 1]
        let year = Calendar.current.component(.year, from: dailyInsight.date)
        
        cell.day.text = String(day)
        cell.month.text = month
        cell.year.text = String(year)
        
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

    var docId = ""
    
}
