//
//  ProfileView.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 05/06/21.
//

import UIKit

class ProfileView: UIViewController {
    
  
    
    @IBOutlet weak var membershipImg: UIImageView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var slideIndicator: UIView!
    @IBOutlet weak var goPremiumView: UIView!
    @IBOutlet weak var goPremiumText: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var accountType: UILabel!

    @IBOutlet weak var rateUs: UILabel!
    @IBOutlet weak var logout: UILabel!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var softment: UILabel!
    @IBOutlet weak var privacyPolicy: UILabel!
    @IBOutlet weak var shareApp: UILabel!
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        slideIndicator.layer.cornerRadius = 10
        goPremiumView.layer.cornerRadius = 8
        

    }
    
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
         view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
    
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}

