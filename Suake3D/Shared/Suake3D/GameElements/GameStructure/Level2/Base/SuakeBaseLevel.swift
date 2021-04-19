//
//  SuakeBaseLevel.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class SuakeBaseLevel: SuakeGameClass {
    
    let levelConfig:LevelConfiguration
    var levelConfigEnv:LevelEnvironment
    let weaponPickUps:WeaponPickupEntityManager
    
    init(game: GameController, levelConfig:LevelConfiguration, levelConfigEnv:LevelEnvironment) {
        
        self.levelConfig = levelConfig
        self.levelConfigEnv = levelConfigEnv
        self.weaponPickUps = WeaponPickupEntityManager(game: game)
        
        super.init(game: game)
    }
    
//    func loadNetworkMatch(levelConfig:LoadLevelNetworkData){
//        self.levelConfigEnv.levelSize = levelConfig.levelConfig.levelEnv.levelSize
//        self.levelConfigEnv.skyBoxHelper.setSkybox(type: levelConfig.levelConfig.levelEnv.skyBoxType)
//        self.levelConfigEnv.duration = levelConfig.levelConfig.levelEnv.matchDuration
//        self.levelConfigEnv.floorHelper.setFloor(type: levelConfig.levelConfig.levelEnv.floorType)
//    }
    
    func loadLevel(){
        //TODO LOAD ENVIRONMENT
//        self.levelConfigEnv.loadLevelEnvironment()
        self.weaponPickUps.removeWeaponPickupEntities(weaponType: .mg)
        if(self.levelConfig.levelSetup.loadWeaponPickups){
            self.weaponPickUps.addWeaponPickupEntities(weaponType: .mg, numberOfWeaponPickups: 1)
        }
    }
}
