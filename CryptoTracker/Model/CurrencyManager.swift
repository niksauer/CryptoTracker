//
//  CurrencyManager.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 03.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation

struct CurrencyManager {
    
    // MARK: - Public Methods
    func getCurrency(from code: String) -> Currency? {
        return Fiat(rawValue: code) ?? Blockchain(rawValue: code)
    }
    
    func getAllCurrencies() -> [Currency] {
        return Fiat.allValues + Blockchain.allValues
    }
}
