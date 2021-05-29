//
//  InstagramFeedViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 21/05/21.
//

import UIKit
import WebKit

class InstagramFeedViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        webview.load(URLRequest(url: URL(string: "https://www.instagram.com/awakeningclaritynow/?hl=en")!))
    }
}
