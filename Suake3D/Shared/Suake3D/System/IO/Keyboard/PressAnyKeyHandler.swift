//
//  PressAnyKeyHandler.swift
//  Suake3D
//
//  Created by Kim David Hauser on 11.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class PressAnyKeyHandler:SuakeGameClass{
    
    override init(game:GameController){
        super.init(game: game)
    }
    
    func handleAnyKeyPress(pressedKey:KeyboardDirection)->Bool{
        if(self.game.stateMachine.currentState is SuakeStatePaused){
            return self.game.stateMachine.returnToOldState()
        }else if(self.game.stateMachine.currentState is SuakeStateMatchOver){
            if(self.game.overlayManager.matchOver.isLoaded){
//                return self.game.stateMachine.enter(stateClass: SuakeStateReadyToPlay.self, saveOldState: false)
                self.game.overlayManager.matchOver.isLoaded = false
                self.game.overlayManager.showOverlay4GameState(type: .matchResult)
            }else if(self.game.overlayManager.matchResults.isLoaded){
                self.game.overlayManager.matchResults.unloadView()
                return self.game.stateMachine.enter(stateClass: SuakeStateReadyToPlay.self, saveOldState: false)
            }
//            if(!self.game.stateMachine.stateMatchOver.resultsShowIng){
//                if(self.game.overlayManager.matchOver.loaded){
//                    self.game.overlayManager.matchOver.loaded = false
//                    self.game.stateMachine.stateMatchOver.resultsShowIng = true
//                    self.game.overlayManager.showOverlay4GameState(type: .matchResults)
//                }else{
//                    return true
//                }
//            }else{
//                if(self.game.overlayManager.matchResults.loaded){
//                    self.game.stateMachine.stateMatchOver.resultsShowIng = false
//                    self.game.overlayManager.matchResults.customView.closeResultsView()
            
//                }
//            }
//            return true
        }
        //else if(self.game.stateMachine.currentState is SuakeStateTutorial){
//            self.game.overlayManager.tutorialOverlay.startTutorial()
//            return true
//        }else if(self.game.stateMachine.currentState is SuakeStateTutorialCompleted){
//            self.game.overlayManager.tutorialCompletedOverlay.finishTutorialStep()
//            return true
//        }
        return false
    }
}
