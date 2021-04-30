//
//  DroidStatePatroling.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.03.21.
//

import Foundation
import GameplayKit

class DroidStateAttacking: SuakeBaseDroidState {
    
    init(game: GameController, droidEntity:DroidEntity) {
        super.init(game: game, droidEntity: droidEntity, stateDesc: "Droid-state attacking")
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        if let droidComponent = self.droidEntity.component(ofType: DroidComponent.self){
            (droidComponent.node as! SuakeBaseMultiAnimatedSCNNode).getAnimPlayer()!.stop()
            self.droidEntity.droidComponent.changeDroidState(state: .Attacking)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        self.droidEntity.attackComponent.shootLaser(suake: self.droidEntity.targetEntity)
    }
}
