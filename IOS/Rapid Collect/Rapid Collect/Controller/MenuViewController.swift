//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import Firebase
import SwiftSMTP
import Alamofire


protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ name : String)
}


class MenuViewController: UIViewController {
    
    
  
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editProfile: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var bttomC: NSLayoutConstraint!

    @IBOutlet weak var downloadpack: UIView!
    
    //View
    @IBOutlet weak var calculator: UIView!
    @IBOutlet weak var home: UIView!
    @IBOutlet weak var todo: UIView!
    @IBOutlet weak var locationhistory: UIView!
    @IBOutlet weak var newsroom: UIView!
    @IBOutlet weak var currencyConvertor: UIView!
    
    @IBOutlet weak var securityinfo: UIView!
    
    @IBOutlet weak var notification: UIView!
    @IBOutlet weak var livechat: UIView!
    @IBOutlet weak var logout: UIView!
    
    @IBOutlet weak var settings: UIView!
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var rapidlegalservices: UIView!
    @IBOutlet weak var rapidcollectionsystem: UIView!
    @IBOutlet weak var rapidgroupofcompanies: UIView!
    @IBOutlet weak var rapidpayment: UIView!
    @IBOutlet weak var rapidtelecoms: UIView!
    
    @IBOutlet weak var rapidmobile: UIView!
    @IBOutlet weak var uploadDoc: UIView!
    /**
    *  Transparent button to hide menu
    */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
    *  Array containing menu options
    */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
    *  Menu button which was tapped to display the menu
    */
    var btnMenu : UIButton!
    
    /**
    *  Delegate of the MenuVC
    */
    var delegate : SlideMenuDelegate?
  
    var n : UINavigationController?
    
    let sending  = ProgressHUD(text: "Sending...")
  
    var myName : String = ""
    var myEmail : String = ""
    var myUrl : URL?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
     
        //Make Image Rounded
        profileImage.makeRounded()
        
