//
//  WeaponType.swift
//  Suake3D
//
//  Created by Kim David Hauser on 27.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit


struct WeaponType: OptionSet, Hashable, Codable {
    var rawValue: Int
    
    static let none =                       WeaponType(rawValue: 1 << 0)  //            1
    
    static let laser =                      WeaponType(rawValue: 1 << 1)  //            2
    
    static let mg =                         WeaponType(rawValue: 1 << 2)  //            4
    static let shotgun =                    WeaponType(rawValue: 1 << 3)  //            8
    static let rpg =                        WeaponType(rawValue: 1 << 4)  //           16
    static let railgun =                    WeaponType(rawValue: 1 << 5)  //           32
    static let sniperrifle =                WeaponType(rawValue: 1 << 6)  //           64
    static let redeemer =                   WeaponType(rawValue: 1 << 7)  //          128
//    static let portal =                 NextMoveResult(rawValue: 1 << 8)  //          256
//
//    static let mgPickup =               NextMoveResult(rawValue: 1 << 9)  //          512
//    static let shotgunPickup =          NextMoveResult(rawValue: 1 << 10) //         1024
//    static let rpgPickup =              NextMoveResult(rawValue: 1 << 11) //         2048
//    static let railgunPickup =          NextMoveResult(rawValue: 1 << 12) //         4096
//    static let sniperriflePickup =      NextMoveResult(rawValue: 1 << 13) //         8192
//    static let nukePickup =             NextMoveResult(rawValue: 1 << 14) //        16384
    static let all      = [laser, mg, shotgun, rpg, railgun, sniperrifle, redeemer]
    static let allSuakePlayer      = [mg, shotgun, rpg, railgun, sniperrifle, redeemer]
    
    init(rawValue: Int){
        self.rawValue = rawValue
    }
    
    init(weaponType:WeaponType){
        self.init(weaponTypes: [weaponType])
    }

    init(weaponTypes:[WeaponType]){
        var newRawValue:Int = 0
        for weaponType in weaponTypes{
            newRawValue = newRawValue | weaponType.rawValue
        }
        self.init(rawValue: newRawValue)
    }
    
    mutating func addMoveResult(weaponType:WeaponType){
        self.rawValue = self.rawValue | weaponType.rawValue
    }
    
    mutating func removeMoveResult(weaponType:WeaponType){
        self.remove(weaponType)
    }
    
    func checkContains(contains:WeaponType)->Bool{
        return self.rawValue | contains.rawValue == self.rawValue
    }
    
    func toString()->String{
        switch self {
        case .none:
            return "None"
        case .laser:
            return "Laser"
        case .mg:
            return "Machinegun"
        case .shotgun:
            return "Shotgun"
        case .rpg:
            return "RPG"
        case .railgun:
            return "Railgun"
        case .sniperrifle:
            return "Sniperrifle"
        case .redeemer:
            return "Redeemer"
        default:
            return "Error"
        }
    }
    
    func toFieldType()->SuakeFieldType{
        var fieldType:SuakeFieldType = .empty
        switch self {
        case .mg:
            fieldType = .machinegun
            break
        case .shotgun:
            fieldType = .shotgun
            break
        case .rpg:
            fieldType = .rocketlauncher
            break
        case .railgun:
            fieldType = .railgun
            break
        case .sniperrifle:
            fieldType = .sniperrifle
            break
        case .redeemer:
            fieldType = .nuke
            break
        default:
            break
        }
        return fieldType
    }
}
