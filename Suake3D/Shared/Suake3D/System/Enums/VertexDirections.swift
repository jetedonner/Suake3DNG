//
//  Directions.swift
//  Suake3D
//
//  Created by dave on 25.04.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

enum Direction {
    case North
    case East
    case South
    case West
}

enum PlanarDirection {
    case NorthWest
    case NorthEast
    case SouthEast
    case SouthWest
    var cardinalDirections: (Direction, Direction) {
        switch self {
        case .NorthWest:
            return (.North, .West)
        case .NorthEast:
            return (.East, .North)
        case .SouthEast:
            return (.South, .East)
        case .SouthWest:
            return (.West, .South)
        }
    }
}
