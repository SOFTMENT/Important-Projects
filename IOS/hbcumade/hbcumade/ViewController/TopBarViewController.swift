import UIKit
import SDWebImage


protocol TopBarDelegate {
    func classificationBtnClicked()
    func searchBtnClicked()
    func messengerBtnClicked()
}
class TopBarViewController: UIViewController {
  
    
    var classificationDelegate : TopBarDelegate?

    @IBOutlet weak var searchBtn: UIImageView!
    @IBOutlet weak var classificationBtn: UIImageView!
    @IBOutlet weak var messengerBtn: UIImageView!
    
    
    
    //    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var menuBtn: UIImageView!
    override func viewDidLoad() {
         
        classificationBtn.isUserInteractionEnabled = true
        classificationBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(classificationBtnTapped)))
      
//        self.searchTextField.setLeftPaddingPoints(10)
//        self.searchTextField.setRightPaddingPoints(10)
//        self.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search...",
//                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
//
       
//        if Constants.selected_classification == "student" {
//         
//            classificationBtn.image = UIImage(named: "reading-book")
//            loadViewIfNeeded()
//        }
//        else {
//      
//            classificationBtn.image = UIImage(named: "graduate-cap")
//            loadViewIfNeeded()
//        }
    }

   
    
    
    
    @objc func classificationBtnTapped(){
        if Constants.selected_classification == "student" {
            Constants.selected_classification = "alumni"
            classificationBtn.image = UIImage(named: "reading-book")
            loadViewIfNeeded()
        }
        else {
          
            Constants.selected_classification = "student"
            classificationBtn.image = UIImage(named: "graduate-cap")
            loadViewIfNeeded()
        }
       
        
        classificationDelegate?.classificationBtnClicked()
        
       
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Constants.selected_classification == "student" {
           
            classificationBtn.image = UIImage(named: "graduate-cap")
            loadViewIfNeeded()
        }
        else {
          
            classificationBtn.image = UIImage(named: "reading-book")
            loadViewIfNeeded()
        }
    }
   
}

