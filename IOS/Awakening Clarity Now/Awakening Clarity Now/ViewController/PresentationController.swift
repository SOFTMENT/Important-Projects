//
//  PresentationController.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 22/05/21.
//


import UIKit
import StoreKit
import Firebase
import FirebaseAuth

class PresentationController: UIPresentationController{

  let blurEffectView: UIView!
    let settingsVC : SettingsViewController?
  var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var isBlurBtnSelected = false
    var tabBarController : UITabBarController?
  
   init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?,settingsVC : SettingsViewController ) {
    
        self.settingsVC = settingsVC
        
    
      blurEffectView = UIView()
      blurEffectView.backgroundColor = UIColor.clear
      
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
   
    tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissController(r:)))
     
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.blurEffectView.isUserInteractionEnabled = true
    blurEffectView.tag = 2
      self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
   
    
  }
    

    

  override var frameOfPresentedViewInContainerView: CGRect {
    
    return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.46 ),
             size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
              0.54))
  }

  override func presentationTransitionWillBegin() {
  
    
            
      self.containerView?.addSubview(blurEffectView)
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
    
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
  }
  
  override func dismissalTransitionWillBegin() {
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
        
    
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.removeFromSuperview()
        if !self.isBlurBtnSelected {
            self.dismissController(r: UITapGestureRecognizer())
        }
        
           
      })
  }
  
  override func containerViewWillLayoutSubviews() {
      super.containerViewWillLayoutSubviews()
    presentedView!.roundCorners([.topLeft, .topRight], radius: 50)
  }

  override func containerViewDidLayoutSubviews() {
      super.containerViewDidLayoutSubviews()
      presentedView?.frame = frameOfPresentedViewInContainerView
      blurEffectView.frame = containerView!.bounds
  }

   @objc  func dismissController(r : UITapGestureRecognizer){
    if r.view?.tag == 2 {
        isBlurBtnSelected = true
    }
    else {
        isBlurBtnSelected = false
    }

    self.presentedViewController.dismiss(animated: true, completion: nil)
  }
}

extension UIView {
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      layer.mask = mask
  }
}

