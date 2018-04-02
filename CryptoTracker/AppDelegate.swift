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
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var window: NSWindow!
    
    // MARK: - NSApplicationDelegate Protocol
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let _ = CryptoTrackerMenubarApp()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
        
}

