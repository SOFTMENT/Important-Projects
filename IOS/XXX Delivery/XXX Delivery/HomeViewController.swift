//
//  HomeViewController.swift
//  Sweet Tooth
//
//  Created by Vijay Rathore on 20/03/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import WebKit

class HomeViewController: UIViewController, WKUIDelegate,WKNavigationDelegate {
 let delegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var im: UIImageView!
    @IBOutlet weak var webView: WKWebView!
  
   override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate  =  self
        webView.navigationDelegate = self
       

               webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
            
    

    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
           if keyPath == "estimatedProgress" {
                  self.im.isHidden = true
                      //progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
                      if webView.estimatedProgress >= 1.0 {
                        
                          UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                           //   self.progressBar.alpha = 0.0
                            
                          }) { (BOOL) in
                             // self.progressBar.progress = 0
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

  
    override func viewWillAppear(_ animated: Bool) {
           let urls = URL(string:"https://shop.xxxdelivery.com.au")
           let request = URLRequest(url: urls!)
           webView.load(request)
       }
}
