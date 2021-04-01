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

class DebugLevel: SuakeBaseLevel {
    
    init(game: GameController) {
        
        let levelConfig:LevelConfiguration = LevelConfiguration(game: game)
        let levelConfigEnv:LevelConfigurationEnvironment = LevelConfigurationEnvironment(game: game, levelSize: .ExtraSmall, duration: .Minutes_2)
        
        super.init(game: game, levelConfig: levelConfig, levelConfigEnv: levelConfigEnv)
    }
}
