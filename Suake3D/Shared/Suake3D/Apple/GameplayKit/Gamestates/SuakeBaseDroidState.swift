//
//  SuakeBaseState.swift
//  Suake3D
//
//  Created by Kim David Hauser on 21.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeBaseDroidState:GKState{
    
    let game:GameController
    let droidEntity:DroidEntity
    let stateDesc:String
    
    init(game:GameController, droidEntity:DroidEntity, stateDesc:String) {
        self.game = game
        self.droidEntity = droidEntity
        self.stateDesc = stateDesc
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return super.isValidNextState(stateClass)
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    }
}
