//
//  ShareViewController.swift
//  Sweet Tooth
//
//  Created by Vijay Rathore on 20/03/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
             if let urlStr = NSURL(string: "https://itunes.apple.com/us/app/digginz/id1546720080?ls=1") {
               let objectsToShare = [urlStr]
               let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

               if UIDevice.current.userInterfaceIdiom == .pad {
                   if let popup = activityVC.popoverPresentationController {
                       popup.sourceView = self.view
                       popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                   }
               }
               

               self.present(activityVC, animated: true, completion: nil)
           }
        
        if let navController = self.navigationController {
                  navController.popViewController(animated: true)
              }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
