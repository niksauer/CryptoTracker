//
//  CryptoTrackerStatusApp
//  CryptoTracker
//
//  Created by Niklas Sauer on 02.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Cocoa

struct CryptoTrackerStatusApp: TickerDaemonDelegate, CryptoTrackerStatusMenuDelegate {

    // MARK: - Public Properties
    var mainCurrencyPair = CurrencyPair(base: Blockchain.ETH, quote: Fiat.EUR)
    
    // MARK: - Private Properties
    private let statusBarItem: NSStatusItem
    private let statusBarMenu: CryptoTrackerStatusMenu
    
    private let tickerDaemon: TickerDaemon
    
    private let formatter = CurrencyFormatter()
    
    // MARK: - Initialization
    init(statusBarItem: NSStatusItem, tickerDaemon: TickerDaemon) {
        self.statusBarItem = statusBarItem
        self.tickerDaemon = tickerDaemon
        
        self.statusBarMenu = CryptoTrackerStatusMenu(title: "")
        statusBarMenu.menuDelegate = self
        
        statusBarItem.menu = statusBarMenu
        statusBarItem.title = "CryptoTracker"
    
        tickerDaemon.delegate = self
        tickerDaemon.addCurrencyPair(mainCurrencyPair)
    }
    
    // MARK: - TickerDaemonDelegate Protocol
    func didUpdateCurrentExchangeRate(for currencyPair: CurrencyPair) {
        guard let exchangeRate = tickerDaemon.getCurrentExchangeRate(for: currencyPair) else {
            return
        }
        
        guard let exchangeRateString = formatter.getFormatting(for: exchangeRate, currency: currencyPair.base) else {
            print("Failed to get currency formatting for exchange rate.")
            return
        }

        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: NSFont.systemFont(ofSize: 12)
        ]
        
        let attributedString = NSAttributedString(string: exchangeRateString, attributes: attributes)
        statusBarItem.attributedTitle = attributedString
    }

    // MARK: - CryptoTrackerMenubarMenuDelegate Protocol
    func didPressUpdateButton() {
        tickerDaemon.update(completion: nil)
    }
    
    func didPressOpenChartButton() {
        let url = URL(string: "https://cryptowatch.de/kraken/etheur")!
        NSWorkspace.shared.open(url)
    }
    
    func didPressOpenExchangeButton() {
        let url = URL(string: "https://www.kraken.com/en-us/login")!
        NSWorkspace.shared.open(url)
    }
    
    func didPressQuitButton() {
        NSApp.terminate(self)
    }
    
}
