//
//  OverlayView.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 21/05/21.
//

import UIKit

class OverlayView: UIViewController {

    @IBOutlet weak var slide: UIView!
    @IBOutlet weak var no: UIButton!
    @IBOutlet weak var yes: UIButton!
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var standard = UserDefaults.standard
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slide.layer.cornerRadius = 6
        
        //No
        no.isUserInteractionEnabled = true
        no.layer.cornerRadius = 12
        
        //YES
        yes.isUserInteractionEnabled = true
        yes.layer.cornerRadius = 12

        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        
        if let status = standard.string(forKey: "claritystatus") {
            if status == "yes" {
                no.backgroundColor = .gray
                yes.backgroundColor = .white
            }
            else {
                no.backgroundColor = .white
                yes.backgroundColor = .gray
            }
        }
        else {
            no.backgroundColor = .white
            yes.backgroundColor = .gray
        }
        
       
    }
    
    


    @IBAction func yesBtnTapped(_ sender: Any) {
        no.backgroundColor = .gray
        yes.backgroundColor = .white
        
        standard.set("yes", forKey: "claritystatus")
    }
    
  
    @IBAction func noBtnTapped(_ sender: Any) {
        
        no.backgroundColor = .white
        yes.backgroundColor = .gray
        standard.set("no", forKey: "claritystatus")
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
