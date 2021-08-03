//
//  QRScannerController.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 15/04/21.
//

import UIKit
import AVFoundation
import Lottie
import Firebase
import CoreLocation


class QRScannerController: UIViewController, CLLocationManagerDelegate {
   

   
    @IBOutlet weak var scan: AnimationView!
    
    @IBOutlet weak var scannerView: UIView!
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var mBinNumber = "-1"
    var mId = "-1"
    var locationManager = CLLocationManager()
    var lati : Double = 0.0
    var long : Double = 0.0
  
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
 
    
   
    
    @objc func update() {
        captureSession.startRunning()
        scan.contentMode = .scaleAspectFit
         
         // 2. Set animation loop mode
         
         scan.loopMode = .loop
         
         // 3. Adjust animation speed
         
         scan.animationSpeed = 0.5
         
         // 4. Play animation
         scan.play()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       requestUserLocation()
    
         
        NotificationCenter.default.addObserver(self, selector: #selector(self.update), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.update), name: UIApplication.didBecomeActiveNotification, object: nil)
    
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
//            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = scannerView.layer.bounds
        videoPreviewLayer?.cornerRadius = 16
        scannerView.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        update()
       
        // Initialize QR Code Frame to highlight the QR code
      
        
      
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    manager.desiredAccuracy = 1000 // 1km accuracy

    if locations.last!.horizontalAccuracy > manager.desiredAccuracy {
        // This location is inaccurate. Throw it away and wait for the next call to the delegate.
        print("i don't want this location")
        return;
    }

        if let location = manager.location {
            self.lati = location.coordinate.latitude
            self.long = location.coordinate.longitude
            print(lati)
            print(long)
            print("OK")
        }
       
        guard locations.last != nil else {
        print("error getting user location")
        return
    }
    }
    
    func requestUserLocation(){
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
    layer.videoOrientation = orientation
    videoPreviewLayer?.frame = self.scannerView.bounds
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if let connection =  self.videoPreviewLayer?.connection  {
      let currentDevice: UIDevice = UIDevice.current
      let orientation: UIDeviceOrientation = currentDevice.orientation
      let previewLayerConnection : AVCaptureConnection = connection
      
      if previewLayerConnection.isVideoOrientationSupported {
        switch (orientation) {
        case .portrait:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
          break
        case .landscapeRight:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
          break
        case .landscapeLeft:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
          break
        case .portraitUpsideDown:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
          break
        default:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
          break
        }
      }
    }
  }

}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            scannerView.frame = CGRect.zero
            
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            scannerView.frame = barCodeObject!.bounds
            if UserModel.userData.designation != "admin" {
             
            
            if metadataObj.stringValue != nil {
    
                captureSession.stopRunning()
             
                let number = Int(metadataObj.stringValue!) ?? 0
                if number > 0 {
                    showAlertForFillInput(number: number)
                    
                }
                else {
                    let alert = UIAlertController(title: "", message: "Invalid QR CODE", preferredStyle: UIAlertController.Style.alert)
                        // add an action (button)
        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alertA) in
                         self.captureSession.startRunning()
                        }))
                        self.present(alert, animated: true, completion: nil)
                }
            
        }
                
            }
            else {
                self.showError("You can not scan code because you're an admin")
            }
    }

}
    
    
 

    func showAlertForFillInput(number : Int) {
        
        if mBinNumber != "-1" {
            if String(number) != mBinNumber {
                showError("Wrong QR Code.")
            }
            else {
                //1. Create the alert controller.
                let alert = UIAlertController(title: "Empty Mango Bin \(number)", message: "", preferredStyle: .alert)

            //    //2. Add the text field. You can configure it however you need.
            //    alert.addTextField { (textField) in
            //        textField.placeholder = "Picker Name"
            //    }
                    
                    //2. Add the text field. You can configure it however you need.
                alert.addTextField { (textField) in
                    textField.placeholder = "Picker Name"
                }
                    
                
                    
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
                 //   let pickername = alert?.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines) // Force unwrapping because we know it exists.
                    let pickerName = alert?.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if (!pickerName!.isEmpty) {
                       
                        
                        self.updateBin(id: self.mId, pickerName: pickerName!)
                        
                    }
                    else {
                        self.showToast(message: "Please Enter Picker Name")
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    self.captureSession.startRunning()
                    alert.dismiss(animated: true, completion: nil)
                }))

                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        else {
            
            let id = String(self.getCurrentMillis())
            let title = "Mango Bin Number \(number)"
 
            let alert = UIAlertController(title: "Fill Mango Bin \(number)", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
                self.addDataToFirebase(id: id, machineNumber: UserModel.userData.machineNumber ?? "-1", title: title, binNumber: number)
                self.captureSession.startRunning()
                self.showToast(message: "Bin Added")
                self.dismiss(animated: true, completion: nil)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel   ", style: .default, handler: nil))
            
            
            self.present(alert, animated: true, completion: nil)
//            //1. Create the alert controller.
//            let alert = UIAlertController(title: "Fill Mango Bin \(number)", message: "", preferredStyle: .alert)
//
//        //    //2. Add the text field. You can configure it however you need.
//        //    alert.addTextField { (textField) in
//        //        textField.placeholder = "Picker Name"
//        //    }
//
//                //2. Add the text field. You can configure it however you need.
////            alert.addTextField { (textField) in
////                textField.placeholder = "Scanner Name"
////            }
////
////

                
          
//
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//                self.captureSession.startRunning()
//                alert.dismiss(animated: true, completion: nil)
//            }))
//
//            // 4. Present the alert.
//
            
        }
    
   
    }
    
    func updateBin(id : String, pickerName : String) {
        
        let mangoBinUpdateData = ["status" : "empty", "emptyDate" : Date().timeIntervalSince1970,
                                  "pickedByName" :pickerName
        ] as [String : Any]
        
        Constants.getFirestoreDB().collection("BinInfo").document(id).setData(mangoBinUpdateData,merge: true, completion: { err in
            if err != nil {
                self.showError(err!.localizedDescription)
            }
        })
    }
   
    
    func addDataToFirebase(id : String,machineNumber : String,title : String, binNumber : Int ) {
        
        
       
       
        
       let mangoBinData =   ["id": id,
                             "title" : title,
                            "date" : Date().timeIntervalSince1970,
                            "binNumber" : binNumber,
                            "lati" : self.lati,
                            "long" : self.long,
                            "machineNumber" : machineNumber,
                            "status" : "full"
                            ] as [String : Any]
        
      
        Constants.getFirestoreDB().collection("BinInfo").document(id).setData(mangoBinData, completion: { err in
            
            if err != nil {
                self.showError(err!.localizedDescription)
            }
        })
            
            
        
    
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }

    
    
    

    
  
}


