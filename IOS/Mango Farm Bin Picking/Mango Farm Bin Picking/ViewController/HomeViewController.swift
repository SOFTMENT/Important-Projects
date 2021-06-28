//
//  HomeViewController.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 14/04/21.
//

import UIKit
import Firebase
import CoreLocation
import MBProgressHUD
import MapKit


class HomeViewController: UIViewController {
   
    
    @IBOutlet weak var adminBtn: UIBarButtonItem!
    @IBOutlet weak var noRecordFound: UIView!
    @IBOutlet weak var scannerBtn: RoundedUIView!
    
    @IBOutlet weak var commentBtn: RoundedUIView!
    
    @IBOutlet weak var tableView: UITableView!
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        scannerBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scannerBtnClicked)))
    
        
        commentBtn.isUserInteractionEnabled = true
        commentBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(commentBtnClicked)))
        //getMangoBinModelsInfo
        getMangoBinModelData()
        
        if UserModel.userData.designation != "machine" {
            commentBtn.isHidden = true
        }
        
        //
//
//        addDataToFirebase(id: "9939", title: "Mango Bin Number 23", farmHouseNo: 2, pickedByName: "Vijay Rathore", scannedByName: "Manoj Verma", weight: 234, binNumber: 23)
        
        locationManager.requestWhenInUseAuthorization()
       
    }
    
    
    @objc func commentBtnClicked() {
        let alert = UIAlertController(title: "Choose Machine Status", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Machine Fixed", style: .default, handler: { action in
            
          
            self.updateMachineStatus(status: "Machine Fixed")
        
            self.showToast(message: "Machine Status Updated...")
            
        }))
        
        alert.addAction(UIAlertAction(title: "Machine Down", style: .default, handler: { action in
            self.updateMachineStatus(status: "Machine Down")
            self.showToast(message: "Machine Status Updated...")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        present(alert, animated: true, completion: nil)
    }
    
    func updateMachineStatus(status : String) {
        
        Constants.getFirestoreDB().collection("MachineStatus").document().setData(["status" : status,"time" : Date().timeIntervalSince1970, "machine" : UserModel.userData.machineNumber!]) { error in
            
        }
        
    }
    
  
    @IBAction func signOutBtnClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "LOG OUT", message: "Are you sure you want to Log Out?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            do {
                try Auth.auth().signOut()
                if UserModel.userData.email == "support@softment.in" {
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
    
    @objc func basketBtnClicked(myGest : MyGest){
        performSegue(withIdentifier: "scannerSeg", sender: myGest)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scannerSeg" {
            if let myGest = sender as? MyGest {
                if let destination = segue.destination as? QRScannerController {
                    destination.mBinNumber = myGest.binNumber
                    destination.mId = myGest.bId
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    
        if UserModel.userData.designation == "machine" {
            navigationItem.rightBarButtonItem = nil
          // scannerBtn.isHidden = false
        }
        else{
            navigationItem.rightBarButtonItem = adminBtn
            //scannerBtn.isHidden = true
        }
        
    }
 
    
    @objc func showMap(myGest : MyGestForMap){
        let latitude: CLLocationDegrees = myGest.lati
        let longitude: CLLocationDegrees = myGest.long
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Mango Bin"
        mapItem.openInMaps(launchOptions: options)
    }
    

    func getMangoBinModelData()  {
        
        ProgressHUDShow(text: "")
        
        Constants.getFirestoreDB().collection("BinInfo").order(by: "date",descending: true).addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, error in
        
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                MangoBinModel.mangoBinModels.removeAll()
                if let snap = snapshot {
                    for s in snap.documents {
                        if let data = try? s.data(as: MangoBinModel.self) {
                            MangoBinModel.mangoBinModels.append(data)
                        }
                    }
                }
             
                self.tableView.reloadData()
            }
            
        })
            
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
            
            if mbm.status?.lowercased() == "empty" {
                cell.basketImage.image = UIImage(named: "icons8-wicker_basket")
                cell.basketImage.isUserInteractionEnabled = false
                cell.status.text = "Empty"
                cell.emptyTime.text = convertTODateAndTime(dateValue: mbm.emptyDate!)
                cell.pickedBy.text = mbm.pickedByName
                cell.pickedByView.isHidden = false
                cell.emptyDateView.isHidden = false
            }
            else {
                cell.status.text = "Full"
                cell.basketImage.image = UIImage(named: "icons8-egg_basket")
                cell.pickedByView.isHidden = true
                cell.emptyDateView.isHidden = true
                cell.basketImage.isUserInteractionEnabled = true
                let myGest = MyGest(target: self, action: #selector(basketBtnClicked(myGest:)))
                myGest.bId = mbm.id!
                myGest.binNumber = String(mbm.binNumber!)
                cell.basketImage.addGestureRecognizer(myGest)
                
            }
            
            cell.mangoBinImgView.layer.cornerRadius = 4
            cell.dropShadow()
            cell.machineNo.text = mbm.machineNumber
            cell.imgNumber.text = String(mbm.binNumber ?? 1)
            cell.title.text = mbm.title
            cell.scannedBy.text = mbm.scannedByName
            cell.time.text = convertTODateAndTime(dateValue: mbm.date!)
            
            cell.seeOnMap.isUserInteractionEnabled = true
            let myGestForMap  =  MyGestForMap(target: self, action: #selector(showMap))
            if let lati = mbm.lati {
                myGestForMap.lati = lati
                myGestForMap.long = mbm.long!
                cell.seeOnMap.addGestureRecognizer(myGestForMap)
            }
            else {
                self.showError("Location for this bin is not available.")
            }
          
            
            return cell
            }
          
          
        return MangoBinDetailsTableViewCell()
            
        }
}
    
       

class MyGest: UITapGestureRecognizer {
    
    var binNumber = "-1"
    var bId = "-1"
}

class MyGestForMap : UITapGestureRecognizer {
    var lati : Double = 0.0
    var long : Double = 0.0
}
