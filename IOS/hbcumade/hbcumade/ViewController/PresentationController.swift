//
//  PresentationController.swift
//  hbcumade
//
//  Created by Vijay on 23/03/21.
//


import UIKit

class PresentationController: UIPresentationController{


    var blurEffectView: UIView!
  var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var isBlurBtnSelected = false
    var tabBarController : UITabBarController?
  
  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    
      
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    
          blurEffectView = UIView()
          blurEffectView.backgroundColor = UIColor.clear
      

      tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissController(r:)))
     
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.blurEffectView.isUserInteractionEnabled = true
    blurEffectView.tag = 2
      self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
   
    
  }
    

    @objc func viewProfileClicked() {
        
        Constants.previousSelectedTabIndex = 4
        dismissController(r: UITapGestureRecognizer())
        
    
    }
    
    @objc func adminClicked(){
        gotoAnotherController(identifier: "adminhomeseg")
    }
    
    @objc func networkClicked() {
     
            
            Constants.previousSelectedTabIndex = 1
            dismissController(r: UITapGestureRecognizer())
        
        
    }
    
    @objc func accountSettingsClicked() {
        
        gotoAnotherController(identifier: "editprofileseg")
        
    }
    
    @objc func logoutBtnPressed() {
        tabBarController?.logout()
    }
    
   
    
    func gotoAnotherController(identifier : String) {
      
        if let tabBarController = tabBarController {
         
            
          let vc =  tabBarController.viewControllers![2]
            if let nav = vc as? UINavigationController  {
                if nav.topViewController is CommonPresentViewController2 {
                    let nvc = nav.topViewController as! CommonPresentViewController2
                    nvc.myPerformSegue(mIdentifier: identifier)
                
                   
                }
                else {
                    nav.popToRootViewController(animated: false)
                    let nvc = nav.topViewController as! CommonPresentViewController2
                    nvc.myPerformSegue(mIdentifier: identifier)
                  
                }
              
                
            }
        }
        
        dismissController(r: UITapGestureRecognizer())
        Constants.previousSelectedTabIndex = 2
        
    }
    
    
    @objc func redirectToContactUs() {
        dismissController(r: UITapGestureRecognizer())
        let email = "info@hbcumade.app"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    @objc func redirectToPrivacyPolicy() {
       
        dismissController(r: UITapGestureRecognizer())
        guard let url = URL(string: "https://www.hbcumade.app/privacypolicy") else { return}
        UIApplication.shared.open(url)
    }

    
  override var frameOfPresentedViewInContainerView: CGRect {

    return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.5 - (Constants.safeAreaHeight + Constants.tabBarHeight)),
             size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
              0.5))
  }

  override func presentationTransitionWillBegin() {
    if let tabBarController = self.presentingViewController.view.window!.rootViewController as? TabBarController {
        self.tabBarController = tabBarController
    
        tabBarController.slideVC.viewProfile.isUserInteractionEnabled = true
        tabBarController.slideVC.viewProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewProfileClicked)))
        
        tabBarController.slideVC.network.isUserInteractionEnabled = true
        tabBarController.slideVC.network.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(networkClicked)))
        
        tabBarController.slideVC.accountSettings.isUserInteractionEnabled = true
        tabBarController.slideVC.accountSettings.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accountSettingsClicked)))
        
       
        tabBarController.slideVC.logout.isUserInteractionEnabled = true
        tabBarController.slideVC.logout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutBtnPressed)))

        tabBarController.slideVC.profilePicture.makeRounded()
       
         if let profileImageLink = UserData.data?.profile {
            if profileImageLink != "" {
                tabBarController.slideVC.profilePicture.sd_setImage(with: URL(string: profileImageLink), placeholderImage: UIImage(named: "profile-user"))
            }
           
         }
        
        tabBarController.slideVC.contactUs.isUserInteractionEnabled = true
        tabBarController.slideVC.contactUs.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToContactUs)))
        
        
        tabBarController.slideVC.privacyPolicy.isUserInteractionEnabled = true
        tabBarController.slideVC.privacyPolicy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToPrivacyPolicy)))
        
        tabBarController.slideVC.admin.isUserInteractionEnabled = true
        tabBarController.slideVC.admin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(adminClicked)))
        
        
        tabBarController.slideVC.schoolName.text = UserData.data?.school
        tabBarController.slideVC.name.text = UserData.data?.name!
    
    }
  
            
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
    presentedView!.roundCorners([.topLeft, .topRight], radius: 26)
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
    
    if let tabBarController = self.presentingViewController.view.window!.rootViewController as? TabBarController {
        
        tabBarController.selectedIndex = Constants.previousSelectedTabIndex
        
        let tabBarItems = tabBarController.tabBar.items![Constants.previousSelectedTabIndex]
        
        if Constants.previousSelectedTabIndex  == 0{
            tabBarItems.selectedImage = UIImage(named: "icons8-home-100-3")?.withRenderingMode(.alwaysOriginal)
        }
       else if Constants.previousSelectedTabIndex  == 1{
        tabBarItems.selectedImage = UIImage(named: "icons8-add-user-group-man-man-96-2")?.withRenderingMode(.alwaysOriginal)
        }
       else if Constants.previousSelectedTabIndex  == 3{
        tabBarItems.selectedImage = UIImage(named: "icons8-facebook-messenger-96-2")?.withRenderingMode(.alwaysOriginal)
        }
        else if Constants.previousSelectedTabIndex  == 4{
            tabBarItems.selectedImage = UIImage(named: "icons8-user-96-2")?.withRenderingMode(.alwaysOriginal)
        }
        
        
        
        let tabBarItems1 = tabBarController.tabBar.items![2]
        tabBarItems1.image = UIImage(named: "hwhite")?.withRenderingMode(.alwaysOriginal)
        
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

