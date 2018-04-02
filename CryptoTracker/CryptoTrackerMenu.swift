//
//  CryptoTrackerMenu.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 02.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Cocoa

@available(OSX 10.12, *)
class CryptoTrackerMenu: NSMenu {
    
    // MARK: - Public Properties
    var menuDelegate: CryptoTrackerMenubarMenuDelegate?
    
    // MARK: - Initialization
    override init(title: String) {
        super.init(title: title)
        
        let updateItem = NSMenuItem(title: "Update", action: #selector(didPressUpdateButton(_:)), keyEquivalent: "")
        updateItem.target = self
        self.addItem(updateItem)
        
        self.addItem(NSMenuItem.separator())
        
        let chartItem = NSMenuItem(title: "Open Chart", action: #selector(didPressOpenChartButton(_:)), keyEquivalent: "o")
        chartItem.target = self
        self.addItem(chartItem)
        
        let exchangeItem = NSMenuItem(title: "Open Exchange", action: #selector(didPressOpenExchangeButton(_:)), keyEquivalent: "")
        exchangeItem.target = self
        self.addItem(exchangeItem)
        
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
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(CryptoTrackerMenu.didPressQuitButton(_:)), keyEquivalent: "q")
        quitItem.target = self
        self.addItem(quitItem)
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
}
