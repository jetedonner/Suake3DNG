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
        
//        let levelConfig: LevelConfiguration = LevelConfiguration()
//
//        let levelEnv:LevelEnvironment = LevelEnvironment(levelSize: <#T##LevelSize#>, floorType: <#T##FloorType#>, skyBoxType: <#T##SkyboxType#>, matchDuration: <#T##MatchDuration#>, levelDifficulty: <#T##LevelDifficulty#>, lightIntensity: <#T##LightIntensity#>)
//        let levelConfigEnv:LevelEnvironment = LevelEnvironment(skyboxType: levelConfigNet.levelConfig.levelEnv.skyBoxType, floorType: levelConfigNet.levelConfig.levelEnv.floorType, levelSize: levelConfigNet.levelConfig.levelEnv.levelSize,  duration: levelConfigNet.levelConfig.levelEnv.matchDuration, lightIntensity: levelConfigNet.levelConfig.levelEnv.lightIntensity, levelDifficulty: levelConfigNet.levelConfig.levelEnv.levelDifficulty)

        super.init(game: game, levelConfig: levelConfigNet.levelConfig, levelConfigEnv: levelConfigNet.levelConfig.levelEnv)
    }
    
    override func loadLevel(){
        super.loadLevel()
        
        self.game.playerEntityManager.ownPlayerEntity.setup(posDir: self.levelConfigNet.levelConfig.levelSetup.humanPlayerPosDir[0])
        
        self.game.playerEntityManager.oppPlayerEntity.setup(posDir: self.levelConfigNet.levelConfig.levelSetup.humanPlayerPosDir[1])
//        self.game.playerEntityManager.ownPlayerEntity.setup(pos:  self.levelConfigNet.levelConfig.levelSetup.playerPos[0], dir: self.levelConfigNet.levelConfig.levelSetup.playerDir[0])
        
//        self.game.playerEntityManager.oppPlayerEntity.setup(pos: self.levelConfigNet.levelConfig.levelSetup.playerPos[1], dir: self.levelConfigNet.levelConfig.levelSetup.playerDir[1])
        
        self.game.playerEntityManager.goodyEntity.setup(pos: self.levelConfigNet.levelConfig.levelSetup.goodyPos)
        
        
        for droid in self.game.playerEntityManager.droidsNotDead{
            droid.setup(posDir: self.levelConfigNet.levelConfig.levelSetup.droidPosDir[0])
//            droid.setup(pos: self.levelConfigNet.levelConfig.levelSetup.droidsPos[droid.id], dir: self.levelConfigNet.levelConfig.levelSetup.droidsDir[droid.id])
        }
        
        self.game.levelManager.currentLevel.weaponPickUps.getNewWeaponPickupEntity(weaponType: .mg).pos = self.levelConfigNet.levelConfig.levelSetup.mgPickupPos
        //MedKit
        self.game.locationEntityManager.removeLocationGroupsFromScene()
        self.game.locationEntityManager.initLocations(medKitPos: self.levelConfigNet.levelConfig.levelSetup.medKitPos)
        self.game.locationEntityManager.addLocationGroupsToScene(initPos: false)
        
        self.game.overlayManager.hud.overlayScene.loadInitialValues()
    }
}
