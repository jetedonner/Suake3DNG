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

class SuakeStateMultiplayerPlaying: SuakeBaseState {
    
//    var dbgOpponentAi:Bool = false
//    var dbgOpponentAi2MedKit:Bool = false
//    var dbgDroidAi:Bool = false
    
    init(game: GameController) {
        super.init(game: game, stateDesc: GameStates.multiplayerPlayingState)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == SuakeStateReadyToPlay.self || stateClass == SuakeStatePaused.self || stateClass == SuakeStateMatchOver.self || stateClass == SuakeStateMainMenu.self || stateClass == SuakeStateGameLoading.self || stateClass == SuakeStateDied.self || stateClass == SuakeStateGameLoadingMulti.self)
    }
    
    override func didEnter(from previousState: GKState?) {
        if(previousState is SuakeStateGameLoadingMulti){
            self.game.soundManager.playSoundQuake(soundType: .play)
            self.game.overlayManager.hud.msgComponent.showMsgFadeAndScale2Big(msg: "PLAY!")
            self.game.playerEntityManager.isPaused = false
//            self.game.physicsHelper.firstMove = true
            self.game.physicsHelper.lastUpdateTime = nil // self.game.physicsHelper.currentTime
            self.game.playerEntityManager.ownPlayerEntity.moveComponent.nextMove(deltaTime: 0.0)
            self.game.overlayManager.hud.overlayScene!.map.movePlayerNodes()
            self.game.overlayManager.showOverlay4GameState(type: .playing)
        }
//        if(previousState is SuakeStateReadyToPlay || previousState is SuakeStateDied){
////            self.game.playerEntityManager.ownPlayerEntity.suakePlayerComponent.startAnimationTMP()
////            self.game.playerEntityManager.ownPlayerEntity.moveComponent.update(deltaTime: 1.0)
//            if(self.game.usrDefHlpr.testOppAI){
//                self.game.playerEntityManager.oppPlayerEntity.moveComponent.nextMove(deltaTime: 0.0)
//            }else{
//                self.game.soundManager.playSoundQuake(soundType: .play)
//                self.game.overlayManager.hud.msgComponent.showMsgFadeAndScale2Big(msg: "PLAY!")
//                self.game.playerEntityManager.isPaused = false
//    //            self.game.physicsHelper.firstMove = true
//                self.game.physicsHelper.lastUpdateTime = nil // self.game.physicsHelper.currentTime
//                self.game.playerEntityManager.ownPlayerEntity.moveComponent.nextMove(deltaTime: 0.0)
//                self.game.overlayManager.hud.overlayScene!.map.movePlayerNodes()
//            }
//        }else if(previousState is SuakeStateRespawn){
//            self.game.soundManager.playSoundQuake(soundType: .play)
//            self.game.overlayManager.hud.msgComponent.showMsgFadeAndScale2Big(msg: "PLAY!")
//            self.game.playerEntityManager.isPaused = false
//        }else if(previousState is SuakeStatePaused){
//            self.game.playerEntityManager.isPaused = false
//            self.game.scene.isPaused = false
//            self.game.scnView.isPlaying = true
//        }
//        self.game.overlayManager.showOverlay4GameState(type: .playing)
    }
}
