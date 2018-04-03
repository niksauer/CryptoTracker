//
//  TickerConnector.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 01.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation

enum CurrentExchangeRateResult {
    case success(TickerConnector.ExchangeRate)
    case failure(Error)
}

struct TickerConnector {
    
    // MARK: - Private Properties
    private static let session = URLSession(configuration: .default)
    
    // MARK: - Public Properties
    struct ExchangeRate {
        let date: Date
        let currencyPair: CurrencyPair
        let value: Double
    }
    
    // MARK: - Private Methods
    private static func processCurrentExchangeRateRequest(for currencyPair: CurrencyPair, data: Data?, error: Error?) -> CurrentExchangeRateResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return CryptoCompareAPI.currentExchangeRate(for: currencyPair, fromJSON: jsonData)
    }
    
    // MARK: - Public Methods
    static func fetchCurrentExchangeRate(for currencyPair: CurrencyPair, completion: @escaping (CurrentExchangeRateResult) -> Void) {
        let url = CryptoCompareAPI.currentExchangeRateURL(for: currencyPair)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            let result = self.processCurrentExchangeRateRequest(for: currencyPair, data: data, error: error)
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }
    
}
