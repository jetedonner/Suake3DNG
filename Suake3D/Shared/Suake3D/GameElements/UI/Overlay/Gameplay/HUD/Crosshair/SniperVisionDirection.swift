//
//  SniperVisionDirection.swift
//  Suake3D
//
//  Created by Kim David Hauser on 14.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation

enum SniperVisionDirectionFull:Int {
    case N = 0
    case E = 1
    case S = 2
    case W = 3
    
    func toString()->String{
        switch self {
        case .N:
            return "North"
        case .E:
            return "East"
        case .S:
            return "Sout"
        case .W:
            return "West"
        }
    }
}

enum SniperVisionDirectionHalf:Int {
    case NE = 0
    case NW = 1
    case SW = 2
    case SE = 3
    
    func toString()->String{
        switch self {
        case .NE:
            return "North-East"
        case .NW:
            return "North-West"
        case .SW:
            return "South-West"
        case .SE:
            return "South-East"
        }
    }
}
