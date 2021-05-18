//
//  CollisionCategory.swift
//  Suake3D
//
//  Created by dave on 18.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit

struct CollisionCategory: OptionSet {
    let rawValue: Int
    static let suake =              CollisionCategory(rawValue: 1 << 0)  //            1
    static let suakeOpp =           CollisionCategory(rawValue: 1 << 1)  //            2
    static let rocket =             CollisionCategory(rawValue: 1 << 2)  //            4
    static let rocketBlast =        CollisionCategory(rawValue: 1 << 31)  //            4
    static let mgbullet =           CollisionCategory(rawValue: 1 << 3)  //            8
    static let pellet =             CollisionCategory(rawValue: 1 << 4)  //           16
    static let railbeam =           CollisionCategory(rawValue: 1 << 5)  //           32
    static let floor =              CollisionCategory(rawValue: 1 << 6)  //           64
    static let wall =               CollisionCategory(rawValue: 1 << 7)  //          128
    static let portal =           CollisionCategory(rawValue: 1 << 8)  //          256
//    static let portalOut =          CollisionCategory(rawValue: 1 << 9)  //          512
    static let goody =              CollisionCategory(rawValue: 1 << 10) //         1024
    static let nuke =               CollisionCategory(rawValue: 1 << 11) //         2048
    static let nukeBlast =          CollisionCategory(rawValue: 1 << 12) //         4096
    static let sniperRifleBullet =  CollisionCategory(rawValue: 1 << 13) //         8192
    static let suakeHead =          CollisionCategory(rawValue: 1 << 14) //        16384
    static let suakeMid =           CollisionCategory(rawValue: 1 << 15) //        32768
    static let suakeTail =          CollisionCategory(rawValue: 1 << 16) //        65536
    static let shotgunPickup =      CollisionCategory(rawValue: 1 << 17) //       131072
    static let railgunPickup =      CollisionCategory(rawValue: 1 << 18) //       262144
    static let machinegunPickup =   CollisionCategory(rawValue: 1 << 19) //       524288
    static let snipergunPickup =    CollisionCategory(rawValue: 1 << 20) //      1048576
    static let rpgPickup =          CollisionCategory(rawValue: 1 << 21) //      2097152
    static let nukePickup =         CollisionCategory(rawValue: 1 << 22) //      4194304
    static let rock =               CollisionCategory(rawValue: 1 << 23) //      8388608
    static let laserbeam =          CollisionCategory(rawValue: 1 << 24) //     16777216
    static let droid =              CollisionCategory(rawValue: 1 << 25) //     33554432
    static let medKit =             CollisionCategory(rawValue: 1 << 26) //     67108864
    static let container =          CollisionCategory(rawValue: 1 << 27) //    134217728
//    static let cottage =            CollisionCategory(rawValue: 1 << 28) //    268435456
    static let well =               CollisionCategory(rawValue: 1 << 29) //    536870912
    static let grenadePickup =      CollisionCategory(rawValue: 1 << 30) //   1073741824
//    static let grenadeBlast =       CollisionCategory(rawValue: 1 << 31) //   2147483648
//    static let tree =               CollisionCategory(rawValue: 1 << 32) //   4294967296
    static let generator =          CollisionCategory(rawValue: 1 << 28) //   ???!!!???
    
    static let allBulletCategories:[CollisionCategory] = [.laserbeam, .mgbullet, .pellet, .rocket, .railbeam, .sniperRifleBullet, .nuke, .nukeBlast]
    
    static func getAllBulletCats()->Int{
        return CollisionCategory(categories: self.allBulletCategories).rawValue
    }
    
    init(rawValue: Int){
        self.rawValue = rawValue
    }
    
    init(category:CollisionCategory){
        self.init(categories: [category])
    }
    
    init(categories:[CollisionCategory]){
        var newRawValue:Int = 0
        for category in categories{
            newRawValue = newRawValue | category.rawValue
        }
        self.init(rawValue: newRawValue)
    }
}
