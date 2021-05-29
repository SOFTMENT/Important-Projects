//
//  LogoAnimationView.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 29/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//


import UIKit
import SwiftyGif

class LogoAnimationView: UIView {
    
    let logoGifImageView: UIImageView = {
        guard let gifImage = try? UIImage(gifName: "optimized.gif") else {
            return UIImageView()
        }
        return UIImageView(gifImage: gifImage, loopCount : 10)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor(white: 255.0 / 255.0, alpha: 1)
        addSubview(logoGifImageView)
        logoGifImageView.pinEdgesToSuperView()
      
       
    }
}
