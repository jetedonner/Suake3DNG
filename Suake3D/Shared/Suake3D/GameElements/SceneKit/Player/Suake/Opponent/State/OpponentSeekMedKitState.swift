//
//  OpponentSeekGoodyState.swift
//  Suake3D
//
//  Created by Kim David Hauser on 16.02.21.
//  Copyright © 2021 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit

class OpponentSeekMedKitState: OpponentMoveTowardState {
    
    init(game: GameController, entity: SuakeOppPlayerEntity) {
        super.init(game: game, entity: entity, targetEntity: nil, stateDesc: "SeekMedKitState")
    }
    
    override func didEnter(from previousState: GKState?) {
        self.entity.modeChanged2SeekMedKitAndNotLoaded = true
        super.didEnter(from: previousState)
        self.game.showDbgMsg(dbgMsg: "Entered (Seek MEDKIT-MODE) OpponentSeekMedKitState", dbgLevel: .InfoOnlyConsole)
        self.entity.lightComponent.light.color = NSColor.blue
        self.gotoNextMedKit()
        self.entity.modeChanged2SeekMedKitAndNotLoaded = false
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    }
    
    func gotoNextMedKit(){
        if(!DbgVars.startLoad_MediPacks){
            return
        }
//        self.game.showDbgMsg(dbgMsg: "Opp going 2 next MEDKIT", dbgLevel: .InfoOnlyConsole)

        self.reloadGridGraphNG(nextPos: self.entity.pos)
        var closestMedKit:MedKitEntity = self.game.medKits.itemEntityManager.medKitEntities[0]

        if let gg = self.entity.followComponent.gridHelper.gridGraph{
            var length:CGFloat = self.getCost(from: self.entity.pos, to: closestMedKit.pos, gridGraph: gg)
            for medKit in self.game.medKits.itemEntityManager.medKitEntities{
                let newDist = self.getCost(from: self.entity.pos, to: medKit.pos, gridGraph: gg)
                if(newDist < length){
                    closestMedKit = medKit
                    length = newDist
                }
            }
        }
        self.targetEntity = closestMedKit
        self.loadPath2Target(nextPos: self.entity.nextPosNG)
    }
}
