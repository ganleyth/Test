//
//  TimeInterval+Helpers.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/16/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    func rounded(toDecimalCount decimalCount: Int) -> TimeInterval {
        let temp = self * pow(10.0, Double(decimalCount))
        let tempInt = Int(temp)
        return Double(tempInt) / pow(10.0, Double(decimalCount))
    }
    
}
