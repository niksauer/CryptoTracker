//
//  TrackerMenu.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 02.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Cocoa

@available(OSX 10.12, *)
protocol TrackerMenuDelegate {
    func didUpdateCurrentExchangeRate(for currencyPair: CurrencyPair)
}

@available(OSX 10.12, *)
class TrackerMenu: NSMenu, TickerDaemonDelegate {
    
    // MARK: - Public Properties
    var trackerMenuDelegate: TrackerMenuDelegate?
    
    // MARK: - Private Properties
    let formatter = CurrencyFormatter()
    var mainCurrencyPair = CurrencyPair(base: Blockchain.ETH, quote: Fiat.EUR)
    
    // MARK: - Initialization
    override init(title: String) {
        super.init(title: title)
        
        self.addItem(NSMenuItem(title: "Update", action: #selector(TickerDaemon.update(completion:)), keyEquivalent: ""))
        self.addItem(NSMenuItem.separator())
        self.addItem(NSMenuItem(title: "Open Chart", action: #selector(self.openURL), keyEquivalent: "o"))
        self.addItem(NSMenuItem(title: "Open Exchange", action: #selector(self.openURL), keyEquivalent: ""))
        self.addItem(NSMenuItem.separator())
        
//        let submenu = NSMenu(title: "Price")
//        let submenuItem = NSMenuItem(title: "Set Price", action: nil, keyEquivalent: ",")
//
//        self.addItem(submenuItem)
//        self.setSubmenu(submenu, for: submenuItem)
//
//        let option1 = NSMenuItem(title: "ETH/EUR", action: #selector(self.callSetSelection), keyEquivalent: "")
//        let option2 = NSMenuItem(title: "ETH/BTC", action: #selector(self.callSetSelection), keyEquivalent: "")
//
//        submenu.addItem(option1)
//        submenu.addItem(option2)
        
        self.addItem(NSMenuItem(title: "Quit", action: #selector(NSApp.terminate), keyEquivalent: "q"))
        
        TickerDaemon.delegate = self
        TickerDaemon.addCurrencyPair(mainCurrencyPair)
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    @objc func openURL(_ sender: NSMenuItem) {
        let exchange = "https://www.kraken.com/en-us/login"
        let chart = "https://cryptowatch.de/kraken/etheur"
        
        if sender.title == "Open Chart" {
            NSWorkspace.shared.open(URL(string: chart)!)
        } else if sender.title == "Open Exchange" {
            NSWorkspace.shared.open(URL(string: exchange)!)
        }
    }
    
    // MARK: - TickerDaemon Protocol
    func didUpdateCurrentExchangeRate(for currencyPair: CurrencyPair) {
        trackerMenuDelegate?.didUpdateCurrentExchangeRate(for: currencyPair)
    }

}
