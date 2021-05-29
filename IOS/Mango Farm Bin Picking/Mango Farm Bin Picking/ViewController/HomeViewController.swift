//
//  HomeViewController.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 14/04/21.
//

import UIKit
import Firebase
import MBProgressHUD

class HomeViewController: UIViewController {
   
    @IBOutlet weak var adminBtn: UIBarButtonItem!
    @IBOutlet weak var noRecordFound: UIView!
    @IBOutlet weak var scannerBtn: RoundedUIView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        scannerBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scannerBtnClicked)))
    
        
        
        //getMangoBinModelsInfo
        getMangoBinModelData()
        
        //
//
//        addDataToFirebase(id: "9939", title: "Mango Bin Number 23", farmHouseNo: 2, pickedByName: "Vijay Rathore", scannedByName: "Manoj Verma", weight: 234, binNumber: 23)
    
    }
    
    
  
    @IBAction func signOutBtnClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "LOG OUT", message: "Are you sure you want to Log Out?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            do {
                try Auth.auth().signOut()
                if UserModel.data?.email == "support@softment.in" {
                    self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController2)
                }
                else {
                    self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
                }
                
               
            }catch {

            }
            
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func adminBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "reportSeg", sender: nil)
        
    }
    
    
   @objc func scannerBtnClicked() {

        performSegue(withIdentifier: "scannerSeg", sender: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
       
        if UserModel.data?.designation == "machine" {
            navigationItem.rightBarButtonItem = nil
            //scannerBtn.isHidden = false
        }
        else{
            navigationItem.rightBarButtonItem = adminBtn
            //scannerBtn.isHidden = true
        }
        
    }
    
    func addDataToFirebase(id : String, title : String, farmHouseName : String, pickedByName :String,scannedByName : String, weight :Double, binNumber : Int, machineNumber : String) {
        
        let mangoBinModel = MangoBinModel(id: id, title: title, pickedByName: pickedByName, scannedByName: scannedByName, binNumber: binNumber,date: Date().timeIntervalSince1970, machineNumber: machineNumber)
        
       
      
        
       let mangoBinData =   ["id": mangoBinModel.id,
                             "title" : title,
                            "pickedByName": mangoBinModel.pickedByName,
                            "scannedByName" : mangoBinModel.scannedByName,
                            "date" : mangoBinModel.date,
                            "machineNumber" : mangoBinModel.machineNumber,
                            "binNumber" : mangoBinModel.binNumber
                            ] as [String : Any]
        
        Database.database().reference().child("MangoFarm").child("BinInfo").child(mangoBinModel.id).setValue(mangoBinData) { (error, databaseRef) in
            if error != nil {
                self.showError(error.debugDescription)
            }
            else {
               
            }
        }
        
    
    }
    

    func getMangoBinModelData()  {
        
        ProgressHUDShow(text: "Loading...")
        
        let databaseRef = Database.database().reference().child("MangoFarm").child("BinInfo")
        databaseRef.keepSynced(true)
        databaseRef.queryOrdered(byChild: "date").observe(.value) { (snapshot) in
        
            MBProgressHUD.hide(for: self.view, animated: true)
        MangoBinModel.mangoBinModels.removeAll()
        if snapshot.exists() {
            for snap in snapshot.children {
                if let s = snap as? DataSnapshot {
                    if  let data = s.value as? [String : Any] {
                        
             
                        let id = data["id"] as? String
                        let title = data["title"] as? String
                        let pickedByName = data["pickedByName"] as? String
                        let scannedByName = data["scannedByName"] as? String
                        let machineNumber = data["machineNumber"] as? String
                        let date = data["date"] as? Double
                        let binNumber = data["binNumber"] as? Int
                        
                        let mangoBinModel = MangoBinModel(id: id!, title: title!, pickedByName: pickedByName!, scannedByName: scannedByName!, binNumber: binNumber!, date: date!, machineNumber: machineNumber!)
                        MangoBinModel.mangoBinModels.append(mangoBinModel)
                        
                        
                    }
                }
            }
            MangoBinModel.mangoBinModels.reverse()
            self.tableView.reloadData()
            
        }
        
        
    }
    

}
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if MangoBinModel.mangoBinModels.count > 0 {
            noRecordFound.isHidden = true
        }
        else {
            noRecordFound.isHidden = false
        }
        return MangoBinModel.mangoBinModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mangobindetails", for: indexPath) as? MangoBinDetailsTableViewCell {
           
            let mbm = MangoBinModel.mangoBinModels[indexPath.row]
            
            cell.mangoBinImgView.layer.cornerRadius = 4
            cell.dropShadow()
            cell.machineNo.text = mbm.machineNumber
            cell.imgNumber.text = String(mbm.binNumber)
            cell.title.text = mbm.title
            cell.pickedBy.text = mbm.pickedByName
            cell.scannedBy.text = mbm.scannedByName
        
            cell.time.text = convertTODateAndTime(dateValue: mbm.date)
            
            return cell
            }
          
          
        return MangoBinDetailsTableViewCell()
            
        }
}
    
       

