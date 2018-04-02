//
//  CryptoCompareAPI.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 01.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation

enum CryptoCompareError: Error {
    case invalidJSONData
}

@available(OSX 10.12, *)
struct CryptoCompareAPI: Exchange {
    
    // MARK: - Private Properties
    private static let baseURL = "https://min-api.cryptocompare.com/data"
    
    private enum Method: String {
        case ExchangeRateHistory = "histoday"
        case CurrentExchangeRate = "price"
    }
    
    // MARK: - Private Methods
    private static func cryptoCompareURL(method: Method, parameters: [String: String]) -> URL {
        var components = URLComponents(string: baseURL.appending("/\(method.rawValue)"))!
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        return components.url!
    }
    
    // MARK: - Public Methods
    // MARK: Data Aggregation
    static func currentExchangeRate(for currencyPair: CurrencyPair, fromJSON data: Data) -> CurrentExchangeRateResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let jsonDictionary = jsonObject as? [AnyHashable: Any], let value = jsonDictionary[currencyPair.quote.code] as? Double else {
                return .failure(CryptoCompareError.invalidJSONData)
            }
            
            let currentExchangeRate = TickerConnector.ExchangeRate(date: Date(), currencyPair: currencyPair, value: value)
            
            return .success(currentExchangeRate)
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: URL Creation
    static func currentExchangeRateURL(for currencyPair: CurrencyPair) -> URL {
        return cryptoCompareURL(method: .CurrentExchangeRate, parameters: [
            "fsym": currencyPair.base.code,
            "tsyms": currencyPair.quote.code,
        ])
    }
    
}
