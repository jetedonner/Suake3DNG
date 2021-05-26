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
     
    var levelLoaded:Bool = false
    let levelConfig:LevelConfiguration
    var levelConfigEnv:LevelEnvironment
    let weaponPickUps:WeaponPickupEntityManager
    
    let skyBoxHelper:SkyBoxHelper
    let floorHelper:FloorHelper
    
    init(game: GameController, levelConfig:LevelConfiguration, levelConfigEnv:LevelEnvironment) {
        
        self.levelConfig = levelConfig
        self.levelConfigEnv = levelConfigEnv
        self.weaponPickUps = WeaponPickupEntityManager(game: game)
        
        self.skyBoxHelper = SkyBoxHelper(game: game, skyboxType: SkyboxType.randomQuake())
        self.floorHelper = FloorHelper(game: game, floorType: .Debug)
        
        super.init(game: game)
    }
    
    func loadLevel(){
//        if(self.levelLoaded){
            self.weaponPickUps.removeAllWeaponPickupEntities()
//        }
//            self.weaponPickUps.removeWeaponPickupEntities(weaponType: .mg)
//            self.weaponPickUps.removeWeaponPickupEntities(weaponType: .shotgun)
//            self.weaponPickUps.removeWeaponPickupEntities(weaponType: .rpg)
//            self.weaponPickUps.removeWeaponPickupEntities(weaponType: .railgun)
//            self.weaponPickUps.removeWeaponPickupEntities(weaponType: .sniperrifle)
//            self.weaponPickUps.removeWeaponPickupEntities(weaponType: .redeemer)
//        }
        
        self.loadLevelEnvironment()
        if(self.levelConfig.levelSetup.loadWeaponPickups){
            self.weaponPickUps.addWeaponPickupEntities(weaponType: .mg, numberOfWeaponPickups: 1)
            self.weaponPickUps.addWeaponPickupEntities(weaponType: .shotgun, numberOfWeaponPickups: 1)
            self.weaponPickUps.addWeaponPickupEntities(weaponType: .rpg, numberOfWeaponPickups: 1)
            self.weaponPickUps.addWeaponPickupEntities(weaponType: .railgun, numberOfWeaponPickups: 1)
            self.weaponPickUps.addWeaponPickupEntities(weaponType: .sniperrifle, numberOfWeaponPickups: 1)
            self.weaponPickUps.addWeaponPickupEntities(weaponType: .redeemer, numberOfWeaponPickups: 1)
        }
        
        if(self.levelConfigEnv.showTVMonitors){
            self.game.tvMonitorManager.initTVMonitors()
            self.game.tvMonitorManager.setTVMonitorImage(tvNoise: true)
        }
        self.levelLoaded = true
    }
    
    func loadLevelEnvironment(){
        self.skyBoxHelper.setSkybox()
        self.floorHelper.setFloor()
    }
}
