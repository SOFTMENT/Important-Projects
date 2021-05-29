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
    
    
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressBar: UIProgressView!
   override func viewDidLoad() {
        super.viewDidLoad()
    
        webView.uiDelegate  =  self
        webView.navigationDelegate = self
        progressBar.progress = 0.0
               progressBar.tintColor = UIColor.red
               webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
              webView.addSubview(progressBar)
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
    webView.scrollView.addSubview(refreshControl)
    webView.scrollView.bounces = true
    
//    NotificationCenter.default.addObserver(self, selector: #selector(doSomething), name: UIApplication.willEnterForegroundNotification, object: nil)
//
        // Do any additional setup after loading the view.
    }
    
    @objc
    func refreshWebView(_ sender: UIRefreshControl) {
        webView?.reload()
        sender.endRefreshing()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
           if keyPath == "estimatedProgress" {
                     self.progressBar.alpha = 1.0
                      progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
                      if webView.estimatedProgress >= 1.0 {
                          UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                              self.progressBar.alpha = 0.0
                          }) { (BOOL) in
                              self.progressBar.progress = 0
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

    @IBAction func back(_ sender: Any) {
        
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
           let urls = URL(string:"https://rincondegalicia.es")
           let request = URLRequest(url: urls!)
           webView.load(request)
       }
    
    @IBAction func refresh(_ sender: Any) {
        
        webView.reload()
    }
    
}
