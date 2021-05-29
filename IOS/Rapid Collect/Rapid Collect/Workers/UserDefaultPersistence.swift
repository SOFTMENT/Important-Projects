//
//  UserDefaultPersistence.swift
//  CurrencyConversion
//
//  Created by Nguyen, Cong on 2019/12/16.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultPersistence<T: Codable> {
    enum Key: String {
        case quoteData
    }
    
    struct ExpirableData: Codable {
        let date: Date
        let data: T
    }
    
    let duration: TimeInterval = AppConfig.cacheDuration
    
    let key: Key
    
    var wrappedValue: T? {
        get {
            guard let jsonData = UserDefaults.standard.data(forKey: key.rawValue),
                let expirableData = try? JSONDecoder().decode(ExpirableData.self, from: jsonData)
                else { return nil }
            
            if Date().timeIntervalSince(expirableData.date) > duration { return nil }
                
            return expirableData.data
        }
        
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: key.rawValue)
                return
            }
            
            let expirableData = ExpirableData(date: Date(), data: newValue)
            guard let jsonData = try? JSONEncoder().encode(expirableData) else { return }
            UserDefaults.standard.set(jsonData, forKey: key.rawValue)
        }
    }
}
