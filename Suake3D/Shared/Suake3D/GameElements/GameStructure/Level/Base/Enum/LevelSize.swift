//
//  LevelSize.swift
//  Suake3D
//
//  Created by Kim David Hauser on 17.03.21.
//

import Foundation

enum LevelSize:String {
    case ExtraSmall =   "10,10"
    case Small =        "20,20"
    case Medium =       "30,30"
    case Big =          "40,40"
    case VeryBig =      "50,50"
    case Huge =         "70,70"
    
    func getNSSize()->NSSize{
        NSSize.convertFromStringLiteral(value: self.rawValue)
    }
    
    static func levelSize(fromString:String)->LevelSize{
        switch fromString {
        case "10x10":
            return .ExtraSmall
        case "20x20":
            return .Small
        case "30x30":
            return .Medium
        case "40x40":
            return .Big
        case "50x50":
            return .VeryBig
        case "70x70":
            return .Huge
        default:
            return .Small
        }
    }
}
