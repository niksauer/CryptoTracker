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

    let defaults = NSUserDefaults.standardUserDefaults()
    
    let statusBarItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let option1: NSMenuItem = NSMenuItem(title: "ETH/EUR", action: #selector(AppDelegate.callSetSelection), keyEquivalent: "")
    let option2: NSMenuItem = NSMenuItem(title: "ETH/BTC", action: #selector(AppDelegate.callSetSelection), keyEquivalent: "")
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let menu: NSMenu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Update", action: #selector(AppDelegate.updatePrice), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Open Chart", action: #selector(AppDelegate.openURL), keyEquivalent: "o"))
        menu.addItem(NSMenuItem(title: "Open Exchange", action: #selector(AppDelegate.openURL), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separatorItem())
        
        let submenu: NSMenu = NSMenu(title: "Price")
        let submenuItem: NSMenuItem = NSMenuItem(title: "Set Price", action: nil, keyEquivalent: ",")
        
        menu.addItem(submenuItem)
        menu.setSubmenu(submenu, forItem: submenuItem)
        
        submenu.addItem(option1)
        submenu.addItem(option2)
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
        
        statusBarItem.menu = menu
    
        checkForDefaults()
        statusBarItem.title = getPrice()
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(AppDelegate.updatePrice), userInfo: nil, repeats: true)
    }
    
    func openURL(sender: AnyObject) {
        let exchange = "https://www.kraken.com/en-us/login"
        let chart = "https://cryptowatch.de/kraken/etheur"
        
        if sender.title == "Open Chart" {
            NSWorkspace.sharedWorkspace().openURL(NSURL(string: chart)!)
        } else if sender.title == "Open Exchange" {
            NSWorkspace.sharedWorkspace().openURL(NSURL(string: exchange)!)
        }
    }
    
    func getJSON(urlToRequest: String) -> NSData {
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    func getPrice() -> String {
        let inputData = getJSON("https://api.kraken.com/0/public/Ticker?pair=" + defaults.stringForKey("setPrice")!)
        
        do {
            let ticker = try NSJSONSerialization.JSONObjectWithData(inputData, options: [])
            let bidArray = ticker["result"]??[defaults.stringForKey("setPair")!]??["c"] as! NSArray
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
    
    func callSetSelection(sender: AnyObject) {
        if sender.title == "ETH/EUR" {
            setSelection("ETHEUR")
        } else if sender.title == "ETH/BTC" {
            setSelection("ETHXBT")
        }
    }
    
    func setSelection(selection: String) {
        if selection == "ETHEUR" {
            defaults.setObject("ETHEUR", forKey: "setPrice")
            defaults.setObject("XETHZEUR", forKey: "setPair")
            option1.title = "ETH/EUR ✓"
            option2.title = "ETH/BTC"
        } else if selection == "ETHXBT" {
            defaults.setObject("ETHXBT", forKey: "setPrice")
            defaults.setObject("XETHXXBT", forKey: "setPair")
            option1.title = "ETH/EUR"
            option2.title = "ETH/BTC ✓"
        }
    }
    
    func checkForDefaults() {
        if (defaults.stringForKey("setPrice") == nil) {
            defaults.setObject("ETHEUR", forKey: "setPrice")
            defaults.setObject("XETHZEUR", forKey: "setPair")
            setSelection("ETHEUR")
        } else if (defaults.stringForKey("setPrice") == "ETHEUR") {
            setSelection("ETHEUR")
        } else if (defaults.stringForKey("setPrice") == "ETHXBT") {
            setSelection("ETHXBT")
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

