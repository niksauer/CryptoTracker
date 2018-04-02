//
//  Date.swift
//  CryptoTracker
//
//  Created by Niklas Sauer on 02.04.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import Foundation

extension Date {
    
    // MARK: - Public Properties
    /// returns specified date in specified timezone but with set time of 0AM
    var UTCStart: Date {
        var calendar = Calendar(identifier: .gregorian)
        let timezone = TimeZone(abbreviation: "UTC")!
        calendar.timeZone = timezone
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: self)
        return calendar.date(from: dateComponents)!
    }
    
    /// returns successor of specified date in specified timezone but with set time of 0AM
    var UTCEnd: Date {
        var calendar = Calendar(identifier: .gregorian)
        let timezone = TimeZone(abbreviation: "UTC")!
        calendar.timeZone = timezone
        return calendar.date(byAdding: .day, value: +1, to: self.UTCStart)!
    }
    
    var isUTCToday: Bool {
        var calendar = Calendar(identifier: .gregorian)
        let timezone = TimeZone(abbreviation: "UTC")!
        calendar.timeZone = timezone
        return calendar.compare(self, to: Date(), toGranularity: .day) == .orderedSame
    }
    
    var isUTCFuture: Bool {
        var calendar = Calendar(identifier: .gregorian)
        let timezone = TimeZone(abbreviation: "UTC")!
        calendar.timeZone = timezone
        return calendar.compare(self, to: Date(), toGranularity: .day) == .orderedDescending
    }
    
    /// checks whether date is today according to current (system) calendar
    var isToday: Bool {
        return Calendar.current.compare(self, to: Date(), toGranularity: .day) == .orderedSame
    }
    
    /// checks whether date lays in future according to current (system) calendar
    var isFuture: Bool {
        return Calendar.current.compare(self, to: Date(), toGranularity: .day) == .orderedDescending
    }
    
}
