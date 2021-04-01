//
//  Double.swift
//  Suake3D
//
//  Created by Kim David Hauser on 15.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation

extension CGFloat {
    
    static let INTEGER_NO_DECIMAL_FORMAT = ".0"
    static let INTEGER_NO_DECIMAL_LEADING_ZERO_FOUR_FORMAT = "04"
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
    func formatNG(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
    
}

extension CGFloat
{
    func truncate(places : Int)-> CGFloat
    {
        return CGFloat(floor(pow(10.0, CGFloat(places)) * self)/pow(10.0, CGFloat(places)))
    }
}
