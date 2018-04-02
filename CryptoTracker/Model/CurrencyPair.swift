//
//  CurrencyPair.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 02.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation

@available(OSX 10.12, *)
struct CurrencyPair: Hashable {
    
    // MARK: - Public Properties
    let base: Currency
    let quote: Currency
    
    var name: String {
        return base.code + quote.code
    }
    
    var currentExchangeRate: Double? {
        return getRate(on: Date())
    }
    
    // MARK: - Initialization
    init(base: Currency, quote: Currency) {
        self.base = base
        self.quote = quote
    }
    
    // MARK: - Public Methods
    func getRate(on date: Date) -> Double? {
        if date.isToday {
            return TickerDaemon.getCurrentExchangeRate(for: self)
        } else {
//            return ExchangeRate.getExchangeRate(for: self, on: date)
            return nil
        }
    }
    
    func register() {
        TickerDaemon.addCurrencyPair(self)
    }
    
    func deregister() {
        TickerDaemon.removeCurrencyPair(self)
    }
    
    // MARK: - Hashable Protocol
    var hashValue: Int {
        return name.hashValue
    }
    
    static func ==(lhs: CurrencyPair, rhs: CurrencyPair) -> Bool {
        return lhs.base.isEqual(to: rhs.base) && lhs.quote.isEqual(to: rhs.quote)
    }
    
}
