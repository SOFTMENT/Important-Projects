//
//  CurrencyResultCell.swift
//  CurrencyConversion
//
//  Created by Nguyen Dinh Cong on 2019/12/14.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import UIKit

class CurrencyResultCell: UICollectionViewCell {
    static let identifier = String(describing: CurrencyResultCell.self)

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var convertedLabel: UILabel!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
