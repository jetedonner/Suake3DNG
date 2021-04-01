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

class SuakeStateDied: SuakeBaseState {
    
    init(game: GameController) {
        super.init(game: game, stateDesc: GameStates.diedState)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == SuakeStatePlaying.self || stateClass == SuakeStateReadyToPlay.self || stateClass == SuakeStateRespawn.self /*|| stateClass == SuakeStateMainMenu.self*/)
    }
    
    override func didEnter(from previousState: GKState?) {
        if(previousState is SuakeStatePlaying){
            self.game.soundManager.playSound(soundType: .pain_25)
            self.game.playerEntityManager.ownPlayerEntity.fadeHelper.showDeathFadeOut(playerType: .OwnSuake, completion: {
                self.game.playerEntityManager.ownPlayerEntity.fadeHelper.hideFadeOut()
                self.game.stateMachine.enter(SuakeStateRespawn.self)
            })
        }
    }
}
