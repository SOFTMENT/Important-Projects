//
//  CurrencyConverterPresenter.swift
//  CurrencyConversion
//
//  Created by Nguyen Dinh Cong on 2019/12/14.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import UIKit

protocol CurrencyConverterPresentationLogic {
    func presentInitialize(response: CurrencyConverter.Initialize.Response)
    func presentPerformExchange(response: CurrencyConverter.PerformExchange.Response)
}

class CurrencyConverterPresenter: CurrencyConverterPresentationLogic {
    weak var viewController: CurrencyConverterDisplayLogic?

    func presentInitialize(response: CurrencyConverter.Initialize.Response) {
        switch response {
        case .failure(let error):
            viewController?.displayInitialize(viewModel: .failure(error: error))
        case .success(let currencies):
            let displayedCurrencies = currencies.map { CurrencyConverter.DisplayedCurrency(abbr: $0.abbr) }
            viewController?.displayInitialize(viewModel: .success(currencies: displayedCurrencies))
        }
    }
    
    func presentPerformExchange(response: CurrencyConverter.PerformExchange.Response) {
        switch response {
        case .failure:
            viewController?.displayPerformExchange(viewModel: .failure)
            
        case .startFetchQuotes:
            viewController?.displayPerformExchange(viewModel: .startFetchQuotes)
        
        case .successFetchQuotes(let updateDate):
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = "yyyy/MM/dd, HH:mm:ss"
            let updateDateString = dateFormatter.string(from: updateDate)
            let updateDateFullText = "Last updated: \(updateDateString)"
            
            viewController?.displayPerformExchange(viewModel: .successFetchQuotes(updateDate: updateDateFullText))
            
        case .success(let currencies, let amount, let quotes):
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 3
            
            let displayedCurrencyResult = quotes.map { quote -> CurrencyConverter.DisplayedCurrencyResult in
                let currencyFull = currencies.first { $0.abbr == quote.dest }?.full ?? ""
                
                let amount = formatter.string(from: NSNumber(value: amount * quote.rate)) ?? ""
                let rate = formatter.string(from: NSNumber(value: quote.rate)) ?? ""
                
                let rateExplain = "1 \(quote.source) = \(rate) \(quote.dest)"
                let abbr = "\(countryFlags[quote.dest] ?? "") \(quote.dest)"
                
                return .init(abbr: abbr, full: currencyFull, amount: amount, rate: rateExplain)
            }
            viewController?.displayPerformExchange(viewModel: .success(currencies: displayedCurrencyResult))
        }
    }
}
