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
}
