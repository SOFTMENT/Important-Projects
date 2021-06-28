//
//  MembershipPresentationController.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 05/06/21.
//


import UIKit

class MembershipPresentationController: UIPresentationController{

  let blurEffectView: UIView!
    let homeVC : TabBarController?
  var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var isBlurBtnSelected = false
    var tabBarController : UITabBarController?
  

    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?,homeVC : TabBarController) {
    
        self.homeVC = homeVC
        
    
      blurEffectView = UIView()
      blurEffectView.backgroundColor = UIColor.clear
      
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
   
    tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissController(r:)))
     
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.blurEffectView.isUserInteractionEnabled = true
    blurEffectView.tag = 2
      self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
   
    
  }
    

    
    
    @objc func goPremiumBtnClicked() {
    dismissController(r: UITapGestureRecognizer())
        homeVC?.purchaseMembershipBtnTapped()
    }
    
    @objc func restorePurchase(){
        dismissController(r: UITapGestureRecognizer())
        homeVC?.restorePurchase()
    }
    
    @objc func termsOfUse() {
        dismissController(r: UITapGestureRecognizer())
        guard let url = URL(string: "https://softment.in/terms-of-service/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func privacyPolicy() {
        guard let url = URL(string: "https://www.privacypolicies.com/live/5469f36c-7492-43fa-ba1a-0c0212fc8ed9") else { return}
        UIApplication.shared.open(url)
    }
    
  override var frameOfPresentedViewInContainerView: CGRect {
    
//    homeVC?.slideVC.goPremiumView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goPremiumBtnClicked)))
   
    return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.3 ),
             size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
              0.7))
  }

  override func presentationTransitionWillBegin() {
    //self.homeVC!.updateOverlayUI()
    self.homeVC?.membershipOverlay.purchaseButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goPremiumBtnClicked)))
          
    self.homeVC?.membershipOverlay.restoreButton.isUserInteractionEnabled = true
    self.homeVC?.membershipOverlay.restoreButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(restorePurchase)))
    
    self.homeVC?.membershipOverlay.termsofuse.isUserInteractionEnabled = true
    self.homeVC?.membershipOverlay.privacypolicy.isUserInteractionEnabled = true
    
    self.homeVC?.membershipOverlay.termsofuse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsOfUse)))
    
    self.homeVC?.membershipOverlay.privacypolicy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(privacyPolicy)))

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



