//
//  CurrencyConverterInteractor.swift
//  CurrencyConversion
//
//  Created by Nguyen Dinh Cong on 2019/12/14.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import UIKit

protocol CurrencyConverterBusinessLogic {
    func initilize(request: CurrencyConverter.Initialize.Request)
    func performExchange(request: CurrencyConverter.PerformExchange.Request)
}

protocol CurrencyConverterDataStore {
    
}

class CurrencyConverterInteractor: CurrencyConverterBusinessLogic, CurrencyConverterDataStore {
    var presenter: CurrencyConverterPresentationLogic
    
    let currencyWorker: CurrencyWorkerProtocol
    
    var currencies: [Currency]?
    
    @UserDefaultPersistence(key: .quoteData)
    var quoteData: QuoteData?

    init(presenter: CurrencyConverterPresentationLogic, currencyWorker: CurrencyWorkerProtocol = CurrencyWorker()) {
        self.presenter = presenter
        
        self.currencyWorker = currencyWorker
    }
    
    func initilize(request: CurrencyConverter.Initialize.Request) {
        currencyWorker.fetchCurrenciesList { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter.presentInitialize(response: .failure(error: error))
            case .success(let response):
                self?.currencies = response.currencies
                self?.presenter.presentInitialize(response: .success(currencies: response.currencies))
            }
        }
        
    }

    func performExchange(request: CurrencyConverter.PerformExchange.Request) {
        guard let currencies = currencies else { return }

        if let quoteData = quoteData {
            let targetQuotes = generateTargetQuotes(
                sourceCurrency: request.sourceCurrency,
                currencies: currencies,
                bridgeQuotes: quoteData.quotes)
            
            self.presenter.presentPerformExchange(response: .successFetchQuotes(updateDate: quoteData.updateDate))
            self.presenter.presentPerformExchange(response: .success(
                currencies: currencies,
                amount: request.amount,
                quotes: targetQuotes))
            
            return
        }
        
        presenter.presentPerformExchange(response: .startFetchQuotes)
        
        currencyWorker.fetchExchangeRate(for: request.sourceCurrency) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                self.presenter.presentPerformExchange(response: .failure)
                
            case .success(let response):
                let quoteData = QuoteData(quotes: response.quotes, updateDate: Date())
                self.quoteData = quoteData
                
                self.presenter.presentPerformExchange(response: .successFetchQuotes(updateDate: quoteData.updateDate))
                
                let targetQuotes = self.generateTargetQuotes(
                    sourceCurrency: request.sourceCurrency,
                    currencies: currencies,
                    bridgeQuotes: response.quotes)
                
                self.presenter.presentPerformExchange(response: .success(
                    currencies: currencies,
                    amount: request.amount,
                    quotes: targetQuotes))
            }
        }
    }
}

private extension CurrencyConverterInteractor {
    func generateTargetQuotes(sourceCurrency: String, currencies: [Currency], bridgeQuotes: [Quote]) -> [Quote] {
         return currencies.compactMap { currency -> Quote? in
            guard currency.abbr != sourceCurrency else { return nil }
            
            guard let sourceBridgeRate = bridgeQuotes.first(where: { $0.dest == sourceCurrency }),
                let destBridgeRate = bridgeQuotes.first(where: { $0.dest == currency.abbr })
                else { return nil }
            
            let rate = destBridgeRate.rate / sourceBridgeRate.rate
            
            return Quote(source: sourceCurrency, dest: currency.abbr, rate: rate)
        }
    }
}
