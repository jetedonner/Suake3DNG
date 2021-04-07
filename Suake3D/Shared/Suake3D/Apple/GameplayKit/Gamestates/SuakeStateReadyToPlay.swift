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

class SuakeStateReadyToPlay: SuakeBaseState {
    
    init(game: GameController) {
        super.init(game: game, stateDesc: GameStates.readyToPlayState)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == SuakeStateMatchOver.self || stateClass == SuakeStateReadyToPlay.self || stateClass == SuakeStatePlaying.self || stateClass == SuakeStatePaused.self || stateClass == SuakeStateMainMenu.self || stateClass == SuakeStateGameLoadingMulti.self /*|| stateClass == SuakeStateTutorial.self || stateClass == SuakeStateCheatSheet.self*/)
    }
    
    override func didEnter(from previousState: GKState?) {
        if(previousState is SuakeStateReadyToPlay || previousState is SuakeStatePlaying || previousState is SuakeStateMainMenu || previousState is SuakeStateGameLoadingMulti || previousState is SuakeStateMatchOver /*|| previousState is SuakeStateTutorialCompleted*/){
            
            if(previousState is SuakeStateMatchOver){
                self.game.levelManager.loadLevel(initialLoad: false)
                self.game.playerEntityManager.resetPlayerEntities()
                self.game.cameraHelper.resetCameraView()

                for healthBar in self.game.overlayManager.hud.healthBars{
                    if(!healthBar.value.isHidden){
                        healthBar.value.drawHealthBar()
                        self.game.overlayManager.hud.overlayScene.reposHealthBar(healthBar: healthBar.value, entity: healthBar.key)
                    }
                }
                
//                self.game.overlayManager.hud.healthBarOwnComponent.drawHealthBar()
//                self.game.overlayManager.hud.healthBarGoodyComponent.drawHealthBar()
                
                self.game.overlayManager.hud.overlayScene!.map.reposNodeInit(playerType: .OwnSuake)
                self.game.overlayManager.hud.overlayScene!.arrows.initArrowPosition()
                self.game.physicsHelper.lastUpdateTime = nil
            }
            self.game.overlayManager.showOverlay4GameState(type: .ready2Play)
            return
        }else if(previousState is SuakeStateGameLoading || previousState is SuakeStateDied){
            self.game.overlayManager.showOverlay4GameState(type: .ready2Play)
        } /*else if(previousState is SuakeStateMainMenu){

        }else if(previousState is SuakeStateTutorial){

        }else if(previousState is SuakeStateTutorialCompleted){
        
        }
        self.game.overlayManager.showOverlay4GameState(type: .ready2Play)
        self.game.overlayManager.hud.updateNG(deltaTime: 0.0)
        
        self.game.overlayManager.hud.forceRedraw()
        self.game.overlayManager.hud.map.initMap()*/
        for healthBar in self.game.overlayManager.hud.healthBars{
            if(!healthBar.value.isHidden){
                healthBar.value.drawHealthBar()
                self.game.overlayManager.hud.overlayScene.reposHealthBar(healthBar: healthBar.value, entity: healthBar.key)
            }
        }
//        self.game.overlayManager.hud.healthBarOwnComponent.drawHealthBar()
        /*self.game.overlayManager.hud.drawHealthBarOpp()
        self.game.overlayManager.hud.hudEntity.updateHealthBarOppPos()
        
        
        self.game.overlayManager.hud.hudEntity.crosshairEntity.setCurrentWeaponType(weaponType: DbgVars.initialWeaponType)
        
        if(previousState is SuakeStateGameLoading && DbgVars.initialFPV){
            self.game.cameraHelper.toggleFPV(newFPV: true)
            //self.game.overlayManager.hud.hudEntity.crosshairEntity.redeemerCrosshairComponent.addSublayer(hud: self.game.overlayManager.hud)
        }else{
            if(DbgVars.startLoad_Opponent_Dbg_AI){
                self.game.cameraHelper.toggleFPVOpp(newFPV: false)
            }else{
                self.game.cameraHelper.toggleFPV(newFPV: false)
            }
        }
        
        if(previousState is SuakeStateGameLoading && DbgVars.showTutorialsAtStartup){
            _ = self.game.stateMachine.enter(SuakeStateTutorial.self)
        }
        self.game.playerEntityManager.isPaused = false
        self.game.isLoading = false*/
    }
}
