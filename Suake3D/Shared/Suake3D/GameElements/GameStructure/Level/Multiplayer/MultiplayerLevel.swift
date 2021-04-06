//
//  MultiplayerLevel.swift
//  Suake3D
//
//  Created by Kim David Hauser on 06.04.21.
//

import Foundation
import NetTestFW

class MultiplayerLevel: SuakeBaseLevel{
    
    init(game: GameController, levelConfigNet:LoadLevelNetworkData) {
        let levelConfig:LevelConfiguration = LevelConfiguration(game: game)
        
        let levelConfigEnv:LevelConfigurationEnvironment = LevelConfigurationEnvironment(game: game)
        levelConfigEnv.levelSize = levelConfigNet.levelConfig.levelEnv.levelSize
        levelConfigEnv.skyBoxHelper.skyboxType = levelConfigNet.levelConfig.levelEnv.skyBoxType
        levelConfigEnv.duration = levelConfigNet.levelConfig.levelEnv.matchDuration
        levelConfigEnv.floorHelper.floorType = levelConfigNet.levelConfig.levelEnv.floorType
        levelConfigEnv.levelDifficulty = levelConfigNet.levelConfig.levelEnv.levelDifficulty
        levelConfigEnv.lightIntensity = levelConfigNet.levelConfig.levelEnv.lightIntensity
        
        super.init(game: game, levelConfig: levelConfig, levelConfigEnv: levelConfigEnv)
    }
}
