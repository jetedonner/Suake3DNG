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

        super.init(game: game, levelConfig: levelConfigNet.levelConfig, levelConfigEnv: levelConfigNet.levelConfig.levelEnv)
    }
    
    override func loadLevel(){
        super.loadLevel()
        
        self.game.playerEntityManager.ownPlayerEntity.setup(posDir: self.levelConfigNet.levelConfig.levelSetup.humanPlayerPosDir[0])
        
        self.game.playerEntityManager.oppPlayerEntity.setup(posDir: self.levelConfigNet.levelConfig.levelSetup.humanPlayerPosDir[1])
        
        self.game.playerEntityManager.goodyEntity.setup(pos: self.levelConfigNet.levelConfig.levelSetup.goodyPos)
        
        
        var idx:Int = 0
        for droidPosDir in self.levelConfigNet.levelConfig.levelSetup.droidPosDir{
            self.game.playerEntityManager.droidEntities[idx].setup(pos: droidPosDir.pos)
            self.game.playerEntityManager.droidEntities[idx].dir = droidPosDir.dir
            idx += 1
        }
        
        self.game.levelManager.currentLevel.weaponPickUps.getNewWeaponPickupEntity(weaponType: .mg).pos = self.levelConfigNet.levelConfig.levelSetup.mgPickupPos
        //MedKit
        self.game.locationEntityManager.removeLocationGroupsFromScene()
        self.game.locationEntityManager.initLocations(medKitPos: self.levelConfigNet.levelConfig.levelSetup.medKitPos)
        self.game.locationEntityManager.addLocationGroupsToScene(initPos: false)
        
        self.game.overlayManager.hud.overlayScene.loadInitialValues()
    }
}