        livechat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(livechatTapped)))
        editProfile.isEnabled = true
        editProfile.isUserInteractionEnabled = true
        editProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfileTapped)))
        home.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(homeTapped)))
        calculator.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(calculatorTapped)))
        todo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(todoTapped)))
        newsroom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(newsTapped)))
        locationhistory.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(locationTapped)))
        securityinfo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(securityinfoTapped)))
        currencyConvertor.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(currencyTapped)))
        uploadDoc.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadDocTapped)))
        notification.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notificationTapped)))
        settings.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingsTapped)))
        logout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutTapped)))
        rapidpayment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rapidpaymentTapped)))
        rapidtelecoms.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rapidtelecomsTapped)))
        rapidmobile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rapidmobileTapped)))
        
        rapidlegalservices.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rapidleaglTapped)))
        rapidcollectionsystem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rapidcollectionsystemTapped)))
        rapidgroupofcompanies.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rapidgroupofcompaniesTapped)))
      
        downloadpack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(downloadpackTapped)))
      

  
        setDeatils()
    
    }
    
    @objc func downloadpackTapped() {
        let alert =  UIAlertController(title: "DOWNLOAD ON-BOARDING PACK", message: "PLEASE CHOOSE ANY ONE OPTION", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "DOWNLOAD NOW", style: .default) { (action) in
            
            self.downloadDoc()
          
        }
        let action2  = UIAlertAction(title: "SEND ON EMAIL ADDRESS", style: .default) { (action1) in
            
            
        
            
            if Auth.auth().currentUser != nil {
                self.myName = ProfileModel.getModel().name
                self.myEmail = ProfileModel.getModel().mail
                self.sendMailToUserOrGuest()
            }
            else {
                
                let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
              
                alertController.addTextField { (textField : UITextField!) -> Void in
                        textField.placeholder = "Enter Full Name"
                    }
                alertController.addTextField { (textField : UITextField!) -> Void in
                        textField.placeholder = "Enter Email Address"
                    }
                let saveAction = UIAlertAction(title: "Send", style: UIAlertAction.Style.default, handler: { alert -> Void in
                        let firstTextField = alertController.textFields![0] as UITextField
                    self.myName = firstTextField.text!
                    
                        let secondTextField = alertController.textFields![1] as UITextField
                    self.myEmail = secondTextField.text!
                    
                    print(self.myName, self.myEmail)
                    self.sendMailToUserOrGuest()
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                
                    
                    alertController.addAction(saveAction)
                    alertController.addAction(cancelAction)
                    
                self.present(alertController, animated: true, completion: nil)
                
            }
           
        }
        let action3 = UIAlertAction(title: "CANCEL", style: .destructive) { (action1) in
      
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        self.present(alert, animated: true, completion: nil)
    }
   
    
    func sendMailToUserOrGuest() {
        
        view.addSubview(sending)
        self.sending.show()
        
        let smtp = SMTP(
            hostname: "smtp.rapidcollect.co.za",     // SMTP server address
            email: "on-boardingdocs@rapidcollect.co.za",        // username to login
            password: "8eHU6Wl2Vlg5xnuu"            // password to login
        )
        
        let drLight = Mail.User(name: "on-boardingdocs@rapidcollect.co.za", email: "on-boardingdocs@rapidcollect.co.za")
        let megaman = Mail.User(name: myName, email: myEmail)

        
        
        let attachment = Attachment(htmlContent: "<p>Good day <strong>\(myName)</strong><br /><br />Thank you for taking the time to enquire for the Rapid Collect services.</p>\n" +
        "<p><span style=\"color: #ff0000;\">Rapid Collect</span>, is your Smart Debit Order and Payments Solutions Partner of Choice!<br /><br />To continue the registration process we require detailed information about yourself and your business. Please click on the link below to be re-directed to the necessary on-boarding and vetting documentation. This contains a list of supporting documents that are required as well.</p>\n" +
        "<p><br /><a href=\"https://rapidcollect.co.za/wp-content/uploads/2020/07/L3-On-Boarding_Registration-Pack-Rapid-Collect.zip\">Click here to download documents</a> which contains all the required documents as outlined below.<br /><br />These required documents contain all the necessary information as required by our vetting department, to complete the registration process with Rapid Collect.</p>\n" +
        "<p><br /><span style=\"color: #ff0000;\"><strong>Document Submission Requirements</strong>:</span></p>\n" +
        "<ol>\n" +
        "<li>Complete All documents correctly and completely;</li>\n" +
        "<li>All documents must be clearly legible, no blurred copies;</li>\n" +
        "<li>Copy of ID must be in colour;</li>\n" +
        "<li>Please Retain the Original documents for collection by us, at a later stage, when we do a <strong>site inspection</strong>.</li>\n" +
        "</ol>\n" +
        "<p><br /><span style=\"color: #ff0000;\"><strong>We require the following documents Fully completed and signed by the client (L3)</strong>:</span></p>\n" +
        "<ol>\n" +
        "<li>Addendum A &ndash; Mandatory Required Docs - Rapid Collect V1.1</li>\n" +
        "<li>Addendum B &ndash; Nature of Transactions &ndash; Rapid Collect V1.1</li>\n" +
        "<li>Addendum C &ndash; POA &ndash; Business Address SA &ndash; Rapid Collect V1.1</li>\n" +
        "<li>Addendum D &ndash; Company Resolution &ndash; Rapid Collect</li>\n" +
        "<li>Addendum E &ndash; ABSA Debit Order Abuse Letter</li>\n" +
        "<li>Addendum F &ndash; NAEDO/Debicheck Sample Mandate Wording for Transcription &ndash; Rapid Collect V1.1</li>\n" +
        "<li>Addendum G &ndash; Accountant Authorisation/Confirmation Letter &ndash; Rapid Collect</li>\n" +
        "<li>Addendum H &ndash; Rapid Collect Terms and Conditions for L3 User V1.1</li>\n" +
        "<li>Addendum I &ndash; Request For Services Application &ndash; Rapid Collect V1.1</li>\n" +
        "<li>Addendum J1 &ndash; NEW EDO PSSF Beneficiary Application Form V3.03</li>\n" +
        "<li>Addendum J2 &ndash; Pre-Vetting Questionnaire &ndash; Rapid Collect V1.1</li>\n" +
        "<li>Addendum K &ndash; Rapid Pricing Quotation V1.1</li>\n" +
        "<li>Addendum L &ndash; Official Client Checklist &ndash; Rapid Collect V1.1</li>\n" +
        "<li>Addendum M &ndash; Sample Mandate Confirmation to be signed by client (L3)</li>\n" +
        "<li>ABSA User Pre-Screening Document (To be Fully Completed and Signed together with the supporting Documents)</li>\n" +
        "</ol>\n" +
        "<p>Once you have all the documents ready together with all the relevant documents being certified, please scan and email the documents to: <a href=\"mailto:vetting@rapidcollect.co.za\">vetting@rapidcollect.co.za</a></p>\n" +
        "<p>If the files are too large to send as an attachment in an email, please send us a <u>weTransfer or Dropbox link</u> with all the above documents (uploaded) together with all the required supporting documents to: <a href=\"mailto:vetting@rapidcollect.co.za\">vetting@rapidcollect.co.za</a><br /><br /><span style=\"color: #ff0000;\"><strong>The Process</strong>:</span></p>\n" +
        "<ol>\n" +
        "<li>Only once we have received all of the above documents will your application begin to be processed.</li>\n" +
        "<li>Once all documents have been received you will be sent an invoice for your &ldquo;<strong>sign up fee&rdquo;</strong>.</li>\n" +
        "<li>This must be paid immediately upon receipt of the invoice in order for vetting to proceed.</li>\n" +
        "<li>Rapid Collect will then process your application, upon PASA and Bank approval, final agreement will be sent to you for signature and upon receipt of returned signed agreement, our compliance department will initiate your EDO PSSF Beneficiary membership registration.</li>\n" +
        "<li>The EDO PSSF will invoice you directly for this fee which you will receive via email as registered with Rapid Collect.</li>\n" +
        "<li>It could take approximately +/-14 days from the time we receive payment for the Rapid Collect application processing fee until your user profile is created on the Rapid Collect SO system and you are given access to capture / upload your debit orders.</li>\n" +
        "</ol>\n" +
        "<p><br />For any further information, please do not hesitate to contact us as follows:</p>\n" +
        "<p>Ashleigh Mervyn: <a href=\"mailto:ashleigh@rapidcollect.co.za\">ashleigh@rapidcollect.co.za</a></p>\n" +
        "<p>Bertram Witbooi: <a href=\"mailto:bertram@rapidcollect.co.za\">bertram@rapidcollect.co.za</a></p>\n" +
        "<p>Liza: <a href=\"mailto:liza@rapidcollect.co.za\">liza@rapidcollect.co.za</a></p>\n" +
        "<p><strong>Compliance / Sales Department:</strong></p>\n" +
        "<p>Compliance Department: <a href=\"mailto:compliance@rapidcollect.co.za\">compliance@rapidcollect.co.za</a></p>\n" +
        "<p>Sales Department: <a href=\"mailto:sales@rapidcollect.co.za\">sales@rapidcollect.co.za</a></p>\n" +
        "<p>&nbsp;Kind Regards</p>\n" +
        "<p><strong>THE <span style=\"color: #ff0000;\">RAPID COLLECT</span> SALES AND ON-BOARDING TEAM</strong></p>\n" +
        "<p>&nbsp;</p>\n" +
        "<p>&nbsp;</p>\n" +
        "<p>&nbsp;</p>\n" +
        "<p>&nbsp;</p>\n" +
        "<p><strong>Disclaimer</strong>:&nbsp;\"This message may contain confidential information, including any attachments, that is legally privileged and is intended only for the use of the parties to whom it is&nbsp;addressed. If you are not an intended recipient, you are hereby notified that any disclosure, copying, distribution or use of any information in this message is strictly prohibited&nbsp;and illegal. If you have received this message in error, please notify the sender immediately and delete the message.\"</p>\n" +
        "<p>Sovereign Confidentiality Notice:&nbsp;This private email message, including any attachment(s) is limited to the sole use of the intended recipient and may contain Privileged and/or&nbsp;Confidential Information. Any and All Political, Private or Public Entities, Federal, State, or Local Corporate Government(s), Municipality(ies), International Organizations,&nbsp;Corporation(s), Agent(s), Investigator(s), or Informant(s) , et. al., and/or Third Party(ies) working in collusion collecting and/or monitoring My email(s), and any other means&nbsp;of spying and collecting these communications, without my Exclusive Permission are Barred from Any and All Unauthorized Review, Use, Disclosure or Distribution. With Explicit&nbsp;Reservation of All My Rights, Without Prejudice and Without Recourse to Me. Any omission does not constitute a waiver of any and/or ALL Intellectual Property Rights or&nbsp;Reserved Rights. NOTICE TO PRINCIPLE IS NOTICE TO AGENT. NOTICE TO AGENT IS NOTICE TO PRINCIPLE</p>\n" +
        "<p>This disclaimer and notice forms part of the content of this e-mail for purposes of section 11 of the Electronic Communications and Transactions Act, 2002 (Act No. 25 of 2002)</p>\n" +
        "<p><strong>Please consider your environmental responsibility before printing this e-mail.</strong></p>")
        let mail = Mail(
            from: drLight,
            to: [megaman],
            subject: "RAPID COLLECT REGISTRATION / ON-BOARDING DOCUMENTS (L3)",
            text: "",
            attachments: [attachment]
        )

        
        
        smtp.send(mail) { (error) in
            
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.sending.hide()
                }
            }
            else {
              
                DispatchQueue.main.async {
                  
                    self.sending.hide()
                    let confirmEmailAlert = UIAlertController(title: "On-Boarding Pack", message: "Mail Has Been Sent On Your Email Address", preferredStyle: .actionSheet)
                    let action = UIAlertAction(title: "Ok", style: .default) { (actions) in
                        
                    }
                    confirmEmailAlert.addAction(action)
                    self.present(confirmEmailAlert,animated: true,completion: nil)
                  }
                
               
                
            }
        }
    }
    
    @objc func livechatTapped() {
        print("Hello")
        tabBarController?.selectedIndex = 2
        closeMenu()
    }
    
    @objc func editProfileTapped() {
        if Auth.auth().currentUser == nil {
            let resendAlert = UIAlertController(title: "Rapid Collect", message: "Sign In is Required to Edit Profile", preferredStyle: .alert)
            
            let  resendAction1 = UIAlertAction(title: "Sign In", style: .default) { (alert) in
           
                let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signin")
                UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)
                
               
            }
            
            let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.tabBarController?.selectedIndex = 0
            }
            resendAlert.addAction(resendAction1)
            resendAlert.addAction(cancelAlert)
            
            self.present(resendAlert,animated: true,completion: nil)
        }
        else {
        performSegue(withIdentifier: "editprofilesegue", sender: "EDIT PROFILE")
        }
        closeMenu()
    }
    
    @objc func uploadDocTapped() {
        if Auth.auth().currentUser == nil {
            let resendAlert = UIAlertController(title: "Rapid Collect", message: "Sign In is Required to Edit Profile", preferredStyle: .alert)
            
            let  resendAction1 = UIAlertAction(title: "Sign In", style: .default) { (alert) in
        
        
                let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signin")
                UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)
                
                
                
            }
            
            let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.tabBarController?.selectedIndex = 0
            }
            resendAlert.addAction(resendAction1)
            resendAlert.addAction(cancelAlert)
            
            self.present(resendAlert,animated: true,completion: nil)
        }
        else {
        performSegue(withIdentifier: "editprofilesegue", sender: "UPLOAD DOCUMENTS")
        }
        closeMenu()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editprofilesegue" {
            if let dvc = segue.destination as? EditProfileViewController {
                dvc.mytitle = sender as? String
               
            }
        }
            
    }
    
    @objc func rapidgroupofcompaniesTapped() {
        Temp.btnName = "rapidgroup"
               gotoWeb()
    }
    
    
    @objc func rapidcollectionsystemTapped() {
        Temp.btnName = "rapidlegalsystem"
        gotoWeb()
    }
    
    
    @objc func rapidleaglTapped() {
        Temp.btnName = "rapidlegal"
        gotoWeb()
        
    }
    
    @objc func rapidpaymentTapped() {
        Temp.btnName = "rapidpayment"
       gotoWeb()
        
    }
    @objc func rapidtelecomsTapped() {
           Temp.btnName = "rapidtelecoms"
          gotoWeb()
           
       }
    @objc func rapidmobileTapped() {
           Temp.btnName = "mobilenetwork"
          gotoWeb()
           
       }
    func gotoWeb() {
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "web")
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    @objc func notificationTapped() {
        performSegue(withIdentifier: "notificationseg", sender: nil)
    }
    
    @objc func securityinfoTapped() {
        performSegue(withIdentifier: "securityseg", sender: nil)
    }
    
    @objc func locationTapped() {
        if Auth.auth().currentUser == nil {
            let resendAlert = UIAlertController(title: "Rapid Collect", message: "Sign In is Required to See Location History", preferredStyle: .alert)
            
            let  resendAction1 = UIAlertAction(title: "Sign In", style: .default) { (alert) in
                
                let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "signin")
                self.navigationController!.pushViewController(destViewController, animated: true)
            }
            
            let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.tabBarController?.selectedIndex = 0
            }
            resendAlert.addAction(resendAction1)
            resendAlert.addAction(cancelAlert)
            
            self.present(resendAlert,animated: true,completion: nil)
        }
        else  {
        performSegue(withIdentifier: "locationhistory", sender: nil)
        }
    }
    
    @objc func settingsTapped() {
        tabBarController?.selectedIndex = 4
        closeMenu()
    }
    
    @objc func currencyTapped() {
        let CurrencyConverterViewController1 = CurrencyConverterViewController()
        CurrencyConverterViewController1.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.navigationController?.present(CurrencyConverterViewController1, animated: false, completion: nil)
        closeMenu()
    }
    
    @objc func newsTapped() {
        tabBarController?.selectedIndex = 3
        closeMenu()
    }
    
    @objc func homeTapped() {
      
        closeMenu()
    }
    
    @objc func todoTapped() {
        
        tabBarController?.selectedIndex = 1
      closeMenu()
                
       
    }
    
    @objc func logoutTapped() {
        if Auth.auth().currentUser != nil {
            do {
            try Auth.auth().signOut()
                
                let pvc = self.presentingViewController
               let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "signin")
               self.navigationController!.pushViewController(destViewController, animated: true)
                pvc?.dismiss(animated: true, completion: nil)
                    
                
                
              
               
            }
            catch {
                
            }
        }
        else {
            let pvc = self.presentingViewController
           let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "signin")
           self.navigationController!.pushViewController(destViewController, animated: true)
            pvc?.dismiss(animated: true, completion: nil)
        }
        closeMenu()
    }
    
    func setDeatils() {
       
        let model = ProfileModel.getModel()
        self.profileImage.kf.setImage(with: URL(string: model.profileimage))
        self.name.text = model.name
        self.mail.text = model.mail
        
        
    }
    
   @objc func calculatorTapped() {
    performSegue(withIdentifier:"calculatorSegue", sender: nil)
    }
    
    override func viewWillLayoutSubviews() {
                let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                     let statusBarHeight: CGFloat = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        if bttomC != nil {
            bttomC.isActive = false
            
        }
               
               let h = tabBarController?.tabBar.frame.height
               let hh = h! + (navigationController?.navigationBar.frame.height)! + statusBarHeight + 10
            
               let c = fullView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -hh)
               NSLayoutConstraint.activate([c])
    }
 
    
    @objc func homeClicked() {
        
       saveButton(name: "home")
        
        delegate?.slideMenuItemSelectedAtIndex("home")
        
    }
    
    @objc func pricingClicked() {
        saveButton(name: "pricing")
        delegate?.slideMenuItemSelectedAtIndex("pricing")
       
    }
    
    @objc func notificationClicked() {
        if Auth.auth().currentUser == nil {
            let resendAlert = UIAlertController(title: "Rapid Collect", message: "Sign In is Required to Read Notification", preferredStyle: .alert)
            
            let  resendAction1 = UIAlertAction(title: "Sign In", style: .default) { (alert) in
                let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "signin")
                self.navigationController!.pushViewController(destViewController, animated: true)
            }
            
            let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.tabBarController?.selectedIndex = 0
            }
            resendAlert.addAction(resendAction1)
            resendAlert.addAction(cancelAlert)
            
            self.present(resendAlert,animated: true,completion: nil)
        }
        else {
            saveButton(name: "notification")
             delegate?.slideMenuItemSelectedAtIndex("notification")
        }
       
    }
    
    @objc func contactClicked() {
        saveButton(name: "contact")
             delegate?.slideMenuItemSelectedAtIndex("contact")
       
    }
    
    @objc func faqsClicked() {
        saveButton(name: "faqs")
             delegate?.slideMenuItemSelectedAtIndex("faqs")
    }
    
    
    
      @objc func shareClicked() {
             
              delegate?.slideMenuItemSelectedAtIndex("share")
      }
      
      @objc func rateClicked() {
        saveButton(name: "rate")
              delegate?.slideMenuItemSelectedAtIndex("rate")
      }
    @objc func settingsClicked() {
             saveButton(name: "settings")
               delegate?.slideMenuItemSelectedAtIndex("settings")
            
        }
      
      @objc func exitClicked() {
           
             delegate?.slideMenuItemSelectedAtIndex("exit")
          
      }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    

    @IBAction func onCloseMenuClick(_ button:UIButton!){
        print("hello")
        
        closeMenu()
    }

   
    func closeMenu() {
                
        
                btnMenu.tag = 0
                if (self.delegate != nil) {
        //            var index = Int32(button.tag)
        //            if(button == self.btnCloseMenuOverlay){
        //                index = -1
        //            }
                    delegate?.slideMenuItemSelectedAtIndex("-1")
                }
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
                    self.view.layoutIfNeeded()
                    self.view.backgroundColor = UIColor.clear
                    }, completion: { (finished) -> Void in
                        self.view.removeFromSuperview()
                        self.removeFromParent()
                })
    }
    
    func saveButton(name : String) {
        
        Temp.btnName = name

    }
    
    func downloadDoc() {
        if let link = URL(string: "https://rapidcollect.co.za/wp-content/uploads/2020/07/L3-On-Boarding_Registration-Pack-Rapid-Collect.zip") {
          UIApplication.shared.open(link)
        }
    }

    
        
}

extension UIApplication {
    
   

    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
