//
//  RateViewController.swift
//  Sweet Tooth
//
//  Created by Vijay Rathore on 20/03/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import StoreKit

class RateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
            SKStoreReviewController.requestReview()
    
        
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

