//
//  OpponentSeekGoodyState.swift
//  Suake3D
//
//  Created by Kim David Hauser on 16.02.21.
//  Copyright © 2021 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit

class OpponentSeekGoodyState: OpponentMoveTowardState {
    
    init(game: GameController, entity: SuakeOppPlayerEntity) {
        super.init(game: game, entity: entity, targetEntity: game.playerEntityManager.goodyEntity, stateDesc: "SeekGoodyState")
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        self.game.showDbgMsg(dbgMsg: "Entered (Seek GOODY-MODE) OpponentSeekMedKitState", dbgLevel: .InfoOnlyConsole)
//        self.entity.lightComponent.light.color = NSColor.green
//        self.loadPath2Target(nextPos: self.entity.nextPosNG)
        self.loadPath2Target(nextPos: self.entity.moveComponent.nextPos)
    }
}
