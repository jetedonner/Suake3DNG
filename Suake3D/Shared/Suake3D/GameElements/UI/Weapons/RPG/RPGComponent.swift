//
//  RPGComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 16.04.21.
//

import Foundation
import GameplayKit
import SceneKit
import NetTestFW

class RPGComponent: BaseWeaponComponent {
 
    init(game:GameController, weaponArsenalManager:WeaponArsenalManager) {
        super.init(game: game, weaponType: .rpg, weaponArsenalManager: weaponArsenalManager)
        self.cadence = SuakeVars.INITIAL_RPG_CADENCE
        self.clipSize = SuakeVars.INITIAL_RPG_CLIPSIZE
        self.ammoCount = SuakeVars.INITIAL_RPG_AMMOCOUNT
    }
    
    override func fireShot(at:SCNVector3? = nil, velocity:Bool = false){
        super.fireShot(at: at, velocity: velocity)
        let shot:RPGRocket = RPGRocket(game: self.game, weapon: self)
        shot.position = self.getShotStartPosition()
        shot.rotation = self.getShotStartRotation()
        let velocity:SCNVector3 = self.getShotStartVelocity(bulletNode: shot, target: at)
        shot.physicsBody?.velocity = velocity
        self.game.physicsHelper.qeueNode2Add2Scene(node: shot)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
