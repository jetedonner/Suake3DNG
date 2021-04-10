//
//  MultiplayerLevel.swift
//  Suake3D
//
//  Created by Kim David Hauser on 06.04.21.
//

import Foundation
import NetTestFW

class MultiplayerLevel: SuakeBaseLevel{
    
    let levelConfigNet:LoadLevelNetworkData
    
    init(game: GameController, levelConfigNet:LoadLevelNetworkData) {
        self.levelConfigNet = levelConfigNet
        
        let levelConfig: LevelConfiguration = LevelConfiguration(game: game)
        
        let levelConfigEnv:LevelConfigurationEnvironment = LevelConfigurationEnvironment(game: game, skyboxType: levelConfigNet.levelConfig.levelEnv.skyBoxType, floorType: levelConfigNet.levelConfig.levelEnv.floorType, levelSize: levelConfigNet.levelConfig.levelEnv.levelSize,  duration: levelConfigNet.levelConfig.levelEnv.matchDuration, lightIntensity: levelConfigNet.levelConfig.levelEnv.lightIntensity, levelDifficulty: levelConfigNet.levelConfig.levelEnv.levelDifficulty)

        super.init(game: game, levelConfig: levelConfig, levelConfigEnv: levelConfigEnv)
    }
    
    override func loadLevel(){
        super.loadLevel()
        
        self.game.playerEntityManager.ownPlayerEntity.setup(pos: self.levelConfigNet.levelConfig.levelSetup.playerPos[0], dir: self.levelConfigNet.levelConfig.levelSetup.playerDir[0])
        
        self.game.playerEntityManager.oppPlayerEntity.setup(pos: self.levelConfigNet.levelConfig.levelSetup.playerPos[1], dir: self.levelConfigNet.levelConfig.levelSetup.playerDir[1])
        
//        self.game.locationEntityManager.entities[.MedKit].
//        self.levelConfigNet.levelConfig.levelSetup.medKitPos
        
        self.game.overlayManager.hud.overlayScene.loadInitialValues()
    }
}
