//
//  CurrencyConverterModels.swift
//  CurrencyConversion
//
//  Created by Nguyen Dinh Cong on 2019/12/14.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import UIKit

enum CurrencyConverter {
    struct DisplayedCurrency {
        let abbr: String
    }
    
    enum Initialize {
        struct Request {}
        enum Response {
            case failure(error: ApiError)
            case success(currencies: [Currency])
        }
        enum ViewModel {
            case failure(error: ApiError)
            case success(currencies: [DisplayedCurrency])
        }
    }
    
    struct DisplayedCurrencyResult: Hashable {
        let abbr: String
        let full: String
        let amount: String
        let rate: String
    }
    
    enum PerformExchange {
        struct Request {
            let sourceCurrency: String
            let amount: Double
        }
        
        enum Response {
            case failure
            case startFetchQuotes
            case successFetchQuotes(updateDate: Date)
            case success(currencies: [Currency], amount: Double, quotes: [Quote])
        }
        
        enum ViewModel {
            case failure
            case startFetchQuotes
            case successFetchQuotes(updateDate: String)
            case success(currencies: [DisplayedCurrencyResult])
        }
    }
}
