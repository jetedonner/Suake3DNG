//
//  NextMoveResult.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.11.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import NetTestFW

struct NextMoveResult: OptionSet {
    var rawValue: Int
    
    var pos:SCNVector3 = SCNVector3(0, 0, 0)
    var fieldType:SuakeFieldType = .empty
    var fieldEntity:SuakeBaseEntity? = nil
    
    static let moveOk =                 NextMoveResult(rawValue: 1 << 0)  //            1
    static let moveNotOk =              NextMoveResult(rawValue: 1 << 1)  //            2
    
    static let suakeOwn =               NextMoveResult(rawValue: 1 << 2)  //            4
    static let suakeOpp =               NextMoveResult(rawValue: 1 << 3)  //            8
    static let droid =                  NextMoveResult(rawValue: 1 << 4)  //           16
    static let goody =                  NextMoveResult(rawValue: 1 << 5)  //           32
    
    static let wall =                   NextMoveResult(rawValue: 1 << 6)  //           64
    static let medkit =                 NextMoveResult(rawValue: 1 << 7)  //          128
    static let portal =                 NextMoveResult(rawValue: 1 << 8)  //          256
    
    static let mgPickup =               NextMoveResult(rawValue: 1 << 9)  //          512
    static let shotgunPickup =          NextMoveResult(rawValue: 1 << 10) //         1024
    static let rpgPickup =              NextMoveResult(rawValue: 1 << 11) //         2048
    static let railgunPickup =          NextMoveResult(rawValue: 1 << 12) //         4096
    static let sniperriflePickup =      NextMoveResult(rawValue: 1 << 13) //         8192
    static let nukePickup =             NextMoveResult(rawValue: 1 << 14) //        16384
    
    init(rawValue: Int){
        self.rawValue = rawValue
    }
    
    init(moveResult:NextMoveResult, pos:SCNVector3 = SCNVector3(0, 0, 0)){
        self.init(moveResults: [moveResult], pos: pos)
    }

    init(moveResults:[NextMoveResult], pos:SCNVector3 = SCNVector3(0, 0, 0)){
        var newRawValue:Int = 0
        for moveResult in moveResults{
            newRawValue = newRawValue | moveResult.rawValue
        }
        self.init(rawValue: newRawValue)
        self.pos = pos
    }
    
    mutating func addMoveResult(moveResult:NextMoveResult){
        self.rawValue = self.rawValue | moveResult.rawValue
    }
    
    mutating func removeMoveResult(moveResult:NextMoveResult){
        self.remove(moveResult)
    }
    
    func checkContains(contains:NextMoveResult)->Bool{
        return self.rawValue | contains.rawValue == self.rawValue
    }
}
