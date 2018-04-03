//
//  CurrencyFormatter.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 02.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation

struct CurrencyFormatter {    
    func getFormatting(for value: Double, currency: Currency) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = currency.decimalDigits
        
        if let formattedString = formatter.string(from: NSNumber(value: value)) {
            return "\(currency.symbol) \(formattedString)"
        } else {
            return nil
        }
    }
}
