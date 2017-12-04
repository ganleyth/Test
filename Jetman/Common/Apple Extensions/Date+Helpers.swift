//
//  Date+Helpers.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/3/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import Foundation

extension Date {
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }()
    
    // MARK: Static methods
    
    // MARK: Instance methods
    
    func stringWith(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        Date.dateFormatter.dateStyle = dateStyle
        Date.dateFormatter.timeStyle = timeStyle
        
        return Date.dateFormatter.string(from: self)
    }
    
    func stringWithFormat(_ format: String) -> String {
        Date.dateFormatter.dateFormat = format
        
        return Date.dateFormatter.string(from: self)
    }
    
}
