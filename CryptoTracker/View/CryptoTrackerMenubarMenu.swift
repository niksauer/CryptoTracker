//
//  CryptoTrackerMenubarMenu.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 02.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Cocoa

protocol CryptoTrackerMenubarMenuDelegate {
    func didPressUpdateButton()
    func didPressOpenChartButton()
    func didPressOpenExchangeButton()
    func didPressQuitButton()
}

class CryptoTrackerMenubarMenu: NSObject {
    
    // MARK: - Outlets
    @IBOutlet weak var menu: NSMenu!
    
    // MARK: - Public Properties
    var delegate: CryptoTrackerMenubarMenuDelegate?
    
    // MARK: - Public Methods
    @IBAction func updateButtonPressed(_ sender: NSMenuItem) {
        delegate?.didPressUpdateButton()
    }
    
    @IBAction func openChartButtonPressed(_ sender: NSMenuItem) {
        delegate?.didPressOpenChartButton()
    }
    
    @IBAction func openExchangeButtonPressed(_ sender: NSMenuItem) {
        delegate?.didPressOpenExchangeButton()
    }
    
    @IBAction func quitButtonPressed(_ sender: NSMenuItem) {
        delegate?.didPressQuitButton()
    }
    
}
