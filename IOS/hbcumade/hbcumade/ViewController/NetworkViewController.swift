//
//  NetworkViewController.swift
//  hbcumade
//
//  Created by Vijay on 05/04/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import DropDown

class NetworkViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    

    @IBOutlet weak var directorySearchEditField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gridStack: UIStackView!
    @IBOutlet weak var registeredUser: UILabel!
    @IBOutlet weak var searchBtn: UIView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var allText: UILabel!
    @IBOutlet weak var studentView: UIView!
    @IBOutlet weak var studentText: UILabel!
    @IBOutlet weak var alumniView: UIView!
    @IBOutlet weak var alumniText: UILabel!
    @IBOutlet weak var inviteView: UIView!
    
    @IBOutlet weak var sigleCellBtn: UIView!
    @IBOutlet weak var doubleCellBtn: UIView!
    @IBOutlet weak var trippleCellBtn: UIView!
    
    let sigleCellHeight = 96
    let doubleCellHeight = 166
    let trippleCellHeight = 152
    
    var allUserData = Array<UserData>()
    var allUserDataAfterFilter = Array<UserData>()
    
    @IBOutlet weak var sortText: UILabel!
    var selectedType = "single"
    var totalColumn = 1
    var filterStatus = "all"
    var sortStatus = "latest"
    @IBOutlet weak var sortView: UIView!
    
    let menu = DropDown()
    override func viewDidLoad() {
        
        
        directorySearchEditField.attributedPlaceholder = NSAttributedString(string: "Search...",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        directorySearchEditField.setLeftPaddingPoints(10)
        directorySearchEditField.setRightPaddingPoints(10)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
   
        DispatchQueue.main.async {
            self.refreshCollectionViewHeight()
        }
       
        //CollectionView
        collectionView.register(UINib(nibName: "NetworkSingleViewCell", bundle: nil), forCellWithReuseIdentifier: "networksinglecell")
        collectionView.register(UINib(nibName: "NetworkDoubleViewCell", bundle: nil), forCellWithReuseIdentifier: "networkdoublecell")
        collectionView.register(UINib(nibName: "NetworkTrippleViewCell", bundle: nil), forCellWithReuseIdentifier: "networktripplecell")
        
      
        //CellBtn
        sigleCellBtn.isUserInteractionEnabled = true
        sigleCellBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(singleCellBtnClicked)))
        
        doubleCellBtn.isUserInteractionEnabled = true
        doubleCellBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doubleCellBtnClicked)))
        
        trippleCellBtn.isUserInteractionEnabled = true
        trippleCellBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(trippleCellBtnClicked)))
        
        

        allView.isUserInteractionEnabled = true
        allView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allClicked)))
        
        studentView.isUserInteractionEnabled = true
        studentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(studentsClicked)))
        
        alumniView.isUserInteractionEnabled = true
        alumniView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(alumniClicked)))
        
        inviteView.isUserInteractionEnabled = true
        inviteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inviteClicked)))
     
        
        directorySearchEditField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        //searchBtn
        searchBtn.isUserInteractionEnabled = true
        searchBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        //DROPDOWN
        
        menu.dataSource = ["Latest","Alphabet"]
        menu.textFont = UIFont(name: "RobotoCondensed-Regular", size: 13)!
        menu.direction = .bottom
        menu.setCornerBorder(color: .none, cornerRadius: 10, borderWidth: 0)
        
        sortView.isUserInteractionEnabled = true
        sortView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sortViewClicked)))
        
        
        //getAllUsers()
        getAllUsers()
     
    }
    
    
    
    public func sortByName(){
        
        
        allUserDataAfterFilter.sort { user1, user2 in
            if user1.name!.lowercased().compare(user2.name!.lowercased())  == .orderedAscending{
                return true
            }
            else {
                return false
            }
        }
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
    public func sortByDate(){
            
        allUserDataAfterFilter.sort { user1, user2 in
            if user1.registredAt! > user2.registredAt! {
                return true
            }
            else {
                return false
            }
        }
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
    @objc func sortViewClicked() {
        menu.anchorView = sortView
        menu.bottomOffset = CGPoint(x: -80, y:(menu.anchorView?.plainView.bounds.height)!)
       
         menu.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                sortText.text = "Sort: Latest"
                sortStatus = "latest"
                sortByDate()
            }
            else if index == 1 {
                sortText.text = "Sort: Alphabet"
                sortStatus = "alphabet"
                sortByName()
                
                
            }
        }
        DispatchQueue.main.async {
            self.menu.show()
        }
    }
    
    @objc func singleCellBtnClicked(){
         selectedType = "single"
         totalColumn = 1
        refreshCollectionViewHeight()
        if filterStatus == "all" {
            filter(value: "")
        }
        else {
            filterByClassification(value: filterStatus)
        }
        
    }
    
    @objc func doubleCellBtnClicked(){
       selectedType = "double"
       totalColumn = 2
        refreshCollectionViewHeight()
        if filterStatus == "all" {
            filter(value: "")
        }
        else {
            filterByClassification(value: filterStatus)
        }
    }
    
    
    @objc func trippleCellBtnClicked(){
        selectedType = "tripple"
        totalColumn = 3
       
        self.refreshCollectionViewHeight()
        
        if filterStatus == "all" {
            filter(value: "")
        }
        else {
            filterByClassification(value: filterStatus)
        }
       
        DispatchQueue.main.async {
            self.refreshCollectionViewHeight()
            
            if self.filterStatus == "all" {
                self.filter(value: "")
            }
            else {
                self.filterByClassification(value: self.filterStatus)
            }
           
        }
        
        
      
        
    }
    
    
    func refreshCollectionViewHeight(){
        let flowLayout = UICollectionViewFlowLayout()
        
        let mHeight = self.selectedType == "single" ? self.sigleCellHeight : (self.selectedType == "double" ? self.doubleCellHeight : self.trippleCellHeight )
        
        flowLayout.itemSize = CGSize(width: (self.collectionView.bounds.width / CGFloat(totalColumn)) , height: CGFloat(mHeight))
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0
        
        self.collectionView.collectionViewLayout = flowLayout
       
    }
   
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        filter(value: textField.text!)
    }
    
    public func filter(value : String){
        allUserDataAfterFilter.removeAll()
        allUserDataAfterFilter =  allUserData.filter { userdata in
            if value == "" || userdata.name!.lowercased().contains(value.lowercased())  {
                return true
            }
            else {
                return false
            }
        }
        
        if sortStatus == "latest" {
            sortByDate()
        }
        else {
            sortByName()
        }
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        let mHeight = self.selectedType == "single" ? self.sigleCellHeight : (self.selectedType == "double" ? self.doubleCellHeight : self.trippleCellHeight )
        var count = self.allUserDataAfterFilter.count / totalColumn
        if self.allUserDataAfterFilter.count % totalColumn > 0 {
            count = count + 1
        }
        self.collectionViewHeight.constant = CGFloat(mHeight * count)
        
    }
    
    public func filterByClassification(value : String){
        allUserDataAfterFilter.removeAll()
        allUserDataAfterFilter =  allUserData.filter { userdata in
            if userdata.classification?.lowercased() == value  {
                return true
            }
            else {
                return false
            }
        }
        
        if sortStatus == "latest" {
            sortByDate()
        }
        else {
            sortByName()
        }
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        let mHeight = self.selectedType == "single" ? self.sigleCellHeight : (self.selectedType == "double" ? self.doubleCellHeight : self.trippleCellHeight )
        var count = self.allUserDataAfterFilter.count / totalColumn
        if self.allUserDataAfterFilter.count % totalColumn > 0 {
            count = count + 1
        }
        self.collectionViewHeight.constant = CGFloat(mHeight * count)
        
        
    }
    
    public func getAllUsers(){
        Firestore.firestore().collection("Users").order(by: "registredAt", descending: false).addSnapshotListener { snapshot, error in
            if error == nil {
                
                self.allUserData.removeAll()
                if let snapshot = snapshot {
                    for qds in snapshot.documents {
                        if let network = try? qds.data(as: UserData.self){
                            if network.uid != Auth.auth().currentUser?.uid {
                                self.allUserData.append(network)
                              
                            }
                           
                        }
                        
                    }
                
                }
                
                self.filter(value: "")
            
              
                self.collectionView.reloadData()
                self.collectionView.layoutIfNeeded()
                let mHeight = self.selectedType == "single" ? self.sigleCellHeight : (self.selectedType == "double" ? self.doubleCellHeight : self.trippleCellHeight )
                var count = self.allUserData.count / self.totalColumn
                if self.allUserData.count % self.totalColumn > 0 {
                    count = count + 1
                }
                self.collectionViewHeight.constant = CGFloat(mHeight * count)
                
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
    }
    
    
    @objc func allClicked(){
        
        allText.textColor = UIColor.init(red: 189/255, green: 25/255, blue: 30/255, alpha: 1)
        
        studentText.textColor = .darkGray
        alumniText.textColor = .darkGray
        filterStatus = "all"
        self.filter(value: "")
        
    }
    
    @objc func studentsClicked(){
        studentText.textColor = UIColor.init(red: 189/255, green: 25/255, blue: 30/255, alpha: 1)
        
        allText.textColor = .darkGray
        alumniText.textColor = .darkGray
        filterStatus = "student"
        self.filterByClassification(value: "student")
    }
    
    @objc func alumniClicked(){
        alumniText.textColor = UIColor.init(red: 189/255, green: 25/255, blue: 30/255, alpha: 1)
        
        studentText.textColor = .darkGray
        allText.textColor = .darkGray
        filterStatus = "alumni"
        self.filterByClassification(value: "alumni")
        
    }
    
    @objc func inviteClicked(){
        

        let used  =  UserData.data!.referralUsed ?? 0
        let left = 5 - used;
        
        if left > 0 {
            let alert = UIAlertController(title: "Invite Friends", message: "You have total \(left) invite link left. Do you want to generate new invite link?", preferredStyle: .alert)
           
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                
                self.inviteFriend()
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
        else {
            showMessage(title: "Oops!", message: "You have used all your invite links.")
        }
        
    }
    
    func inviteFriend() {
        let inviteCode = self.generateRef()
        Firestore.firestore().collection("InviteCode").document(inviteCode).setData(["redeemed" : false])
        
        UserData.data!.referralUsed = (UserData.data!.referralUsed ?? 0) + 1
        
        Firestore.firestore().collection("Users").document(UserData.data?.uid ?? "Guest").setData(["referralUsed" : FieldValue.increment(Int64(1))],merge: true) { error in
            
        }
        
        
        
        let someText:String = "Check Out hbcumade App Now.\nInvite Code - \(inviteCode)\n\n"
        let objectsToShare:URL = URL(string: "https://apps.apple.com/us/app/hbcumade/id1551241222?ls=1&mt=8")!
       let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
       let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
       activityViewController.popoverPresentationController?.sourceView = self.view

       self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func viewProfileBtnTapped(myTappy : MyTapGesture) {
        performSegue(withIdentifier: "viewprofileseg", sender: myTappy.index)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "topbarseg" {
            if let topbar = segue.destination as? TopBarViewController {
            topbar.classificationDelegate = self
            
            }
            
        }
        else if segue.identifier == "viewprofileseg" {
            if let index = sender as? Int {
                if let destinationVC = segue.destination as? MainProfile {
                    destinationVC.userData = allUserDataAfterFilter[index]
                }
            }
        }
    }
 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.registeredUser.text = "\(allUserDataAfterFilter.count) Registered Users"
        return allUserDataAfterFilter.count
    }
    
  
    
    public func searchEditTextActivate() {
        
        DispatchQueue.main.async {
            self.directorySearchEditField.becomeFirstResponder()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        if selectedType == "single" {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "networksinglecell", for: indexPath) as? NetworkSingleViewCell {
           
            let userData = self.allUserDataAfterFilter[indexPath.row]
           
            cell.profilePic.makeRounded()
            cell.name.text = userData.name
            cell.status.text = userData.school
            
            if userData.profile != "" {
                
                cell.profilePic.sd_setImage(with: URL(string: userData.profile ?? ""), placeholderImage: UIImage(named: "profile-user"), options: .continueInBackground, completed: nil)
            
            }
            else {
                cell.profilePic.image = UIImage(named: "profile-user")!
            }
            
            if (userData.classification?.caseInsensitiveCompare("Alumni") == .orderedSame) {
                cell.classificationImage.image = UIImage(named: "icons8-graduation-cap-50")
            }
            else {
                cell.classificationImage.image = UIImage(named: "icons8-reading-50")
            }
            
            cell.view.isUserInteractionEnabled = true
            let myTappy = MyTapGesture(target: self, action: #selector(viewProfileBtnTapped(myTappy:)))
            myTappy.index = indexPath.row
            cell.view.addGestureRecognizer(myTappy)
            
            return cell
            
        }
       
        return NetworkSingleViewCell()
    }
    
        
        
        
    else if selectedType == "double" {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "networkdoublecell", for: indexPath) as? NetworkDoubleViewCell {
           
            let userData = self.allUserDataAfterFilter[indexPath.row]
           
            cell.profilePic.makeRounded()
            cell.name.text = userData.name
            cell.status.text = userData.school
            
            if userData.profile != "" {
                
                cell.profilePic.sd_setImage(with: URL(string: userData.profile ?? ""), placeholderImage: UIImage(named: "profile-user"), options: .continueInBackground, completed: nil)
            
            }
            else {
                cell.profilePic.image = UIImage(named: "profile-user")!
            }
            
            if (userData.classification?.caseInsensitiveCompare("Alumni") == .orderedSame) {
                cell.classificationImage.image = UIImage(named: "icons8-graduation-cap-50")
            }
            else {
                cell.classificationImage.image = UIImage(named: "icons8-reading-50")
            }
            
            cell.view.isUserInteractionEnabled = true
            let myTappy = MyTapGesture(target: self, action: #selector(viewProfileBtnTapped(myTappy:)))
            myTappy.index = indexPath.row
            cell.view.addGestureRecognizer(myTappy)
            
            return cell
            
        }
       
        return NetworkDoubleViewCell()
    }
    else {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "networktripplecell", for: indexPath) as? NetworkTrippleViewCell {
           
            let userData = self.allUserDataAfterFilter[indexPath.row]
           
            cell.profilePic.makeRounded()
            cell.name.text = userData.name
            cell.status.text = userData.school
            
            if userData.profile != "" {
                
                cell.profilePic.sd_setImage(with: URL(string: userData.profile ?? ""), placeholderImage: UIImage(named: "profile-user"), options: .continueInBackground, completed: nil)
            
            }
            else {
                cell.profilePic.image = UIImage(named: "profile-user")!
            }
            
            if (userData.classification?.caseInsensitiveCompare("Alumni") == .orderedSame) {
                cell.classificationImage.image = UIImage(named: "icons8-graduation-cap-50")
            }
            else {
                cell.classificationImage.image = UIImage(named: "icons8-reading-50")
            }
            
            cell.view.isUserInteractionEnabled = true
            let myTappy = MyTapGesture(target: self, action: #selector(viewProfileBtnTapped(myTappy:)))
            myTappy.index = indexPath.row
            cell.view.addGestureRecognizer(myTappy)
            
            return cell
            
        }
       
        return NetworkTrippleViewCell()
    }
  
    
    
    
}
}

