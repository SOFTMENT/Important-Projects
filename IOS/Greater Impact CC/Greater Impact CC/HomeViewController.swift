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
    
//    NotificationCenter.default.addObserver(self, selector: #selector(doSomething), name: UIApplication.willEnterForegroundNotification, object: nil)
//
        // Do any additional setup after loading the view.
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
//    
//    @objc private func doSomething() {
//          if delegate.body != "message" {
//              let alert = UIAlertController(title: delegate.title, message: delegate.body, preferredStyle: UIAlertController.Style.alert)
//              alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//          self.present(alert, animated: true, completion: nil)
//          }
//      }
    
    @IBAction func backPressed(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
        
    }
    @IBAction func refresh(_ sender: Any) {
        webView.reload()
    }
    override func viewWillAppear(_ animated: Bool) {
           let urls = URL(string:"http://greaterimpact.cc")
           let request = URLRequest(url: urls!)
           webView.load(request)
       }
}
