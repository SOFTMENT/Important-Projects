//
//  NewsRoomViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 16/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WebKit

class ShowNewRoomContent: UIViewController , WKNavigationDelegate{

 
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var scrollviews: UIScrollView!

    @IBOutlet weak var myTitle: UILabel!
    
 

    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var viewCons: NSLayoutConstraint!
    var wordpressmodel : WordpressModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      webView.navigationDelegate = self
    self.webView.sizeToFit()
    self.webView.contentMode = .scaleAspectFit
      webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil);
  
       webView.scrollView.isScrollEnabled = false
        let content = "<style>img{display: block;height: auto;max-width: 100%; width : 1600 }  iframe { display: block;max-width:100%;width:1600;height : 600 ;margin-top:10px; margin-bottom:10px;} body {font-size : 28px;} </style>"+wordpressmodel.content
        webView.loadHTMLString(content, baseURL: URL(string : "https://www.rapidcollect.co.za")!)
        
        myTitle.text = wordpressmodel.title
        img.kf.setImage(with: URL(string: wordpressmodel.thumbnail))
        
        
        

}
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let o = object as? NSObject {
            if let size = o.value(forKey: "contentSize") as? CGSize{
                print(size)
                viewCons.constant = size.height + 230
                print(viewCons.constant)
            }
        
        }
        
    }
    
    


  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
  
     
        
    }

 
    
   
}




