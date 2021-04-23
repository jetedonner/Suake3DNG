//
//  SuakeStateReadyToPlay.swift
//  Suake3D
//
//  Created by Kim David Hauser on 21.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeStateMatchOver: SuakeBaseState {
    
    var lost:Bool = true
    var resultsShowIng:Bool = false
    
    init(game: GameController) {
        super.init(game: game, stateDesc: GameStates.matchOverState)
    }
    
    override func didEnter(from previousState: GKState?) {
        if(previousState is SuakeStatePlaying || previousState is SuakeStateMultiplayerPlaying || previousState is SuakeStateReadyToPlay){
//            self.game.playerEntityManager.getPlayerEntity(ofType: SuakeOwnPlayerEntity.self, id: 0)?.isPaused = true
//            self.game.cameraHelper.toggleFPV(newFPV: false)
            if(self.game.levelManager.currentLevel == self.game.levelManager.dbgLevel){
//                _ = self.game.gameCenterHelper.checkAchievement(achievementID: SuakeAchievementTypes.tutorial00_01)
            }
            self.game.overlayManager.showOverlay4GameState(type: .matchOver)
            
//            self.game.overlayManager.matchOver.showMatchOver(lost: false)
//            self.game.scnView.overlaySKScene = self.game.overlayManager.matchOver.sceneNode
//            self.game.overlayManager.matchOver.showMatchOver(lost: self.lost)
//            
//            // TODO: START - FIX REMOVE ALL PELLETS AND GROUP AFTER HIT TARGET ETC ....
//            for shotgunPelletGrp in (self.game.playerEntityManager.getOwnPlayerEntity().weapons.getWeapon(weaponType: .shotgun) as! ShotgunComponent).firedShots{
//                for pellet in shotgunPelletGrp.pellets {
//                    pellet.removeFromParentNode()
//                }
//                shotgunPelletGrp.removeFromParentNode()
//            }
//            (self.game.playerEntityManager.getOwnPlayerEntity().weapons.getWeapon(weaponType: .shotgun) as! ShotgunComponent).firedShots.removeAll()
            
            // TODO: END - FIX REMOVE ALL PELLETS AND GROUP AFTER HIT TARGET ETC ....
        }
    }
}
