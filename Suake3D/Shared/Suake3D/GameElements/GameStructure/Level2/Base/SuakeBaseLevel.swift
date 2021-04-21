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
    
    let skyBoxHelper:SkyBoxHelper
    let floorHelper:FloorHelper
    
    init(game: GameController, levelConfig:LevelConfiguration, levelConfigEnv:LevelEnvironment) {
        
        self.levelConfig = levelConfig
        self.levelConfigEnv = levelConfigEnv
        self.weaponPickUps = WeaponPickupEntityManager(game: game)
        
        self.skyBoxHelper = SkyBoxHelper(game: game, skyboxType: .PinkSunrise)
        self.floorHelper = FloorHelper(game: game, floorType: .Debug)
        
        super.init(game: game)
    }
    
    func loadLevel(){
        self.loadLevelEnvironment()
        self.weaponPickUps.removeWeaponPickupEntities(weaponType: .mg)
        if(self.levelConfig.levelSetup.loadWeaponPickups){
            self.weaponPickUps.addWeaponPickupEntities(weaponType: .mg, numberOfWeaponPickups: 1)
        }
    }
    
    func loadLevelEnvironment(){
        self.skyBoxHelper.setSkybox()
        self.floorHelper.setFloor()
    }
}
