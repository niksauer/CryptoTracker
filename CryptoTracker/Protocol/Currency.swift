//
//  Currency.swift
//  Krypton
//
//  Created by Niklas Sauer on 24.08.17.
//  Copyright © 2017 Hewlett Packard Enterprise. All rights reserved.
//

import Foundation

enum CurrencyType: String {
    case Fiat
    case Crypto
}

protocol Currency {
    var code: String { get }
    var name: String { get }
    var symbol: String { get }
    var decimalDigits: Int { get }
    var type: CurrencyType { get }
    
    func isEqual(to: Currency) -> Bool
}

extension Currency {
    func isEqual(to: Currency) -> Bool {
        return self.code == to.code
    }
}
