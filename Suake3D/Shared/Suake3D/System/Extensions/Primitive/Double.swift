//
//  Double.swift
//  Suake3D
//
//  Created by Kim David Hauser on 15.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation

extension Double {
    
    static let INTEGER_NO_DECIMAL_FORMAT = ".0"
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
    func sin(degrees: Double) -> Double {
        return __sinpi(degrees/180.0)
    }
    
    func sin() -> Double {
        return __sinpi(self/180.0)
    }
}
