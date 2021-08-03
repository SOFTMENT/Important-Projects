//
//  ProfilePresentationController.swift
//  Awakening Clarity Now
//
//  Created by Vijay Rathore on 05/06/21.
//


import UIKit
import StoreKit
import Firebase
import FirebaseAuth

class ProfilePresentationController: UIPresentationController{

  let blurEffectView: UIView!
  let homeVC : HomeViewController?
  var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var isBlurBtnSelected = false
    var tabBarController : UITabBarController?
  
   init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?,homeVC : HomeViewController ) {
    
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
     
        if let tabbbar = homeVC?.tabBarController as? TabBarController {
            tabbbar.showMembershipController()
        }
        
       
    }
    
    @objc func redirectToSoftmentWebsite() {
        dismissController(r: UITapGestureRecognizer())
        guard let url = URL(string: "https://softment.in") else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func redirectToPrivacyPolicy() {
        
        dismissController(r: UITapGestureRecognizer())
        guard let url = URL(string: "https://freddavis.app/privacy.html") else { return}
        UIApplication.shared.open(url)
        
  }
    
    
    @objc func shareApp() {
        dismissController(r: UITapGestureRecognizer())
        if let name = URL(string: "https://itunes.apple.com/us/app/Awakening-Clarity-Now/id1568854541?ls=1&mt=8"), !name.absoluteString.isEmpty {
          let objectsToShare = [name]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
          self.homeVC!.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @objc func rateUs() {
        dismissController(r: UITapGestureRecognizer())
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }

          }
         else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "1568854541") {
            
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

        }
         
    }
    
    @objc func logout() {
        dismissController(r: UITapGestureRecognizer())
        do {
           try Auth.auth().signOut()
           homeVC?.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
        }
        catch {
            print("SignOut Error")
        }
    }
    
  override var frameOfPresentedViewInContainerView: CGRect {
    
    return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.46 ),
             size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
              0.54))
  }

  override func presentationTransitionWillBegin() {
     self.homeVC!.updateOverlayUI()
//
//    //GO PREMIUM
     homeVC?.slideVC.goPremiumView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goPremiumBtnClicked)))
//
    //SOFTMENT
    homeVC?.slideVC.softment.isUserInteractionEnabled = true
    homeVC?.slideVC.softment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToSoftmentWebsite)))
    
    //PrivacyPolicy
    homeVC?.slideVC.privacyPolicy.isUserInteractionEnabled = true
    homeVC?.slideVC.privacyPolicy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToPrivacyPolicy)))
    
    
    //shareapp
    homeVC?.slideVC.shareApp.isUserInteractionEnabled = true
    homeVC?.slideVC.shareApp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareApp)))
    
    //RateUs
    homeVC?.slideVC.rateUs.isUserInteractionEnabled = true
    homeVC?.slideVC.rateUs.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rateUs)))
    
    //Logout
    homeVC?.slideVC.logout.isUserInteractionEnabled = true
    homeVC?.slideVC.logout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logout)))
    
    
    //Name
    homeVC?.slideVC.name.text = UserModel.data?.name
    homeVC?.slideVC.email.text = UserModel.data?.emailAddress
    
    
    
            
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
//
//extension UIView {
//  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
//      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
//                              cornerRadii: CGSize(width: radius, height: radius))
//      let mask = CAShapeLayer()
//      mask.path = path.cgPath
//      layer.mask = mask
//  }
//}
//
