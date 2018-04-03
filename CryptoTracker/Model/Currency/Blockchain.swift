//
//  Blockchain.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 02.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation

enum Blockchain: String, Currency {
    
    case ETH
    case BTC
    
    // MARK: - Private Properties
    private static let nameForBlockchain: [Blockchain: String] = [
        .ETH: "Ethereum",
        .BTC: "Bitcoin"
    ]
    
    private static let symbolForBlockchain: [Blockchain: String] = [
        .ETH : "Ξ",
        .BTC : "Ƀ"
    ]
    
    private static let decimalDigitsForBlockchain: [Blockchain: Int] = [
        .ETH: 18,
        .BTC: 8
    ]
    
    // MARK: - Public Properties
    static var allValues: [Currency] {
        return [ETH, BTC]
    }
    
    // MARK: - Currency Protocol
    var code: String {
        return rawValue
    }
    
    var name: String {
        return Blockchain.nameForBlockchain[self]!
    }
    
    var symbol: String {
        return Blockchain.symbolForBlockchain[self]!
    }
    
    var decimalDigits: Int {
        return Blockchain.decimalDigitsForBlockchain[self]!
    }
    
    var type: CurrencyType {
        return .Crypto
    }
        
}
