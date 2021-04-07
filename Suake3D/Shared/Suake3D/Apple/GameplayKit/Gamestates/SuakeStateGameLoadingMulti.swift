//
//  SuakeStateGameLoading.swift
//  Suake3D
//
//  Created by Kim David Hauser on 21.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeStateGameLoadingMulti:SuakeBaseState{
    
    init(game: GameController) {
        super.init(game: game, stateDesc: GameStates.gameLoadingMultiState)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true// stateClass == SuakeStateReadyToPlay.self
    }
    
    override func didEnter(from previousState: GKState?) {
//        if(previousState is SuakeStatePlaying || previousState is SuakeStateMatchOver /*|| previousState is SuakeStateTutorialCompleted*/){
//            self.game.overlayManager.showOverlay4GameState(type: .loading)
//            self.game.overlayManager.gameLoading.initProgressLoop()
//            self.game.loadGameScence()
//        }
        self.game.overlayManager.showOverlay4GameState(type: .gameCenter)
    }
}
