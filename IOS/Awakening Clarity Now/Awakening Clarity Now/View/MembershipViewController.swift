//
//  MembershipViewController.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 05/06/21.
//

import UIKit

class MembershipViewController : UIViewController {
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    @IBOutlet weak var termsofuse: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
    @IBOutlet weak var privacypolicy: UILabel!
    @IBOutlet weak var slide: UIView!
    @IBOutlet weak var restoreButton: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        purchaseButton.layer.cornerRadius = 6
        purchaseButton.layer.borderWidth = 1
        purchaseButton.layer.borderColor = UIColor.green.cgColor
        restoreButton.layer.cornerRadius = 4
        slide.layer.cornerRadius = 10
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
