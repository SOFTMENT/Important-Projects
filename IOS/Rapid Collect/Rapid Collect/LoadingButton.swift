//
//  LoadingButton.swift
//  Rapid Collect
//
//  Created by Vijay Rathore on 01/04/20.
//  Copyright © 2020 OriginalDevelopment. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
var originalButtonText: String?
var activityIndicator: UIActivityIndicatorView!

func showLoading() {
    originalButtonText = self.titleLabel?.text
    self.setTitle("Processing", for: .normal)

    if (activityIndicator == nil) {
        activityIndicator = createActivityIndicator()
    }

    showSpinning()
}

func hideLoading() {
    self.setTitle(originalButtonText, for: .normal)
    activityIndicator.stopAnimating()
}

private func createActivityIndicator() -> UIActivityIndicatorView {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    activityIndicator.color = .lightGray
    return activityIndicator
}

private func showSpinning() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(activityIndicator)
    centerActivityIndicatorInButton()
    activityIndicator.startAnimating()
}

private func centerActivityIndicatorInButton() {
    let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: activityIndicator, attribute: .right, multiplier: 1, constant: 0)
    self.addConstraint(xCenterConstraint)

    let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
    self.addConstraint(yCenterConstraint)
}
}
