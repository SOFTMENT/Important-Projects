//
//  RoundedUIView.swift
//  Mango Farm Bin Picking
//
//  Created by Vijay on 15/04/21.
//

import UIKit
@IBDesignable public class RoundedUIView: UIView {

    override public func layoutSubviews() {
        super.layoutSubviews()

        //hard-coded this since it's always round
        layer.cornerRadius = 0.5 * bounds.size.width
        dropShadow()
    }
}
