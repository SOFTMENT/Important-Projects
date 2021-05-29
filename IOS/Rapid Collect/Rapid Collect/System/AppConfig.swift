//
//  AppConfig.swift
//  CurrencyConversion
//
//  Created by Nguyen Dinh Cong on 2019/12/16.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import Foundation

enum AppConfig {
    static var apiKey: String {
        return "4e6462cdb867af867ab90949986f6422"
    }
    static let cacheDuration: TimeInterval = 30 * 60
    static let apiTimeout: TimeInterval = 5
}
