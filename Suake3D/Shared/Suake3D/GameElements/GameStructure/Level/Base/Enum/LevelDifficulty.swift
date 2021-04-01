//
//  SuakeLevelDifficulties.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation

enum LevelDifficulty:String {
    case Tutorial = "Tutorial"
    case Easy = "Easy"
    case Medium = "Medium"
    case Hard = "Hard"
    case Nightmare = "Nightmare"
    case Unreal = "Unreal"
    
    static func levelDifficulty(fromString:String)->LevelDifficulty{
        switch fromString {
        case "Tutorial":
            return .Tutorial
        case "Easy":
            return .Easy
        case "Medium":
            return .Medium
        case "Hard":
            return .Hard
        case "Nightmare":
            return .Nightmare
        case "Unreal":
            return .Unreal
        default:
            return .Medium
        }
    }
}
