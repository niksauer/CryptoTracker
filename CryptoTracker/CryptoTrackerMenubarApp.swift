//
//  CryptoTrackerMenubarApp.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 02.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Cocoa

@available(OSX 10.12, *)
struct CryptoTrackerMenubarApp: TickerDaemonDelegate, CryptoTrackerMenubarMenuDelegate {

    // MARK: - Public Properties
    var mainCurrencyPair = CurrencyPair(base: Blockchain.ETH, quote: Fiat.EUR)
    
    // MARK: - Private Properties
    private let statusBarItem: NSStatusItem
    private let menu: NSMenu
    private let formatter = CurrencyFormatter()
    
    // MARK: - Initialization
    init() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        let cryptoTrackerMenu = CryptoTrackerMenu(title: "")
        menu = cryptoTrackerMenu
        cryptoTrackerMenu.menuDelegate = self
        
        
        statusBarItem.menu = menu
        statusBarItem.title = "CryptoTracker"
        
        TickerDaemon.delegate = self
        TickerDaemon.addCurrencyPair(mainCurrencyPair)
    }
    
    // MARK: - TickerDaemonDelegate Protocol
    func didUpdateCurrentExchangeRate(for currencyPair: CurrencyPair) {
        guard let exchangeRate = currencyPair.currentExchangeRate else {
            return
        }
        
        statusBarItem.title = formatter.getCryptoFormatting(for: exchangeRate, blockchain: Blockchain.ETH, digits: 2)
    }

    // MARK: - CryptoTrackerMenubarMenuDelegate Protocol
    func didPressUpdateButton() {
        TickerDaemon.update(completion: nil)
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
