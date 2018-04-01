//
//  AppDelegate.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 20.05.16.
//  Copyright © 2016 Niklas Sauer. All rights reserved.
//

import Cocoa

enum KrakenAPIError: Error {
    case invalidJSON
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let defaults = UserDefaults.standard
    
    let statusBarItem = NSStatusBar.system.statusItem(withLength: -1)
    let option1: NSMenuItem = NSMenuItem(title: "ETH/EUR", action: #selector(AppDelegate.callSetSelection), keyEquivalent: "")
    let option2: NSMenuItem = NSMenuItem(title: "ETH/BTC", action: #selector(AppDelegate.callSetSelection), keyEquivalent: "")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let menu: NSMenu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Update", action: #selector(AppDelegate.updatePrice), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Open Chart", action: #selector(AppDelegate.openURL), keyEquivalent: "o"))
        menu.addItem(NSMenuItem(title: "Open Exchange", action: #selector(AppDelegate.openURL), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        let submenu: NSMenu = NSMenu(title: "Price")
        let submenuItem: NSMenuItem = NSMenuItem(title: "Set Price", action: nil, keyEquivalent: ",")
        
        menu.addItem(submenuItem)
        menu.setSubmenu(submenu, for: submenuItem)
        
        submenu.addItem(option1)
        submenu.addItem(option2)
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
        
        statusBarItem.menu = menu
    
        checkForDefaults()
        updatePrice()
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(AppDelegate.updatePrice), userInfo: nil, repeats: true)
    }
    
    @objc func openURL(_ sender: AnyObject) {
        let exchange = "https://www.kraken.com/en-us/login"
        let chart = "https://cryptowatch.de/kraken/etheur"
        
        if sender.title == "Open Chart" {
            NSWorkspace.shared.open(URL(string: chart)!)
        } else if sender.title == "Open Exchange" {
            NSWorkspace.shared.open(URL(string: exchange)!)
        }
    }
    
    func getJSON(_ urlToRequest: String) -> Data {
        return (try! Data(contentsOf: URL(string: urlToRequest)!))
    }
    
    func getPrice() throws -> String {
        let inputData = getJSON("https://api.kraken.com/0/public/Ticker?pair=" + defaults.string(forKey: "setPrice")!)
        
        let jsonObject = try JSONSerialization.jsonObject(with: inputData, options: [])
        
        guard let jsonDictionary = jsonObject as? [String: Any], let tickerDictionary = jsonDictionary["result"] as? [String: Any] else {
            throw KrakenAPIError.invalidJSON
        }
        
        guard let selectedPairDictionary = tickerDictionary[defaults.string(forKey: "setPair")!] as? [String: Any] else {
            return ""
        }
        
//        let currentPrice =
        
        
        //            let bidArray = ticker["result"][defaults.string(forKey: "setPair")!]??["c"] as! NSArray
        //            let price = bidArray[0] as! String
        //            let index = price.characters.index(price.startIndex, offsetBy: 5)
        //            return "Ξ" + price.substring(to: index)
        
        return "test"
    }
    
    @objc func updatePrice() {
        do {
            let newPrice = try getPrice()
            statusBarItem.title = newPrice
        } catch {
            // catch API error
        }
    }
    
    @objc func callSetSelection(_ sender: AnyObject) {
        if sender.title == "ETH/EUR" {
            setSelection("ETHEUR")
        } else if sender.title == "ETH/BTC" {
            setSelection("ETHXBT")
        }
    }
    
    func setSelection(_ selection: String) {
        if selection == "ETHEUR" {
            defaults.set("ETHEUR", forKey: "setPrice")
            defaults.set("XETHZEUR", forKey: "setPair")
            option1.title = "ETH/EUR ✓"
            option2.title = "ETH/BTC"
        } else if selection == "ETHXBT" {
            defaults.set("ETHXBT", forKey: "setPrice")
            defaults.set("XETHXXBT", forKey: "setPair")
            option1.title = "ETH/EUR"
            option2.title = "ETH/BTC ✓"
        }
    }
    
    func checkForDefaults() {
        if (defaults.string(forKey: "setPrice") == nil) {
            defaults.set("ETHEUR", forKey: "setPrice")
            defaults.set("XETHZEUR", forKey: "setPair")
            setSelection("ETHEUR")
        } else if (defaults.string(forKey: "setPrice") == "ETHEUR") {
            setSelection("ETHEUR")
        } else if (defaults.string(forKey: "setPrice") == "ETHXBT") {
            setSelection("ETHXBT")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

