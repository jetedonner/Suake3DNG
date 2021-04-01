//
//  TimeInterval.swift
//  Suake3D
//
//  Created by Kim David Hauser on 15.03.21.
//

import Foundation

extension TimeInterval {
    
    func format(using units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self)
    }
}
