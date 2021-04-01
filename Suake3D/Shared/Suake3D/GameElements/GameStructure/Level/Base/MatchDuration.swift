//
//  SuakeMatchDurration.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation

enum MatchDuration:TimeInterval{
    case Infinite = 9999999999.99999
    case Seconds_10 = 10.0
    case Seconds_20 = 20.0
    case Seconds_30 = 30.0
    case Seconds_45 = 45.0
    case Minute_1 = 60.0
    case Minutes_2 = 120.0
    case Minutes_5 = 300.0
    case Minutes_10 = 600.0
    case Minutes_12 = 720.0
    case Minutes_15 = 900.0
    
    static func matchDuration(fromString:String)->MatchDuration{
        switch fromString {
        case "Infinite ∞":
            return .Infinite
        case "10 Seconds":
            return .Seconds_10
        case "20 Seconds":
            return .Seconds_20
        case "30 Seconds":
            return .Seconds_30
        case "45 Seconds":
            return .Seconds_45
        case "1 Minute":
            return .Minute_1
        case "2 Minutes":
            return .Minutes_2
        case "5 Minutes":
            return .Minutes_5
        case "10 Minutes":
            return .Minutes_10
        case "12 Minutes":
            return .Minutes_12
        case "15 Minutes":
            return .Minutes_15
        default:
            return .Minutes_2
        }
    }
}
