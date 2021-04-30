//
//  SuakeBasePlayerEntity.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeBasePlayerEntity: SuakeBaseNodeEntityWithHealth {
    
    let playerType:SuakePlayerType
    var statsComponent:SuakeStatsComponent!
    
    var _weapons:WeaponArsenalManager!
    var weapons:WeaponArsenalManager{
        get{ return self._weapons }
        set{ self._weapons = newValue }
    }
    
    init(game:GameController, playerType:SuakePlayerType = .OwnSuake, id:Int = 0){
        self.playerType = playerType
        
        super.init(game: game, id: id)
        
        self.setFieldType(playerType: playerType)
        
        self.statsComponent = SuakeStatsComponent(game: game, playerEntity: self)
        
        self.addComponent(self.statsComponent)
    }
    
//    var _dir:SuakeDir = .UP
//    var dir:SuakeDir{
//        get{ return self._dir }
//        set{
//            self._dir = newValue
//        }
//    }
//    
//    var _dirOld:SuakeDir = .UP
//    var dirOld:SuakeDir{
//       get{ return self._dirOld }
//       set{
//            self._dirOld = newValue
//       }
//    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
