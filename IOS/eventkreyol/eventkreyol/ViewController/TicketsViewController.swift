//
//  TicketsViewController.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 26/07/21.
//

import UIKit

class TicketsViewController: UIViewController {
    
    @IBOutlet weak var pastContainer: UIView!
    @IBOutlet weak var upcomingContainer: UIView!
    @IBOutlet weak var headView: UIView!
    override func viewDidLoad() {
    
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        headView.addBottomShadow()
        pastContainer.isHidden = true
    }
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        upcomingContainer.isHidden = true
        pastContainer.isHidden = true
        
        if sender.selectedSegmentIndex == 0 {
            upcomingContainer.isHidden = false
        }
        else {
            pastContainer.isHidden = false
        }
    }
}
