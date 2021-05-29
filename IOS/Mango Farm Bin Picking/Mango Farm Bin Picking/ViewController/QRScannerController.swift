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


class QRScannerController: UIViewController {
   

   
    @IBOutlet weak var scan: AnimationView!
    
    @IBOutlet weak var scannerView: UIView!
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    
  
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
            if UserModel.data?.designation != "admin" {
             
            
            if metadataObj.stringValue != nil {
    
                captureSession.stopRunning()
             
                let number = Int(metadataObj.stringValue!) ?? 0
                if number > 0 {
                    showAlertForInput(number: number)
                    
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
    
    
 

    func showAlertForInput(number : Int) {
    
    //1. Create the alert controller.
    let alert = UIAlertController(title: "Mango Bin \(number)", message: "", preferredStyle: .alert)

    //2. Add the text field. You can configure it however you need.
    alert.addTextField { (textField) in
        textField.placeholder = "Picker Name"
    }
        
        //2. Add the text field. You can configure it however you need.
    alert.addTextField { (textField) in
        textField.placeholder = "Scanner Name"
    }
        
    

        
        
    // 3. Grab the value from the text field, and print it when the user clicks OK.
    alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
        let pickername = alert?.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines) // Force unwrapping because we know it exists.
        let scannerName = alert?.textFields![1].text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (!pickername!.isEmpty && !scannerName!.isEmpty) {
            let id = String(self.getCurrentMillis())
            let title = "Mango Bin Number \(number)"
    
            self.addDataToFirebase(id: id, machineNumber: UserModel.data!.machineNumber, title: title, pickedByName: pickername!, scannedByName: scannerName!, binNumber: number)
            
        }
        else {
            self.showToast(message: "Please Fill All Fields")
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
    
   
    
    func addDataToFirebase(id : String,machineNumber : String,title : String, pickedByName :String,scannedByName : String, binNumber : Int ) {
        
        
       
      
        
       let mangoBinData =   ["id": id,
                             "title" : title,
                            "pickedByName": pickedByName,
                            "scannedByName" : scannedByName,
                            "date" : Date().timeIntervalSince1970,
                            "binNumber" : binNumber,
                            "machineNumber" : machineNumber
                            ] as [String : Any]
        
        Database.database().reference().child("MangoFarm").child("BinInfo").child(id).setValue(mangoBinData) { (error, databaseRef) in
            if error != nil {
                self.showError(error.debugDescription)
            }
            else {
               
            }
        }
        
    
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }

    
    
    

    
  
}


