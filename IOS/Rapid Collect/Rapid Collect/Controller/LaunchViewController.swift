//
//  LaunchViewController.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 29/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit
import SwiftyGif

class LaunchViewController: UIViewController {
 let logoAnimationView = LogoAnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
       view.addSubview(logoAnimationView)
              logoAnimationView.pinEdgesToSuperView()
              logoAnimationView.logoGifImageView.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
        
           logoAnimationView.logoGifImageView.startAnimatingGif()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: {
                self.performSegue(withIdentifier: "signinseg", sender: nil)
            })
        
           
        
        
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
extension LaunchViewController : SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
    }
}
