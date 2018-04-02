//
//  Exchange.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 02.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation

@available(OSX 10.12, *)
protocol Exchange {
    static func currentExchangeRate(for currencyPair: CurrencyPair, fromJSON data: Data) -> CurrentExchangeRateResult
    static func currentExchangeRateURL(for currencyPair: CurrencyPair) -> URL
}
