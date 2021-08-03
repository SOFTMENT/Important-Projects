//
//  DailyInsightsViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 22/05/21.
//

import Firebase
import FirebaseFirestoreSwift
import UIKit
import SDWebImage

class DailyInsightsViewController : UIViewController {
    
    @IBOutlet weak var settingsBtn: UIImageView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var quote: UITextView!
    @IBOutlet weak var favorite: UIView!
    @IBOutlet weak var share: UIView!
    var dailyInsight : DailyInsightsModel?
    
    @IBOutlet weak var image_quote: UIImageView!
    
    override func viewDidLoad() {
        
        //SettingsBtn
        settingsBtn.isUserInteractionEnabled = true
        settingsBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingsBtnClicked)))
        
        
        //GetInsight
        let hasMebership = self.checkMembershipStatus(currentDate: TabBarController.date,identifier: TabBarController.productIds.first!)
      
        
        if (UserModel.data!.emailAddress == "fredsdavis@gmail.com" || UserModel.data!.emailAddress == "jeffreykgross@gmail.com" || UserModel.data!.emailAddress == "iamvijay67@gmail.com")  ||  hasMebership {
            getDailyInsight()
        }
       
       
        
        //Share
        share.isUserInteractionEnabled = true
        share.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareText)))
        
      
        //FavoriteBtn
        favorite.isUserInteractionEnabled = true
        favorite.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoriteBtnClicked)))
    }
    
    @objc func favoriteBtnClicked(){
        ProgressHUDShow(text: "")
        if let dailyIn = dailyInsight {
            Firestore.firestore().collection("Users").document(UserModel.data!.uid).collection("Favorites").document(String(UserModel.data?.lastQuotesId ?? 1)).setData(["id" : String(UserModel.data?.lastQuotesId ?? 1),"quotes" : dailyIn.quotes,"image": dailyIn.image,"date" : Date()]) { err in
                self.ProgressHUDHide()
                if err == nil {
                
                    self.showToast(message: "Favourited")
                    self.favorite.isHidden = true
                }
                else {
                    self.showError(err!.localizedDescription)
                }
            }
        }
       
    }
    
    
    
    
    @objc func shareText(){
        let text = quote.text
           let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare as [Any] , applicationActivities: nil)
           activityViewController.popoverPresentationController?.sourceView = self.view
           self.present(activityViewController, animated: true, completion: nil)
    }
    
    
  
    override func viewDidAppear(_ animated: Bool) {
        let hasMebership = self.checkMembershipStatus(currentDate: TabBarController.date,identifier: TabBarController.productIds.first!)
        
        if (UserModel.data!.emailAddress != "fredsdavis@gmail.com" && UserModel.data!.emailAddress != "jeffreykgross@gmail.com" && UserModel.data!.emailAddress != "iamvijay67@gmail.com")  && !hasMebership {
            if let tabVC = tabBarController as? TabBarController {
                tabVC.selectedIndex = 0
                tabVC.showMembershipController()
                
            }
        }
    }
    
    func getDailyInsight(){
        ProgressHUDShow(text: "Loading...")
        var lastId = UserModel.data?.lastQuotesId ?? 0
        var date  = UserModel.data?.lastQuotesDate ?? Date()
        if dayDifference(from: date) != "Today" {
            date = Date()
            lastId = lastId + 1
            
            UserModel.data?.lastQuotesDate = date
            UserModel.data?.lastQuotesId = lastId
        }
        
        print(dayDifference(from: date))
        Firestore.firestore().collection("DailyInsights").whereField("id", isGreaterThan: lastId).whereField("id", isLessThan: lastId + 4).getDocuments(completion: { snap, error in
         
            Firestore.firestore().collection("Users").document(UserModel.data!.uid).setData(["lastQuotesDate" : date,"lastQuotesId" : lastId], merge: true)
            
            self.ProgressHUDHide()
            if error == nil {
                if let snap = snap {
                    if snap.documents.count > 0 {
                        if let qds = snap.documents.first {
                            if let dailyInsightsModel = try? qds.data(as: DailyInsightsModel.self) {
                                
                                self.dailyInsight = dailyInsightsModel
                                
                                let day = Calendar.current.component(.day, from: Date())
                                let month = Calendar.current.monthSymbols[Calendar.current.component(.month, from: Date()) - 1]
                                let year = Calendar.current.component(.year, from: Date())
                    
                                self.day.text = String(day)
                                self.month.text = month
                                self.year.text = String(year)
                                
                                self.quote.text = dailyInsightsModel.quotes
                        
                                self.image_quote.sd_setImage(with: URL(string: dailyInsightsModel.image), placeholderImage: UIImage(named: "beach"), options: .continueInBackground, completed: nil)
                                
                                DispatchQueue.main.async {
                                    self.getFavoriteStatus()
                                }
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
        })
    }
    
    @objc func settingsBtnClicked(){
        performSegue(withIdentifier: "settingsseg", sender: nil)
    }

    
    public func getFavoriteStatus(){
        Firestore.firestore().collection("Users").document(UserModel.data!.uid).collection("Favorites").document(String(UserModel.data?.lastQuotesId ?? 1)).getDocument { snap, err in
            
            if err == nil {
                if let snap = snap {
                    if snap.exists {
                        self.favorite.isHidden = true
                    }
                }
            }
        }
    }

}



