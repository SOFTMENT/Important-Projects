//
//  FavouritesViewController.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 27/07/21.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var headView: UIView!

    @IBOutlet weak var organiserContainer: UIView!
    @IBOutlet weak var eventContainer: UIView!
    override func viewDidLoad() {
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        headView.addBottomShadow()
        organiserContainer.isHidden = true
        
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        
        eventContainer.isHidden = true
        organiserContainer.isHidden = true
        
        if sender.selectedSegmentIndex == 0 {
            eventContainer.isHidden = false
        }
        else {
            organiserContainer.isHidden = false
        }
    }
    
}
