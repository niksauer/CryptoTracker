//
//  CryptoTrackerStatusApp
//  CryptoTracker
//
//  Created by Niklas Sauer on 02.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Cocoa

class CryptoTrackerStatusApp: TickerDaemonDelegate, CryptoTrackerStatusMenuDelegate {
    
    // MARK: - Public Properties
    var mainCurrencyPair: CurrencyPair = CurrencyPair(base: Blockchain.ETH, quote: Fiat.EUR)
    
    // MARK: - Private Properties
    private let statusBarItem: NSStatusItem
    private let statusBarMenu: CryptoTrackerStatusMenu
    private let tickerDaemon: TickerDaemon
    private let formatter = CurrencyFormatter()
    private let defaults: UserDefaults
    private let currencyManager = CurrencyManager()
    
    // MARK: - Initialization
    init(statusBarItem: NSStatusItem, tickerDaemon: TickerDaemon, defaults: UserDefaults) {
        self.statusBarItem = statusBarItem
        self.tickerDaemon = tickerDaemon
        self.defaults = defaults
        
        self.statusBarMenu = CryptoTrackerStatusMenu(title: "")
        statusBarMenu.menuDelegate = self
        
        mainCurrencyPair = loadMainCurrencyPair() ?? CurrencyPair(base: Blockchain.ETH, quote: Fiat.EUR)
        
        statusBarMenu.mainCurrencyPair = mainCurrencyPair
        
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

    // MARK: - CryptoTrackerStatusMenuDelegate Protocol
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
    
    func didSelectBaseCurrency(_ baseCurrency: Currency) {
        let currencyPair = CurrencyPair(base: baseCurrency, quote: mainCurrencyPair.quote)
        setMainCurrencyPair(currencyPair)
    }
    
    func didSelectQuoteCurrency(_ quoteCurrency: Currency) {
        let currencyPair = CurrencyPair(base: mainCurrencyPair.base, quote: quoteCurrency)
        setMainCurrencyPair(currencyPair)
    }
    
    func setMainCurrencyPair(_ currencyPair: CurrencyPair) {
        tickerDaemon.removeCurrencyPair(mainCurrencyPair)
        self.mainCurrencyPair = currencyPair
        tickerDaemon.addCurrencyPair(mainCurrencyPair)
        print("Changed main currency pair: \(mainCurrencyPair.name)")
        
        saveMainCurrencyPair()
        
        statusBarMenu.mainCurrencyPair = mainCurrencyPair
    }

    func saveMainCurrencyPair() {
        defaults.set(mainCurrencyPair.base.code, forKey: "baseCurrency")
        defaults.set(mainCurrencyPair.quote.code, forKey: "quoteCurrency")
        defaults.synchronize()
    }
    
    func loadMainCurrencyPair() -> CurrencyPair? {
        guard let baseCurrencyCode = defaults.string(forKey: "baseCurrency"), let quoteCurrencyCode = defaults.string(forKey: "quoteCurrency") else {
            print("Failed to load base or quote currency from user defaults.")
            return nil
        }
        
        guard let baseCurrency = currencyManager.getCurrency(from: baseCurrencyCode), let quoteCurrency = currencyManager.getCurrency(from: quoteCurrencyCode) else {
            print("Failed to create base or quote currency from stored settings.")
            return nil
        }
        
        return CurrencyPair(base: baseCurrency, quote: quoteCurrency)
    }
}
