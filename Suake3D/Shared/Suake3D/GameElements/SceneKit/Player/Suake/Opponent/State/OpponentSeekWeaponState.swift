//
//  OpponentSeekGoodyState.swift
//  Suake3D
//
//  Created by Kim David Hauser on 16.02.21.
//  Copyright © 2021 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit

class OpponentSeekWeaponState: OpponentMoveTowardState {
    
    init(game: GameController, entity: SuakeOppPlayerEntity) {
        super.init(game: game, entity: entity, targetEntity: nil, stateDesc: "SeekWeaponState")
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        self.entity.lightComponent.light.color = NSColor.purple
    }
    
    func gotoNextWeapon(weaponType:WeaponType? = nil){
        self.game.showDbgMsg(dbgMsg: "Opp going 2 next Weapon \(String(describing: weaponType?.rawValue))", dbgLevel: .InfoOnlyConsole)
        self.loadPath2NearestWeapon(weaponType: weaponType)
    }
    
    func loadPath2NearestWeapon(weaponType:WeaponType? = nil, doNotRemoveFirst:Bool = false, nextPos:SCNVector3? = nil){
        if(!DbgVars.startLoad_Weapons){
            return
        }
        
//        guard let oppEntity = self.entity as? SuakeOppPlayerEntity else {
//            return
//        }
//        oppEntity.followComponent.gridHelper.loadGridGraph()
        
        var closestWeaponPickup:BaseWeaponPickupEntity = self.game.weaponPickups.allPickupEntities[0][0]
        var length:CGFloat = abs(self.entity.pos.distance(to: closestWeaponPickup.pos))
        
        for weaponPickupType in self.game.weaponPickups.allPickupEntities{
            if(weaponType != nil && weaponType != weaponPickupType[0].weaponType){
                continue
            }
            for weaponPickup in weaponPickupType{
                let newDist:CGFloat = abs(self.entity.pos.distance(to: weaponPickup.pos))
                if(newDist < length){
                    closestWeaponPickup = weaponPickup
                    length = newDist
                }
            }
        }
        
        self.game.showDbgMsg(dbgMsg: "Closest medKit is: \(closestWeaponPickup.pos)", dbgLevel: .InfoOnlyConsole)
        
        let vectPos2remove:[SCNVector3] = PositionHelper.getPos4DirNPosition(dir: self.entity.dir, relPos: [.One80, .Left, .Right], curPos: self.entity.pos) // self.getBackLeftRightPos()
        for vectPos in vectPos2remove {
            self.entity.followComponent.removeConnection(from: self.entity.pos, to: vectPos)
        }
        
        self.entity.followComponent.loadPath(toEntity: closestWeaponPickup, afterGoodyHit: false, doNotRemoveFirst: doNotRemoveFirst, nextPos: nextPos)
        
        for vectPos in vectPos2remove {
            self.entity.followComponent.gridHelper.addConnection(from: self.entity.pos, to: vectPos)
        }
    }
    
}
