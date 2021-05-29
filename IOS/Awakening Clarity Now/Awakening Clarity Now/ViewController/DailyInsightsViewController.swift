//
//  DailyInsightsViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 22/05/21.
//

import Firebase
import FirebaseFirestoreSwift
import UIKit

class DailyInsightsViewController : UIViewController {
    
    @IBOutlet weak var settingsBtn: UIImageView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var quote: UITextView!
    @IBOutlet weak var favorite: UIView!
    @IBOutlet weak var share: UIView!
    
    
    override func viewDidLoad() {
        
        //SettingsBtn
        settingsBtn.isUserInteractionEnabled = true
        settingsBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingsBtnClicked)))
        
        //GetInsight
         getDailyInsight()
        
        //Share
        share.isUserInteractionEnabled = true
        share.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareText)))
        
    }
    
    @objc func shareText(){
        let text = quote.text
           let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare as [Any] , applicationActivities: nil)
           activityViewController.popoverPresentationController?.sourceView = self.view
           self.present(activityViewController, animated: true, completion: nil)
    }
    
    func getDailyInsight(){
        ProgressHUDShow(text: "Loading...")
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
               guard
                   let start = Calendar.current.date(from: components),
                   let end = Calendar.current.date(byAdding: .day, value: 1, to: start)
               else {
                   fatalError("Could not find start date or calculate end date.")
               }
        Firestore.firestore().collection("DailyInsights").whereField("date", isGreaterThan: start).whereField("date", isLessThan: end).addSnapshotListener { snap, error in
            self.ProgressHUDHide()
            if error == nil {
                if let snap = snap {
                    if snap.documents.count > 0 {
                        if let qds = snap.documents.first {
                            if let dailyInsightsModel = try? qds.data(as: DailyInsightsModel.self) {
                                let day = Calendar.current.component(.day, from: dailyInsightsModel.date)
                                let month = Calendar.current.monthSymbols[Calendar.current.component(.month, from: dailyInsightsModel.date) - 1]
                                let year = Calendar.current.component(.year, from: dailyInsightsModel.date)
                                
                                self.day.text = String(day)
                                self.month.text = month
                                self.year.text = String(year)
                                
                                self.quote.text = dailyInsightsModel.quotes
                            }
                            else {
                                
                            }
                        }
                        else {
                         
                        }
                       
                    }
                    else{
                      
                    }
                }
                else {
                  
                }
            
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
    }
    
    @objc func settingsBtnClicked(){
        performSegue(withIdentifier: "settingsseg", sender: nil)
    }

    

}
