//
//  SuakeOpponentStateMachine.swift
//  Suake3D
//
//  Created by Kim David Hauser on 26.05.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class SuakeOpponentStateMachine: GKStateMachine {
    
    let game:GameController
    let seekGoodyState:OpponentSeekGoodyState
    var opponentMode:OpponentMode = .SeekGoody
    
    init(game:GameController, entity:SuakeOppPlayerEntity) {
        self.game = game
        self.seekGoodyState = OpponentSeekGoodyState(game: game, entity: entity)
        super.init(states: [self.seekGoodyState])
    }
    
    func enterState(state:OpponentState.Type){
        self.enter(state)
    }
}
