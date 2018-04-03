//
//  TickerDaemon.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 01.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation

protocol TickerDaemonDelegate {
    func didUpdateCurrentExchangeRate(for currencyPair: CurrencyPair)
}

final class TickerDaemon {
    
    // MARK: - Singleton
    static var shared = TickerDaemon()
    
    // MARK: - Initilization
    private init() {}
    
    // MARK: - Public Properties
    var delegate: TickerDaemonDelegate?
    
    // MARK: - Private Properties
    private var updateTimer: Timer?
    private var updateInterval: TimeInterval = 15
    
    private var currencyPairs = Set<CurrencyPair>()
    private var currentExchangeRateForCurrencyPair = [CurrencyPair: Double]()
    private var requestsForCurrencyPair = [CurrencyPair: Int]()
    
    // MARK: - Public Methods
    func addCurrencyPair(_ currencyPair: CurrencyPair) {
        if !currencyPairs.contains(currencyPair) {
            currencyPairs.insert(currencyPair)
            updateExchangeRate(for: currencyPair, completion: nil)
            print("Added currency pair '\(currencyPair.name)' to TickerDaemon.")
        }
        
        if let requestCount = requestsForCurrencyPair[currencyPair] {
            requestsForCurrencyPair[currencyPair] = requestCount + 1
            print("Updated requests (\(requestCount + 1)) for currency pair '\(currencyPair.name)'.")
        } else {
            requestsForCurrencyPair[currencyPair] = 1
        }
        
        if currencyPairs.count == 1 {
            startUpdateTimer()
        }
    }
    
    func removeCurrencyPair(_ currencyPair: CurrencyPair) {
        guard let requestCount = requestsForCurrencyPair[currencyPair] else {
            return
        }
        
        if requestCount == 1 {
            currencyPairs.remove(currencyPair)
            requestsForCurrencyPair.removeValue(forKey: currencyPair)
            print("Removed currency pair '\(currencyPair.name)' from TickerDaemon.")
        } else {
            requestsForCurrencyPair[currencyPair] = requestCount - 1
            print("Updated requests (\(requestCount - 1)) for currency pair '\(currencyPair.name)'.")
        }
        
        if currencyPairs.count == 0 {
            stopUpdateTimer()
        }
    }
    
    func getCurrentExchangeRate(for currencyPair: CurrencyPair) -> Double? {
        return currentExchangeRateForCurrencyPair[currencyPair]
    }
    
    func reset() {
        stopUpdateTimer()
        currencyPairs = Set<CurrencyPair>()
        requestsForCurrencyPair = [CurrencyPair: Int]()
        print("Reset TickerDaemon.")
    }
    
    @objc func update(completion: (() -> Void)?) {
        for (index, currencyPair) in currencyPairs.enumerated() {
            var updateCompletion: (() -> Void)? = nil
            
            if index == currencyPairs.count-1 {
                updateCompletion = completion
            }
            
            updateExchangeRate(for: currencyPair, completion: updateCompletion)
        }
    }
    
    @objc func startUpdateTimer() {
        guard updateTimer == nil else {
            // timer already running
            return
        }
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: { _ in
            self.update(completion: nil)
        })
        
        print("Started timer for TickerDaemon with \(updateInterval) second interval.")
    }
    
    @objc func stopUpdateTimer() {
        guard updateTimer != nil else {
            // no timer set
            return
        }
        
        updateTimer?.invalidate()
        updateTimer = nil
        print("Stopped timer for TickerDaemon.")
    }
    
    // MARK: - Private Methods
    private func updateExchangeRate(for currencyPair: CurrencyPair, completion: (() -> Void)?) {
        TickerConnector.fetchCurrentExchangeRate(for: currencyPair, completion: { result in
            switch result {
            case .success(let currentExchangeRate):
                self.currentExchangeRateForCurrencyPair[currencyPair] = currentExchangeRate.value
                print("Updated current exchange rate for currency pair '\(currencyPair.name)': \(currentExchangeRate.value)")
                self.delegate?.didUpdateCurrentExchangeRate(for: currencyPair)
                completion?()
            case .failure(let error):
                print("Failed to fetch current exchange rate for currency pair '\(currencyPair.name)': \(error)")
                completion?()
            }
        })
    }

}
