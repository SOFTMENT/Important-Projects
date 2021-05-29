//
//  HomeViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 12/03/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//
import AVKit
import UIKit
import Firebase
import CoreLocation
import Alamofire

class HomeViewController: BaseViewController, AVRoutePickerViewDelegate {

    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var inbox: UIView!
    @IBOutlet weak var newsroom: UIView!
    @IBOutlet weak var livechat: UIView!
    @IBOutlet weak var rapidtv: UIView!
    @IBOutlet weak var debitorders: UIView!
    @IBOutlet weak var naedo: UIView!
    @IBOutlet weak var debicheck: UIView!
    @IBOutlet weak var rapidavs: UIView!
    @IBOutlet weak var rapidsdo: UIView!
    @IBOutlet weak var digimandate: UIView!
    @IBOutlet weak var cloudinvoicing: UIView!
    @IBOutlet weak var aboutus: UIView!
    @IBOutlet weak var accreditation: UIView!
    @IBOutlet weak var faqs: UIView!

    @IBOutlet weak var contactus: UIView!
    @IBOutlet weak var cashbundle: UIView!
    @IBOutlet weak var debtcollection: UIView!
    @IBOutlet weak var insurance: UIView!
    var root : DatabaseReference?
    var isVisible = "true"
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myPageView: UIPageControl!
    
    let loading = ProgressHUD(text: "Loading...")
  

    
    var imgArr = [  UIImage(named:"B1"),
                     UIImage(named:"B2") ,
                     UIImage(named:"B3"),
                     UIImage(named:"B4"),
                     UIImage(named: "B5")
                     ]
     
     var timer = Timer()
     var counter = 0
 
   
    
    let cast = AVRoutePickerView(frame: CGRect(x: 50 , y: 50 , width: 100, height: 100))
    

   

    
    let blockTitle : [String] = ["Register Now", "Home", "Debit Orders","Rapid AVS & AHV", "Data Optimization", "DebiCheck","digimandateTM","Cloud Invoicing","Cash Bundle","FICA","Accreditation",
    "About Us","FAQs" ,"Contact Us", "Covid-19"
    ]
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
       
        
        view.addSubview(loading)
    
        if Auth.auth().currentUser != nil {
            self.loading.show()
            getDetails()
        }
        else {
           
            let profilemodel = ProfileModel.getModel()
            profilemodel.name = "Welcome Guest User"
            profilemodel.mail = "Register by clicking on Edit Profile"
            profilemodel.profileimage = "https://firebasestorage.googleapis.com/v0/b/mobile-app-91186.appspot.com/o/ProfilePicture%2FAttachment_1594237970.png?alt=media&token=a5f00804-becc-4ecf-8607-f869f119daeb"
        }
        

        
        root = Database.database().reference().child("RapidTv")
        root?.observeSingleEvent(of: .value, with: { (snapshot) in
        
            let value = snapshot.value as! [String : String]
            self.isVisible = value["isVisible"]!
            
        })
        
        
        
