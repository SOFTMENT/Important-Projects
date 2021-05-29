import UIKit
import SDWebImage

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ name : String)
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var newsFeed: UIView!
    @IBOutlet weak var classificationImage: UIImageView!
    @IBOutlet weak var classificationText: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var myaccount: UIView!
    @IBOutlet weak var directory: UIView!
    @IBOutlet weak var group: UIView!
    
    var btnMenu : UIImageView!
    var delegate : SlideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myaccount.isUserInteractionEnabled = true
        myaccount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuViewController.myAccountTapped)))
        
        
        directory.isUserInteractionEnabled = true
        directory.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuViewController.directoryBtnTapped)))
        
        newsFeed.isUserInteractionEnabled = true
        newsFeed.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuViewController.newsFeedTapped)))
        
        group.isUserInteractionEnabled = true
        group.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuViewController.groupBtnTapped)))
        
        profileView.isUserInteractionEnabled = true
        profileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuViewController.profileBtnTapped)))
        
        
        profilePic.makeRounded()
        
        let userData = UserData.data
        if userData != nil {
            if let sName = userData?.name {
                name.text = sName
            }
            if let sProfile = userData?.profile {
                profilePic.sd_setImage(with: URL(string: sProfile), placeholderImage: UIImage(named: "profile-user"))
            }
        }
       
      
    }
    
    
      @objc func profileBtnTapped() {
          closeMenu()
       //   beRootScreen(mIdentifier: Constants.StroyBoard.profileVC)

      }
  
    @objc func groupBtnTapped() {
        closeMenu()
      //  beRootScreen(mIdentifier: Constants.StroyBoard.groupVC)

    }
    
    @objc func myAccountTapped() {
      // closeMenu()
      //  navigateToAnotherScreen(mIdentifier: Cons)
    }
    
    @objc func directoryBtnTapped() {
        closeMenu()
        beRootScreen(mIdentifier: Constants.StroyBoard.networkViewController)
        
    }
    
    @objc func newsFeedTapped() {
       closeMenu()
        beRootScreen(mIdentifier: Constants.StroyBoard.homeViewController)
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        closeMenu()
    }
    
    func closeMenu() {
                
                btnMenu.tag = 0
                if (self.delegate != nil) {
                    
                    delegate?.slideMenuItemSelectedAtIndex("-1")
                }
        
        let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
         let yh = 70 + height
        
   
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: yh, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height - height)
                    self.view.layoutIfNeeded()
                    self.view.backgroundColor = UIColor.clear
                    }, completion: { (finished) -> Void in
                        self.view.removeFromSuperview()
                        self.removeFromParent()
                })
    }
}

    


