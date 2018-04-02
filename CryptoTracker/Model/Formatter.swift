//
//  Formatter.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 02.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation

struct CurrencyFormatter {
    func getCryptoFormatting(for value: Double, blockchain: Blockchain, digits: Int?) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = digits ?? blockchain.decimalDigits
        
        if let formattedString = formatter.string(from: NSNumber(value: value)) {
            return "\(blockchain.symbol) \(formattedString)"
        } else {
            return nil
        }
    }
}
