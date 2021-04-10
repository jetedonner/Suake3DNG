//
//  LevelConfiguration.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit
import NetTestFW

class LevelConfigurationEnvironment: SuakeGameClass {
    
    let skyBoxHelper:SkyBoxHelper
    let floorHelper:FloorHelper
    
    var levelSize:LevelSize
    var duration:MatchDuration!
    var levelDifficulty:LevelDifficulty
    var lightIntensity:LightIntensity

    init(game: GameController, skyboxType:SkyboxType = .RandomSkyBox, floorType:FloorType = .RandomFloor, levelSize:LevelSize = .Small, duration:MatchDuration = .Minutes_2, lightIntensity:LightIntensity = .normal, levelDifficulty:LevelDifficulty = .Easy) {
        
        self.skyBoxHelper = SkyBoxHelper(game: game, skyboxType: skyboxType)
        self.floorHelper = FloorHelper(game: game, floorType: floorType)
       
        self.levelSize = levelSize
        self.duration = duration
        self.levelDifficulty = levelDifficulty
        self.lightIntensity = lightIntensity
        
        super.init(game: game)
    }
    
    func loadLevelEnvironment(){
        self.skyBoxHelper.setSkybox()
        self.floorHelper.setFloor()
    }
}

