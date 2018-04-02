//
//  AppDelegate.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 20.05.16.
//  Copyright © 2016 Niklas Sauer. All rights reserved.
//

import Cocoa

@available(OSX 10.12, *)
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, TrackerMenuDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var window: NSWindow!

    // MARK: - Public Properties
    let defaults = UserDefaults.standard
    let statusBarItem = NSStatusBar.system.statusItem(withLength: -1)
    
    // MARK: - NSApplicationDelegate Protocol
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let trackerMenu = TrackerMenu(title: "CryptoTracker")
        trackerMenu.trackerMenuDelegate = self

        statusBarItem.menu = trackerMenu
        statusBarItem.title = "CryptoTracker"
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // MARK: - TrackerMenu Protocol
    func didUpdateCurrentExchangeRate(for currencyPair: CurrencyPair) {
        guard let exchangeRate = currencyPair.currentExchangeRate else {
            return
        }
        
        statusBarItem.title = String(exchangeRate)
    }
    
}

