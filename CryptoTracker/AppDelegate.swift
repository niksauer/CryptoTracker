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

    @IBOutlet weak var window: NSWindow!

    var statusBarItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusBarItem.title = getPrice()
        
        let menu: NSMenu = NSMenu()
        menu.addItem(NSMenuItem(title: "Update", action: #selector(AppDelegate.updatePrice), keyEquivalent: "u"))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Open Chart", action: #selector(AppDelegate.openKraken), keyEquivalent: "o"))
        menu.addItem(NSMenuItem(title: "Open Exchange", action: #selector(AppDelegate.openExchange), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
        
        statusBarItem.menu = menu
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(AppDelegate.updatePrice), userInfo: nil, repeats: true)
    }
    
    func openKraken() {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "https://cryptowatch.de/kraken/etheur")!)
    }
    
    func openExchange() {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "https://www.kraken.com/en-us/login")!)
    }
    
    func getJSON(urlToRequest: String) -> NSData {
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    func getPrice() -> String {
        let inputData = getJSON("https://api.kraken.com/0/public/Ticker?pair=ETHEUR")
        
        do {
            let ticker = try NSJSONSerialization.JSONObjectWithData(inputData, options: [])
            let bidArray = ticker["result"]??["XETHZEUR"]??["c"] as! NSArray
            let price = bidArray[0] as! String
            let index = price.startIndex.advancedBy(5)
            return "Ξ" + price.substringToIndex(index)
        } catch let error as NSError {
            print("An error occurred: \(error)")
            return("ERR")
        }
    }
    
    func updatePrice() {
        let newPrice = getPrice()
        statusBarItem.title = newPrice
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

