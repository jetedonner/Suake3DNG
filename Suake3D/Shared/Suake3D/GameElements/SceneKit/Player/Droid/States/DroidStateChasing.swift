//
//  DroidStatePatroling.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.03.21.
//

import Foundation
import GameplayKit

class DroidStateChasing: SuakeBaseDroidState {
    
    init(game: GameController, droidEntity:DroidEntity) {
        super.init(game: game, droidEntity: droidEntity, stateDesc: "Droid-state chasing")
    }
    
    override func didEnter(from previousState: GKState?) {
        if(previousState is DroidStatePatroling || previousState is DroidStateAttacking){
            self.droidEntity.loadPath()
            self.droidEntity.droidComponent.changeDroidState(state: .Chasing)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        self.droidEntity.droidAIComponent.followPath()
    }
}
