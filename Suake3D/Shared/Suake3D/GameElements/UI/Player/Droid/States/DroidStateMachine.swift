//
//  DroidStateMachine.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.03.21.
//

import Foundation
import SceneKit
import SpriteKit
import GameplayKit

class DroidStateMachine:GKStateMachine{
 
    let game:GameController
    let statePatroling:DroidStatePatroling
    let stateChasing:DroidStateChasing
    let stateAttacking:DroidStateAttacking
    
    init(game:GameController, droidEntity:DroidEntity) {
        self.game = game
        self.statePatroling = DroidStatePatroling(game: game, droidEntity: droidEntity)
        self.stateChasing = DroidStateChasing(game: game, droidEntity: droidEntity)
        self.stateAttacking = DroidStateAttacking(game: game, droidEntity: droidEntity)
        super.init(states: [self.statePatroling, self.stateChasing, self.stateAttacking])
    }
    
}
    
