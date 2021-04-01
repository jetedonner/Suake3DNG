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

class SuakeStateRespawn: SuakeBaseState {
    
    init(game: GameController) {
        super.init(game: game, stateDesc: GameStates.respawnState)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == SuakeStatePlaying.self || stateClass == SuakeStateReadyToPlay.self /*|| stateClass == SuakeStateMainMenu.self*/)
    }
    
    override func didEnter(from previousState: GKState?) {
        if(previousState is SuakeStateDied){
            self.game.overlayManager.showOverlay4GameState(type: .ready2Play)
            self.game.playerEntityManager.ownPlayerEntity.respawnComponent.respawnSuake(completion: {
                
            })
//            self.game.soundManager.playSound(soundType: .pain_25)
//            self.game.playerEntityManager.ownPlayerEntity.fadeHelper.showDeathFadeOut(playerType: .OwnSuake, completion: {
////                self.game.stateMachine.enter(SuakeStateReadyToPlay.self)
////                self.game.playerEntityManager.ownPlayerEntity.fadeHelper.hideFadeOut()
////                self.game.playerEntityManager.ownPlayerEntity.respawnComponent.respawnSuake()
//            })
        }
    }
}
