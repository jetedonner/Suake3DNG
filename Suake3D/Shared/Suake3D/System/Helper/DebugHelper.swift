//
//  DebugHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 30.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

protocol IntString_Enum  {
      var description: String { get }
}

struct DbgLevel: OptionSet {
    let rawValue: Int
    static let Console =                        DbgLevel(rawValue: 1 << 0)  //            1
    static let Hud =                            DbgLevel(rawValue: 1 << 1)  //            2
    static let Error =                          DbgLevel(rawValue: 1 << 2)  //            4
    static let Warning =                        DbgLevel(rawValue: 1 << 3)  //            8
    static let InfoFlag =                       DbgLevel(rawValue: 1 << 4)  //           16
    static let Detailed =                       DbgLevel(rawValue: 1 << 5)  //           32
    static let Verbose =                        DbgLevel(rawValue: 1 << 6)  //           64
  
    static let Info =                           DbgLevel(dbgLevels: [.Console, .Hud, .InfoFlag])  //          128
    static let InfoOnlyConsole =                DbgLevel(dbgLevels: [.Console, .InfoFlag])  //          256
    
    init(rawValue: Int){
        self.rawValue = rawValue
    }

    init(dbgLevels:[DbgLevel]){
        var newRawValue:Int = 0
        for dbgLevel in dbgLevels{
            newRawValue = newRawValue | dbgLevel.rawValue
        }
        self.init(rawValue: newRawValue)
    }
}


class DebugHelper: SuakeGameClass {
    
    var currentDbgLevel:DbgLevel = .Info
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func showDbgMsg(msg:String, dbgLevel:DbgLevel = .Info){
        if(dbgLevel.rawValue <= self.currentDbgLevel.rawValue){
            print(msg)
//            if(!self.game.overlayManager.hud.hudEntity.dbgLogComponent.isHidden && dbgLevel.contains(.Hud)){
//                self.game.overlayManager.hud.hudEntity.dbgLogComponent.logDbgMsg(msg: msg)
//            }
        }
    }
}
