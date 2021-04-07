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
    
    override func loadLevel(){
        super.loadLevel()
        self.game.playerEntityManager.ownPlayerEntity.pos = self.levelConfigNet.levelConfig.levelSetup.playerPos[0]
        self.game.playerEntityManager.ownPlayerEntity.dir = self.levelConfigNet.levelConfig.levelSetup.playerDir[0]
        self.game.playerEntityManager.ownPlayerEntity.dirOld = self.game.playerEntityManager.ownPlayerEntity.dir
        
        SuakeDirTurnDirHelper.initNodeRotation(node: self.game.playerEntityManager.ownPlayerEntity.suakePlayerComponent.mainNode, dir: self.game.playerEntityManager.ownPlayerEntity.dir)
        
        self.game.playerEntityManager.oppPlayerEntity.pos = self.levelConfigNet.levelConfig.levelSetup.playerPos[1]
        self.game.playerEntityManager.oppPlayerEntity.dir = self.levelConfigNet.levelConfig.levelSetup.playerDir[1]
        self.game.playerEntityManager.oppPlayerEntity.dirOld = self.game.playerEntityManager.oppPlayerEntity.dir
        
        SuakeDirTurnDirHelper.initNodeRotation(node: self.game.playerEntityManager.oppPlayerEntity.suakePlayerComponent.mainNode, dir: self.game.playerEntityManager.oppPlayerEntity.dir)
        
        self.game.overlayManager.hud.overlayScene.loadInitialValues()
    }
}
