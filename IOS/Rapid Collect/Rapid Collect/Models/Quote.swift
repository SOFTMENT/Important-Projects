//
//  Quote.swift
//  CurrencyConversion
//
//  Created by Nguyen Dinh Cong on 2019/12/15.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import Foundation

struct Quote: Codable {
    let source: String
    let dest: String
    let rate: Double
}

struct QuoteData: Codable {
    let quotes: [Quote]
    let updateDate: Date
}
