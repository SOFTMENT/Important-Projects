//
//  CurrencyConverterRouter.swift
//  CurrencyConversion
//
//  Created by Nguyen Dinh Cong on 2019/12/14.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import UIKit

@objc protocol CurrencyConverterRoutingLogic {
    
}

protocol CurrencyConverterDataPassing {
    var dataStore: CurrencyConverterDataStore { get }
}

class CurrencyConverterRouter: NSObject, CurrencyConverterRoutingLogic, CurrencyConverterDataPassing {
    weak var viewController: CurrencyConverterViewController?
    var dataStore: CurrencyConverterDataStore

    init(dataStore: CurrencyConverterDataStore) {
        self.dataStore = dataStore
    }
}
