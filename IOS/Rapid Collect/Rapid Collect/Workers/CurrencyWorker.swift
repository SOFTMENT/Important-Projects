//
//  CurrencyWorker.swift
//  CurrencyConversion
//
//  Created by Nguyen Dinh Cong on 2019/12/15.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import Foundation

protocol CurrencyApi: ApiTarget {}

extension CurrencyApi {
    var scheme: String { "http" }
    var host: String { "data.fixer.io" }
    var params: [String : String] { ["access_key": AppConfig.apiKey] }
}

struct CurrenciesList: CurrencyApi {
    struct Response: Decodable {
        let currencies: [Currency]
        
        init(currencies: [Currency]) {
            self.currencies = currencies
        }
        
        enum Keys: String, CodingKey {
            case symbols
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            let currenciesDic = try container.decode([String: String].self, forKey: .symbols)
            
            let currencies = currenciesDic
                .sorted { $0.key < $1.key }
                .map { Currency(abbr: $0.key, full: $0.value) }
            
            self.init(currencies: currencies)
        }
    }
    
    typealias ResponseType = Response
    
    var path: String { "/api/symbols" }
}

struct CurrencyExchange: CurrencyApi {
    struct Response: Decodable {
        let source: String
        let quotes: [Quote]
        
        init(source: String, quotes: [Quote]) {
            self.source = source
            self.quotes = quotes
        }
        
        enum Keys: String, CodingKey {
            case base
            case rates
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            let source: String = try container.decode(String.self, forKey: .base)
            let quotesDic: [String: Double] = try container.decode([String: Double].self, forKey: .rates)
            
            let quotes = quotesDic
                .sorted { $0.key < $1.key }
                .compactMap { item -> Quote? in
                    return Quote(source: source, dest: item.key, rate: item.value)
            }
            
            self.init(source: source, quotes: quotes)
        }
    }
    
    typealias ResponseType = Response
    
    var path: String { "/api/latest" }
}

protocol CurrencyWorkerProtocol {
    func fetchExchangeRate(
        for sourceCurrency: String,
        completion: @escaping (Result<CurrencyExchange.Response, ApiError>) -> Void)
    
    func fetchCurrenciesList(completion: @escaping (Result<CurrenciesList.Response, ApiError>) -> Void)
}

class CurrencyWorker: CurrencyWorkerProtocol {
    func fetchExchangeRate(
        for sourceCurrency: String,
        completion: @escaping (Result<CurrencyExchange.Response, ApiError>) -> Void) {
        ApiWorker().request(target: CurrencyExchange(), completion: completion)
    }
    
    func fetchCurrenciesList(completion: @escaping (Result<CurrenciesList.Response, ApiError>) -> Void) {
        ApiWorker().request(target: CurrenciesList(), completion: completion)
    }
    
}
