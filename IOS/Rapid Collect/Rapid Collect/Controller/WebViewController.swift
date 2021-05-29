//
//  PricingViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 12/03/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import WebKit
import Lottie

class WebViewController: BaseViewController, WKUIDelegate,WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    var flag = false
    var animationView : AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let btnShowMenu = UIButton(type: UIButton.ButtonType.custom)
        let btnBack = UIButton(type: UIButton.ButtonType.custom)
        btnShowMenu.setImage(UIImage(named: "icons8-menu-rounded-100-2"), for: .normal)
        btnBack.setImage(UIImage(named: "icons8-back-100"), for: .normal)
        btnBack.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 10  , height: 10)
        
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        btnBack.addTarget(self, action: #selector(backCliked), for: UIControl.Event.touchUpInside)
        
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        let backBarItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItems = [backBarItem, customBarItem];
        
        switch Temp.btnName {
            
        case "insurance" :
            navigationItem.title = "INSURANCE"
            loadWeb(myurl: "https://micover.co.za")
            break
            
        case "debtcollection" :
            navigationItem.title = "DEBT COLLECTION"
            loadWeb(myurl: "https://rapidlegalservices.co.za")
            break
            
        case "cashbundle" :
            navigationItem.title = "CASH BUNDLE"
            loadWeb(myurl: "https://rapidcollect.co.za/rapid-cash-bundle/")
            break
            
       
            case "debitorder" :
                navigationItem.title = "DEBIT ORDERS"
                loadWeb(myurl: "https://rapidcollect.co.za/debit-orders/")
                break
            case "naedo":
                navigationItem.title = "NAEDO"
                loadWeb(myurl: "https://rapidcollect.co.za/naedo/")
                break
             
            case "rapidavs" :
                navigationItem.title = "RAPID AVS & AHV"
                loadWeb(myurl: "https://rapidcollect.co.za/rapid-avs-ahv/")
                break
            case "rapidsdo":
                navigationItem.title = "STRIKE DATE OPTIMIZATION"
                loadWeb(myurl: "https://rapidcollect.co.za/strike-date-optimization/")
                break
             
            case "debitCheck" :
                navigationItem.title = "DebiCheck"
                loadWeb(myurl: "https://rapidcollect.co.za/debicheck/")
                break
            case "digi":
                navigationItem.title = "digiMandateTM"
                loadWeb(myurl: "https://rapidcollect.co.za/digimandate/")
                break
             
            case "cloud" :
                navigationItem.title = "CLOUD INVOICING"
                loadWeb(myurl: "https://rapidcollect.co.za/cloud-invoicing/")
                break
            
        case "accre" :
            navigationItem.title = "ACCREDITATION"
            loadWeb(myurl: "https://rapidcollect.co.za/accreditation/")
            break
            
        case "aboutus" :
            navigationItem.title = "ABOUT US"
            loadWeb(myurl: "https://rapidcollect.co.za/about-us/")
            
            case "pricing":
            navigationItem.title = "PRICING"
            loadWeb(myurl: "https://rapidcollect.co.za/our-pricing/")
            break
         
        case "faqs" :
            navigationItem.title = "FAQs"
            loadWeb(myurl: "https://rapidcollect.co.za/faq/")
            break
            
            
            case "login" :
            navigationItem.title = "LOGIN"
            loadWeb(myurl: "https://so.rapidcollect.co.za/scripts/users/sys_login.php")
            break
            
            case "debitregi" :
                     navigationItem.title = "DEBIT ORDERS"
                     loadWeb(myurl: "https://rapidcollect.co.za/register-for-debit-orders/")
                     break
            
            case "paymentregi" :
                                navigationItem.title = "PAYMENTS"
                                loadWeb(myurl: "https://rapidcollect.co.za/register-for-payments/")
                                break
                                
            case "mobilenetwork" :
                         navigationItem.title = "RAPID MOBILE NETWORK"
                    
                         loadWeb(myurl: "https://www.rapidmobile.co.za")
                         break
            
            case "rapidlegal" :
                              navigationItem.title = "RAPID LEGAL SERVICES"
                         
                              loadWeb(myurl: "https://rapidlegalservices.co.za")
                              break
            
            case "rapidlegalsystem" :
                              navigationItem.title = "RAPID COLLECTION SOFTWARE SYSTEM"
                         
                              loadWeb(myurl: "https://www.rapidcss.co.za")
                              break
            
            case "rapidgroup" :
                              navigationItem.title = "RAPID GROUP OF COMPANIES"
                         
                              loadWeb(myurl: "https://www.rapidgroup.co.za")
                              break
            
                             
            case "terms" :
                         navigationItem.title = "TERMS AND CONDITIONS"
                    
                         loadWeb(myurl: "https://rapidcollect.co.za/terms-and-conditions/")
                         break
            
            case "about" :
                    navigationItem.title = "ABOUT US"
                    loadWeb(myurl: "https://rapidcollect.co.za/about-us/")
                                  break
            
            case "doc" :
                             navigationItem.title = "SUPPORTED DOCUMENTS"
                             loadWeb(myurl: "https://rapidcollect.co.za/fica")
                                           break
            
            case "rapidpayment" :
                                       navigationItem.title = "RAPID PAYMENTS"
                                       loadWeb(myurl: "https://rapidpayments.africa")
                                                     break
            
            case "rapidtelecoms" :
                                       navigationItem.title = "RAPID TELECOMS"
                                       loadWeb(myurl: "https://rapidtelecoms.com")
                                                     break
            
        default:
            print("Default")
        }
        
        animationView = AnimationView(name: "load")
        animationView!.frame = self.loadingView.bounds
        self.loadingView.addSubview(animationView!)
        animationView!.play()
        animationView!.loopMode = .loop
        
        webView.uiDelegate  =  self
        webView.navigationDelegate = self
        
        progressView.progress = 0.0
        progressView.tintColor = UIColor.blue
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addSubview(progressView)
        
        
        

        // Do any additional setup after loading the view.
    }
    
   
    
    
    internal func loadWebPage(fromCache isCacheLoad: Bool, url : URL) {

        
         let request = URLRequest(url: url, cachePolicy: (isCacheLoad ? .returnCacheDataElseLoad: .reloadRevalidatingCacheData), timeoutInterval: 50)
             //URLRequest(url: url)
         DispatchQueue.main.async { [weak self] in
            self?.webView.load(request)
              
             
         }
     }
    
    @objc func backCliked() {
        if(webView.canGoBack) {
            //Go back in webview history
            webView.goBack()
        } else {
            //Pop view controller to preview view controller
          self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
           if keyPath == "estimatedProgress" {
            if self.flag {
                self.progressView.alpha = 1.0
                                     progressView.setProgress(Float(webView.estimatedProgress), animated: true)
                                     if webView.estimatedProgress >= 1.0 {
                                         UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                                             self.progressView.alpha = 0.0
                                         }) { (BOOL) in
                                             self.progressView.progress = 0
                                         }
                                         
                                     }
                                     
            }
            else {
                if webView.estimatedProgress >= 1.0 {
                    flag = true
                    self.animationView?.stop()
                    self.loadingView.isHidden = true
                }
            }
                    
        }
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func loadWeb(myurl : String) {
        let urls = URL(string:myurl)
       
       if CheckConnection.isConnectedToNetwork(){
        loadWebPage(fromCache: false,url: urls!)
        }else{
        loadWebPage(fromCache: true, url: urls!)
        }
    }
}