        //ViewLoad
        registrationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(registartionClick)))
         loginView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginClick)))
        inbox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inboxTapped)))
         newsroom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(newsRoomTapped)))
         rapidtv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rapidt)))
         debitorders.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(debit)))
        naedo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(naedos)))
         debicheck.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(debitCheck)))
        rapidavs.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rapidAVSTapped)))
        rapidsdo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rapidSDOTapped)))
         digimandate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(digi)))
        cloudinvoicing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cloud)))
        
        aboutus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(aboutUsTapped)))
        accreditation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accreditationTapped)))
    
        
       faqs.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(faqsTapped)))
            
        contactus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contactUsTapped)))
        cashbundle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cashBundleTapped)))
        debtcollection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(debtCollectionTapped)))
            insurance.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(insuranceTapped)))
        livechat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(livechatTapped)))
        
        
        let btnNoti = UIButton(type: UIButton.ButtonType.system)
               btnNoti.setImage(UIImage(systemName: "bell"), for: .normal)
               btnNoti.frame = CGRect(x: 0, y: 0, width: 10  , height: 10)
        btnNoti.tintColor = .white
        btnNoti.addTarget(self, action: #selector(notificationClicked), for: UIControl.Event.touchUpInside)
        
      
        
        self.navigationItem.rightBarButtonItems = [ UIBarButtonItem(customView: btnNoti),UIBarButtonItem(image: UIImage(named: "icons8-chromecast-cast-button-100"), style: .plain, target: self, action: #selector(showAirplay))]
   
        
        myPageView.numberOfPages = imgArr.count
        myPageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(doSomething), name: UIApplication.willEnterForegroundNotification, object: nil)
        


           
           
        // Do any additional setup after loading the view.
    }
    
   @objc func showAirplay() {
        let rect = CGRect(x: -100, y: 0, width: 0, height: 0)
        let airplayVolume = AVRoutePickerView(frame: rect)
        self.view.addSubview(airplayVolume)
        for view: UIView in airplayVolume.subviews {
            if let button = view as? UIButton {
                button.sendActions(for: .touchUpInside)
                break
            }
        }
        airplayVolume.removeFromSuperview()
    }
    
    @objc func insuranceTapped() {
        Temp.btnName = "insurance"
                gotoWeb()
    }
    
    
    @objc func debtCollectionTapped() {
           Temp.btnName = "debtcollection"
                   gotoWeb()
       }
    
    @objc func cashBundleTapped() {
        if isVisible == "false" {
            Temp.btnName = "rapidavs"
        }
        else {
           Temp.btnName = "cashbundle"
        }
                   gotoWeb()
       }
    
    @objc func contactUsTapped() {
           performSegue(withIdentifier: "contactSeg", sender: nil)
       }
       
    
    @objc func covid19Tapped() {
           Temp.btnName = "covid19"
                   gotoWeb()
       }
       
    
    @objc func faqsTapped() {
        Temp.btnName = "faqs"
                gotoWeb()
           
       }
       
    
    @objc func accreditationTapped() {
        Temp.btnName = "accre"
                gotoWeb()
    }
    
    @objc func aboutUsTapped() {
        Temp.btnName = "aboutus"
                gotoWeb()
    }
    
    @objc func rapidSDOTapped() {
        Temp.btnName = "rapidsdo"
                gotoWeb()
    }
    
    @objc func rapidAVSTapped() {
        Temp.btnName = "rapidavs"
                gotoWeb()
    }
    
    @objc func livechatTapped() {
        tabBarController?.selectedIndex = 2
    }
    
    @objc func newsRoomTapped() {
        
        tabBarController?.selectedIndex = 3
    }
    

    @objc func inboxTapped() {
        if Auth.auth().currentUser == nil {
            let resendAlert = UIAlertController(title: "Rapid Collect", message: "Sign In is Required to Read Messages", preferredStyle: .alert)
            
            let  resendAction1 = UIAlertAction(title: "Sign In", style: .default) { (alert) in
                let pvc = self.presentingViewController
               let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "signin")
               self.navigationController!.pushViewController(destViewController, animated: true)
                pvc?.dismiss(animated: true, completion: nil)
            }
            
            let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.tabBarController?.selectedIndex = 0
            }
            resendAlert.addAction(resendAction1)
            resendAlert.addAction(cancelAlert)
            
            self.present(resendAlert,animated: true,completion: nil)
        }
        else {
        performSegue(withIdentifier: "notificationSeg", sender: nil)
        }
        
        
    }
    @objc func registartionClick() {
          Temp.btnName = "registration"
        let alert =  UIAlertController(title: "REGISTRATION", message: "PLEASE CHOOSE ANY ONE OPTION", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "DEBIT ORDERS", style: .default) { (action) in
            Temp.btnName = "debitregi"
            self.gotoWeb()
        }
        let action2  = UIAlertAction(title: "PAYMENTS", style: .default) { (action1) in
            Temp.btnName = "paymentregi"
            self.gotoWeb()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
        
    
      }
      
      @objc func loginClick() {
        
        if Auth.auth().currentUser == nil {
            let resendAlert = UIAlertController(title: "Rapid Collect", message: "Sign In is Required to Read Messages", preferredStyle: .alert)
            
            let  resendAction1 = UIAlertAction(title: "Sign In", style: .default) { (alert) in
                let pvc = self.presentingViewController
               let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "signin")
               self.navigationController!.pushViewController(destViewController, animated: true)
                pvc?.dismiss(animated: true, completion: nil)
            }
            
            let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.tabBarController?.selectedIndex = 0
            }
            resendAlert.addAction(resendAction1)
            resendAlert.addAction(cancelAlert)
            
            self.present(resendAlert,animated: true,completion: nil)
        }
        else {
        
        if isVisible == "true" {
            
          
          Temp.btnName = "login"
        }
        else {
            Temp.btnName = "paymentregi"
        }
          gotoWeb()
      }
      }
    @objc func home() {
        Temp.btnName = "home"
        gotoWeb()
    }
    
    @objc func debit() {
        Temp.btnName = "debitorder"
        gotoWeb()
    }
    
    @objc private func doSomething() {
         if delegate.body != "message" {
             let alert = UIAlertController(title: delegate.title, message: delegate.body, preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         }
     }
    
    @objc func naedos() {
        Temp.btnName = "naedo"
        gotoWeb()
    }
    
    @objc func rapidt() {
       performSegue(withIdentifier: "rapidtvseg", sender: nil)
    }
    
    
    @objc func strike() {
        Temp.btnName = "strike"
        gotoWeb()
    }
    
    @objc func debitCheck() {
        Temp.btnName = "debitCheck"
        gotoWeb()
    }
    
    @objc func digi() {
          Temp.btnName = "digi"
          gotoWeb()
      }
      
      @objc func cloud() {
          Temp.btnName = "cloud"
          gotoWeb()
      }
    
    func gotoWeb() {
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "web")
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        
        var  color = UIColor.init(red: 237/255, green: 27/255, blue: 37/255, alpha: 1)
        
        let preferences = UserDefaults.standard

             let colorKey = "colorKey"

             if preferences.object(forKey: colorKey) == nil {
             
             } else {
                 
                 let currentLevel = preferences.string(forKey: colorKey)
                 
                 switch currentLevel {
                 case "black":
                     color = UIColor.init(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
                     break;
                     
                 case "green" :
                     color = UIColor.init(red: 22/255, green: 74/255, blue: 42/255, alpha: 1)
                     
                     break
                     
                 case "red" :
            color = UIColor.init(red: 237/255, green: 27/255, blue: 37/255, alpha: 1)
                     
                     break
                 case "blue" :
                     color = UIColor.init(red: 34/255, green: 48/255, blue: 81/255, alpha: 1)
                 
                     break
                     
                 default:
                     print("")
                 }
             }
        tabBarController?.tabBar.barTintColor = color
        navigationController?.navigationBar.barTintColor = color
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

  
   
    @objc func notificationClicked() {
        if Auth.auth().currentUser == nil {
            let resendAlert = UIAlertController(title: "Rapid Collect", message: "Sign In is Required to Read Notification", preferredStyle: .alert)
            
            let  resendAction1 = UIAlertAction(title: "Sign In", style: .default) { (alert) in
                let pvc = self.presentingViewController
               let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "signin")
               self.navigationController!.pushViewController(destViewController, animated: true)
                pvc?.dismiss(animated: true, completion: nil)
            }
            
            let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.tabBarController?.selectedIndex = 0
            }
            resendAlert.addAction(resendAction1)
            resendAlert.addAction(cancelAlert)
            
            self.present(resendAlert,animated: true,completion: nil)
        }
        else {
                let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "notification")
               self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    @objc func changeImage() {
      
      if counter < imgArr.count {
          let index = IndexPath.init(item: counter, section: 0)
          self.myCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
          myPageView.currentPage = counter
          counter += 1
      } else {
          counter = 0
          let index = IndexPath.init(item: counter, section: 0)
          self.myCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
         myPageView.currentPage = counter
          counter = 1
      }
          
      }
    
    func getDetails() {
        if let user = Auth.auth().currentUser {
            Database.database().reference().child("Users").child(user.uid).observe(.value) { (snapshot) in
                  
                  
               self.loading.hide()

              
                if let dict = snapshot.value as? [String : String] {
                  
                    
                  let profilemodel = ProfileModel.getModel()
                  profilemodel.name = dict["name"]!
                  profilemodel.mail = dict["mail"]!
                  profilemodel.profileimage = dict["profileimage"]!
                  
                
                }
                else {
                    
                }
            }
        }
        else {
             //  self.loading.hide()

            print("No Current User")
        }
        
    }
    
    
}




extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.image = imgArr[indexPath.row]
            
          
        }
        return cell
    }
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let visibleIndex = Int(targetContentOffset.pointee.x / myCollectionView.frame.width)
        myPageView.currentPage = visibleIndex
        counter = visibleIndex

    }
    
    
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let size = myCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
     
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
   
}

extension URL {
    func download(to directory: FileManager.SearchPathDirectory, using fileName: String? = nil, overwrite: Bool = false, completion: @escaping (URL?, Error?) -> Void) throws {
        let directory = try FileManager.default.url(for: directory, in: .userDomainMask, appropriateFor: nil, create: true)
        let destination: URL
        if let fileName = fileName {
            destination = directory
                .appendingPathComponent(fileName)
                .appendingPathExtension(self.pathExtension)
        } else {
            destination = directory
            .appendingPathComponent(lastPathComponent)
        }
        if !overwrite, FileManager.default.fileExists(atPath: destination.path) {
            completion(destination, nil)
            return
        }
        URLSession.shared.downloadTask(with: self) { location, _, error in
            guard let location = location else {
                completion(nil, error)
                return
            }
            do {
                if overwrite, FileManager.default.fileExists(atPath: destination.path) {
                    try FileManager.default.removeItem(at: destination)
                }
                try FileManager.default.moveItem(at: location, to: destination)
                completion(destination, nil)
            } catch {
                print(error)
            }
        }.resume()
    }
}
