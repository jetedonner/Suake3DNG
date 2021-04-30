//
//  NumberFormatterHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 09.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation


class NumberFormatterHelper: NSObject {
    
    static func getFormatedString(number:NSNumber, digits:Int = 3)->String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = digits
        numberFormatter.maximumFractionDigits = digits

        return numberFormatter.string(from: number)!
    }
}
