//
//  SuakePlayerType.swift
//  Suake3D
//
//  Created by Kim David Hauser on 23.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation

enum SuakePlayerType:String{
    case None = "None"
    case OwnSuake = "You, your own suake"
    case OppSuake = "Opponent suake"
    case Droid = "A droid player"
    case Goody = "A goody "
}

enum SuakePart:String{
    case straightToStraight = "Straight to straight"
    case straightToRight = "Straight to right"
    case straightToLeft = "Straight to left"
    case rightToStraight = "Right to straight"
    case leftToStraight = "Left to straight"
    case rightToRight = "Right to right"
    case leftToRight = "Left to right"
    case rightToLeft = "Right to left"
    case leftToLeft = "Left to left"
    case none = "None"
}
