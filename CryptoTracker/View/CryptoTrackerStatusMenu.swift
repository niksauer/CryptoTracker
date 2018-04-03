//
//  CryptoTrackerStatusMenu
//  CryptoTracker
//
//  Created by Niklas Sauer on 02.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Cocoa

protocol CryptoTrackerStatusMenuDelegate {
    func didPressUpdateButton()
    func didPressOpenChartButton()
    func didPressOpenExchangeButton()
    func didPressQuitButton()
    
    func didSelectBaseCurrency(_ baseCurrency: Currency)
    func didSelectQuoteCurrency(_ quoteCurrency: Currency)
}

class CryptoTrackerStatusMenu: NSMenu {
    
    // MARK: - Public Properties
    var menuDelegate: CryptoTrackerStatusMenuDelegate?
    
    // MARK: - Private Properties
    let currencyManager = CurrencyManager()
 
    var mainCurrencyPair: CurrencyPair? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Initialization
    override init(title: String) {
        super.init(title: title)
        updateUI()
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func updateUI() {
        removeAllItems()
        
        let updateItem = NSMenuItem(title: "Update", action: #selector(didPressUpdateButton(_:)), keyEquivalent: "")
        updateItem.target = self
        addItem(updateItem)
        
        addItem(NSMenuItem.separator())
        
        let chartItem = NSMenuItem(title: "Open Chart", action: #selector(didPressOpenChartButton(_:)), keyEquivalent: "o")
        chartItem.target = self
        addItem(chartItem)
        
        let exchangeItem = NSMenuItem(title: "Open Exchange", action: #selector(didPressOpenExchangeButton(_:)), keyEquivalent: "")
        exchangeItem.target = self
        addItem(exchangeItem)
        
        addItem(NSMenuItem.separator())
        
        // base currency submenu
        let baseCurrencySubmenu = NSMenu(title: "Base Currency")
        let baseCurrencySubMenuItem = NSMenuItem(title: "Base Currency", action: nil, keyEquivalent: "")
        
        addItem(baseCurrencySubMenuItem)
        setSubmenu(baseCurrencySubmenu, for: baseCurrencySubMenuItem)
        
        for cryptoCurrency in Blockchain.allValues {
            let title: String
            
            if let mainCurrencyPair = mainCurrencyPair {
                title = mainCurrencyPair.base.isEqual(to: cryptoCurrency) ? "\(cryptoCurrency.code) ✓" : "\(cryptoCurrency.code)"
            } else {
                title = "\(cryptoCurrency.code)"
            }
            
            let optionItem = NSMenuItem(title: title, action: #selector(didSelectBaseCurrency(_:)), keyEquivalent: "")
            optionItem.target = self
            baseCurrencySubmenu.addItem(optionItem)
        }
        
        // quote currency submenu
        let quoteCurrencySubmenu = NSMenu(title: "Quote Currency")
        let quoteCurrencySubMenuItem = NSMenuItem(title: "Quote Currency", action: nil, keyEquivalent: "")
        
        addItem(quoteCurrencySubMenuItem)
        setSubmenu(quoteCurrencySubmenu, for: quoteCurrencySubMenuItem)
        
        for fiatCurrency in Fiat.allValues {
            if let mainCurrencyPair = mainCurrencyPair {
                title = mainCurrencyPair.quote.isEqual(to: fiatCurrency) ? "\(fiatCurrency.code) ✓" : "\(fiatCurrency.code)"
            } else {
                title = "\(fiatCurrency.code)"
            }
            
            let optionItem = NSMenuItem(title: title, action: #selector(didSelectQuoteCurrency(_:)), keyEquivalent: "")
            optionItem.target = self
            quoteCurrencySubmenu.addItem(optionItem)
        }
        
        quoteCurrencySubmenu.addItem(NSMenuItem.separator())
        
        for cryptoCurrency in Blockchain.allValues {
            if let mainCurrencyPair = mainCurrencyPair {
                title = mainCurrencyPair.quote.isEqual(to: cryptoCurrency) ? "\(cryptoCurrency.code) ✓" : "\(cryptoCurrency.code)"
            } else {
                title = "\(cryptoCurrency.code)"
            }
        
            let optionItem = NSMenuItem(title: title, action: #selector(didSelectQuoteCurrency(_:)), keyEquivalent: "")
            optionItem.target = self
            quoteCurrencySubmenu.addItem(optionItem)
        }
        
        addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(didPressQuitButton(_:)), keyEquivalent: "q")
        quitItem.target = self
        addItem(quitItem)
    }
    
    // MARK: - Private Methods
    @objc func didPressUpdateButton(_ sender: NSMenuItem) {
        menuDelegate?.didPressUpdateButton()
    }
    
    @objc func didPressOpenChartButton(_ sender: NSMenuItem) {
        menuDelegate?.didPressOpenChartButton()
    }
    
    @objc func didPressOpenExchangeButton(_ sender: NSMenuItem) {
        menuDelegate?.didPressOpenExchangeButton()
    }
    
    @objc func didPressQuitButton(_ sender: NSMenuItem) {
        menuDelegate?.didPressQuitButton()
    }
 
    @objc func didSelectBaseCurrency(_ sender: NSMenuItem) {
        guard let baseCurrency = currencyManager.getCurrency(from: sender.title) else {
            fatalError("Failed to create base currency from selected NSMenuItem title.")
        }
        
        menuDelegate?.didSelectBaseCurrency(baseCurrency)
    }
    
    @objc func didSelectQuoteCurrency(_ sender: NSMenuItem) {
        guard let quoteCurrency = currencyManager.getCurrency(from: sender.title) else {
            fatalError("Failed to create quote currency from selected NSMenuItem title.")
        }
    
        menuDelegate?.didSelectQuoteCurrency(quoteCurrency)
    }

}
