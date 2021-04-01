//
//  INT.swift
//  Suake3D
//
//  Created by Kim David Hauser on 15.03.21.
//

import Foundation

extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.lowerBound < 0
        {
            offset = abs(range.lowerBound)
        }
        
        let mini = UInt32(range.lowerBound + offset)
        let maxi = UInt32(range.upperBound   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}
