//
//  DynamicH.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 05/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit

class DynamicH: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
