//
//  CryptoTrackerStatusItem.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 02.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Cocoa

@available(OSX 10.12, *)
class CryptoTrackerStatusItem: NSStatusItem, TrackerMenuDelegate {
    override init() {
        super.init()
        
        title = "CryptoTracker"
        
        let menu = TrackerMenu(title: "CryptoTracker")
        menu.trackerMenuDelegate = self
    }
    
    // MARK: - TrackerMenu Protocol
    func didUpdateCurrentExchangeRate(for currencyPair: CurrencyPair) {
        guard let exchangeRate = currencyPair.currentExchangeRate else {
            return
        }
        
        self.title = String(exchangeRate)
    }
}
