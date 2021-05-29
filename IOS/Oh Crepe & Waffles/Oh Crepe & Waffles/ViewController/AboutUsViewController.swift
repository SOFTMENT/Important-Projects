//
//  AboutUsViewController.swift
//  Oh Crepe & Waffles
//
//  Created by Vijay on 06/05/21.
//

import UIKit
import AMTabView

class AboutUsViewController: UIViewController,TabItem {
    
    @IBOutlet weak var softment: UILabel!

    @IBOutlet weak var email: UITextView!
    var tabImage: UIImage? {
      return UIImage(named: "group")
    }

    
    override func viewDidLoad() {
        email.dataDetectorTypes = .all
       
        
        softment.isUserInteractionEnabled = true
        softment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToSoftmentWebsite)))
    }
    
    @objc func redirectToSoftmentWebsite() {
       
        guard let url = URL(string: "https://softment.in") else { return }
        UIApplication.shared.open(url)
    }
    
}
