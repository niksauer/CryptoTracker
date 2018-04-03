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
        
        statusBarItem.title = formatter.getFormatting(for: exchangeRate, currency: currencyPair.base)
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
