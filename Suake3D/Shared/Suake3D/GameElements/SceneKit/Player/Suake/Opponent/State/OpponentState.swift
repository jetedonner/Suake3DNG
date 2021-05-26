//
//  OpponentState.swift
//  Suake3D
//
//  Created by Kim David Hauser on 16.02.21.
//  Copyright © 2021 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit

class OpponentState: SuakeBaseState {
    
//    override var entity: SuakeOppPlayerEntity{
//        get{
//            return self._entity as! SuakeOppPlayerEntity
//        }
//    }
    
    let _entity:SuakeOppPlayerEntity
    var entity:SuakeOppPlayerEntity{
//        set{ self._entity = newValue }
        get{
            return self._entity
        }
    }
    
    init(game: GameController, entity: SuakeOppPlayerEntity, stateDesc: String) {
        self._entity = entity
        super.init(game: game, stateDesc: stateDesc)
    }
}
