//
//  DroidStatePatroling.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.03.21.
//

import Foundation
import GameplayKit

class DroidStatePatroling: SuakeBaseDroidState {
    
    init(game: GameController, droidEntity:DroidEntity) {
        super.init(game: game, droidEntity: droidEntity, stateDesc: "Droid-state patroling")
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == DroidStateChasing.self
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        self.droidEntity.droidComponent.changeDroidState(state: .Patroling)
    }
}
