//
//  AppDelegate.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 20.05.16.
//  Copyright © 2016 Niklas Sauer. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var window: NSWindow!
    
    // MARK: - Private Properties
    var statusApp: CryptoTrackerStatusApp?
    
    // MARK: - NSApplicationDelegate Protocol
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let tickerDaemon = TickerDaemon.shared
        let defaults = UserDefaults.standard
        statusApp = CryptoTrackerStatusApp(statusBarItem: statusBarItem, tickerDaemon: tickerDaemon, defaults: defaults)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
        
}
