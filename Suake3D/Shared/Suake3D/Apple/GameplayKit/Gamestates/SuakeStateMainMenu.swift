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

class SuakeStateMainMenu: SuakeBaseState {
    
    init(game: GameController) {
        super.init(game: game, stateDesc: GameStates.mainMenuState)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == SuakeStatePlaying.self || stateClass == SuakeStateReadyToPlay.self /*|| stateClass == SuakeStateMainSetup.self || stateClass == SuakeStateDeveloperSetup.self*/)
    }
    
    override func willExit(to nextState: GKState) {
        if(nextState is SuakeStatePlaying || nextState is SuakeStateReadyToPlay /*|| nextState is SuakeStateTutorial || nextState is SuakeStateMainSetup || nextState is SuakeStateDeveloperSetup*/){
            self.game.overlayManager.mainMenu.showMenu(show: false)
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        if(/*previousState is SuakeStateDeveloperSetup ||*/
            previousState is SuakeStatePlaying ||
            previousState is SuakeStateReadyToPlay /*||
            previousState is SuakeStateMainSetup*/){
//            self.game.pauseMatch()
            self.game.overlayManager.showOverlay4GameState(type: .menu)
//            self.game.overlayManager.mainMenu.showMenu()
//            self.game.scnView.overlaySKScene = self.game.overlayManager.mainMenu.sceneNode
        }
    }
}
