//
//  TabBarViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 14/03/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

//
//  TabBarController.swift
//  Ed Traut - PLM
//
//  Created by Vijay Rathore on 01/10/19.
//  Copyright © 2019 Original Development. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import Firebase


class TabBarViewController: UITabBarController, UITabBarControllerDelegate {


    @IBOutlet weak var tabbarView: UITabBar!
    
    var tabBarItems = UITabBarItem()

      let locationManager = CLLocationManager()
         var location : CLLocation?
         var isUpdatingLocation = false
         let geocoder = CLGeocoder()
         var placemark : CLPlacemark?
         var isPerformingReverseCoding = false
      
        var root = Database.database().reference().child("LocationHistory")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate  = self
      
        
      
        locationManager.delegate = self
        
        
        UITabBar.appearance().barTintColor = UIColor.init(red: 237/255, green: 27/255, blue: 37/255, alpha: 1)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        
        let selectedImage1 = UIImage(named: "icons8-home-100-12")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "icons8-home-100-12")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = deSelectedImage1
        tabBarItems.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "icons8-todo-list-100")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "icons8-todo-list-100")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![1]
        tabBarItems.image = deSelectedImage2
        tabBarItems.selectedImage = selectedImage2
        
        
        
        let selectedImage3 = UIImage(named: "icons8-chat-100-2")?.withRenderingMode(.alwaysOriginal)
             let deSelectedImage3 = UIImage(named: "icons8-chat-100-2")?.withRenderingMode(.alwaysOriginal)
             tabBarItems = self.tabBar.items![2]
             tabBarItems.image = deSelectedImage3
             tabBarItems.selectedImage = selectedImage3
        
        
        let selectedImage4 = UIImage(named: "icons8-news-100")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage4 = UIImage(named: "icons8-news-100")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![3]
        tabBarItems.image = deSelectedImage4
        tabBarItems.selectedImage = selectedImage4
        
        let selectedImage5 = UIImage(named: "icons8-settings-100-2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage5 = UIImage(named: "icons8-settings-100-2")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![4]
        tabBarItems.image = deSelectedImage5
        tabBarItems.selectedImage = selectedImage5
        
        
        
            
        }
        
        
      
  
   
            func getLocation() {
               
                if let placemark = placemark {
                    let address = getAddress(from : placemark)
                  
                    if let currentUser = Auth.auth().currentUser {
                        root = root.child(currentUser.uid).child(root.childByAutoId().key!)
                        let dateFormatter =  DateFormatter()
                        dateFormatter.dateFormat = "dd-MMMM-yyyy, hh:mm a"
                        let date = dateFormatter.string(from: Date())
                        let post: Dictionary<String, AnyObject> = [
                                          "message": address as AnyObject,
                                          "date": date as AnyObject
                        ]
                        
                        root.setValue(post)
                        
                    
                    }
                }
            }
            
            func getAddress(from placemark : CLPlacemark) -> String{
                var line1 = ""
             
                if let street1 = placemark.subThoroughfare {
                    line1 += street1 + ", "
                   
                   
                    
                }
                if let street2 = placemark.thoroughfare {
                    line1 += street2 
                }
                
            

                var line2 = ""
                if let city = placemark.subAdministrativeArea {
                    line2 += city + ", "
                }
                if let state  = placemark.administrativeArea {
                    line2 += state + ", "
                }
                if let postalCode = placemark.postalCode {
                    line2 += postalCode
                }
                
                var line3 = ""
                if let country = placemark.country {
                    line3 = country
                }
                if line1.isEmpty {
                    
                return line2 + "\n" + line3
                }
                
                return line1 + "\n" + line2 + "\n" + line3
            }
}


        
        extension TabBarViewController : CLLocationManagerDelegate {
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            location = locations.last!
            stopLocationManager()
            
            if location != nil {
                isPerformingReverseCoding = true
            
                geocoder.reverseGeocodeLocation(location!) { (placemark, error) in
                    if error == nil , let placemark = placemark, !placemark.isEmpty {
                        self.placemark = placemark.last!
                    }
                    else {
                        self.placemark = nil
                    }
                    self.isPerformingReverseCoding = false
                 
                    if Auth.auth().currentUser != nil {
                        self.getLocation()
                    }
                    
                }
            }
            
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error.localizedDescription)
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted, .denied :
                let alert = UIAlertController(title: "Oops! Location Services Disabled", message: "Please go to settings > Privacy to enable location services for this app", preferredStyle: .alert)
                  let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(okAction)
                present(alert,animated: true,completion: nil)
            break
              
            case .authorizedWhenInUse, .authorizedAlways :
                if !isUpdatingLocation {
                    location = nil
                    placemark = nil
                    print("START")
                    startLocationManager()
                    
                }
                else {
                    print("STOP")
                    stopLocationManager()
                }
            default:
                print("HAHAHA")
            }
            
        }
        
        
        
        func startLocationManager() {
            if CLLocationManager.locationServicesEnabled() {
                print("STARTUPDATING")
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                isUpdatingLocation = true
            }
        }
        
        func stopLocationManager() {
            
            if isUpdatingLocation {
                locationManager.stopUpdatingLocation()
                locationManager.delegate = nil
                isUpdatingLocation  = false
            }
            
            
        }
    }


