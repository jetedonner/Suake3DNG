//
//  File.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class DebugLevel: SuakeBaseLevel {
    
    init(game: GameController) {
        
        let levelConfig:LevelConfiguration = LevelConfiguration()
        let levelConfigEnv:LevelEnvironment = LevelEnvironment(levelSize: .Small, floorType: .Debug, skyBoxType: .RedGalaxy, matchDuration: .Minute_1, levelDifficulty: .Easy, lightIntensity: .normal)
        
        super.init(game: game, levelConfig: levelConfig, levelConfigEnv: levelConfigEnv)
    }
    
    override func loadLevel(){
        super.loadLevel()
        
//        self.loadLevelEnvironment()
//        self.weaponPickUps.removeWeaponPickupEntities(weaponType: .mg)
//        if(self.levelConfig.levelSetup.loadWeaponPickups){
//            self.weaponPickUps.addWeaponPickupEntities(weaponType: .mg, numberOfWeaponPickups: 1)
//            self.weaponPickUps.addWeaponPickupEntities(weaponType: .shotgun, numberOfWeaponPickups: 1)
//            self.weaponPickUps.addWeaponPickupEntities(weaponType: .rpg, numberOfWeaponPickups: 1)
//            self.weaponPickUps.addWeaponPickupEntities(weaponType: .railgun, numberOfWeaponPickups: 1)
//            self.weaponPickUps.addWeaponPickupEntities(weaponType: .sniperrifle, numberOfWeaponPickups: 1)
//            self.weaponPickUps.addWeaponPickupEntities(weaponType: .redeemer, numberOfWeaponPickups: 1)
//        }
//
//        if(self.levelConfigEnv.showTVMonitors){
//            self.game.tvMonitorManager.initTVMonitors()
//            self.game.tvMonitorManager.setTVMonitorImage(tvNoise: true)
//        }
    }
    
    override func loadLevelEnvironment(){
        super.loadLevelEnvironment()
//        self.skyBoxHelper.setSkybox()
//        self.floorHelper.setFloor()
    }
}
