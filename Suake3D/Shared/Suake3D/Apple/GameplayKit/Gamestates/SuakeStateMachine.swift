//
//  SuakeStateMachine.swift
//  Suake3D
//
//  Created by Kim David Hauser on 21.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeStateMachine:GKStateMachine{
    
    let game:GameController
    let stateGameLoading:SuakeStateGameLoading
    let stateGameLoadingMulti:SuakeStateGameLoadingMulti
    let stateReadyToPlay:SuakeStateReadyToPlay
    let statePlaying:SuakeStatePlaying
    let statePaused:SuakeStatePaused
    let stateDied:SuakeStateDied
    let stateRespawn:SuakeStateRespawn
    let stateMatchOver:SuakeStateMatchOver
    let stateMainMenu:SuakeStateMainMenu
    
    let stateHelper:SuakeGameStateHelper
//    let stateTutorial:SuakeStateTutorial
//    let stateTutorialCompleted:SuakeStateTutorialCompleted
//    let stateSetupMain:SuakeStateMainSetup
//    let stateSetupDeveloper:SuakeStateDeveloperSetup
    
    var stateStack:[AnyClass] = [AnyClass]()
    
    init(game:GameController) {
        self.game = game
        
        self.stateGameLoading = SuakeStateGameLoading(game: game)
        self.stateGameLoadingMulti = SuakeStateGameLoadingMulti(game: game)
        self.stateReadyToPlay = SuakeStateReadyToPlay(game: game)
        self.statePlaying = SuakeStatePlaying(game: game)
        self.statePaused = SuakeStatePaused(game: game)
        self.stateDied = SuakeStateDied(game: game)
        self.stateRespawn = SuakeStateRespawn(game: game)
        self.stateMatchOver = SuakeStateMatchOver(game: game)
        self.stateMainMenu = SuakeStateMainMenu(game: game)
        
        self.stateHelper = SuakeGameStateHelper(game: game)
        
        super.init(states: [self.stateGameLoading, self.stateGameLoadingMulti, self.stateReadyToPlay, self.statePlaying, self.statePaused, self.stateDied, self.stateRespawn, self.stateMatchOver, self.stateMainMenu])
    }
    
    @discardableResult
    override func enter(_ stateClass: AnyClass) -> Bool {
        return self.enter(stateClass: stateClass, saveOldState: true)
    }
    
    @discardableResult
    func enter(stateClass: AnyClass, saveOldState:Bool = true) -> Bool {
//        if(self.currentState != nil && (self.currentState!.classForCoder as AnyClass).isEqual(to: stateClass)){
//            return false
//        }
        if(saveOldState && self.currentState != nil){
            self.stateStack.append(self.currentState!.classForCoder)
        }else if(!saveOldState){
            self.stateStack.removeAll()
        }
        let bRet:Bool = super.enter(stateClass)
        if(self.currentState != nil){
            self.game.showDbgMsg(dbgMsg: "SuakeStateMachine entered: \((self.currentState as! SuakeBaseState).stateDesc)", dbgLevel: .Info)
        }
        return bRet
    }
    
    @discardableResult
    func returnToOldState(saveOldState:Bool = true)->Bool{
        if(self.stateStack.count > 0){
            return self.enter(stateClass: self.stateStack.popLast()!, saveOldState: saveOldState)
        }
        return false
    }
}
