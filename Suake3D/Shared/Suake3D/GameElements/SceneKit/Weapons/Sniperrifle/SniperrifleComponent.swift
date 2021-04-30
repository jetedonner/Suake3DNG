//
//  MachineGunComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 27.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class SniperrifleComponent: BaseWeaponComponent {
    
    init(game:GameController, weaponArsenalManager:WeaponArsenalManager) {
        super.init(game: game, weaponType: .sniperrifle, weaponArsenalManager: weaponArsenalManager)
        self.cadence = SuakeVars.INITIAL_SNIPERRIFLE_CADENCE
        self.clipSize = SuakeVars.INITIAL_SNIPERRIFLE_CLIPSIZE
        self.ammoCount = SuakeVars.INITIAL_SNIPERRIFLE_AMMOCOUNT
    }
    
    override func fireShot(at:SCNVector3? = nil, velocity:Bool = false){
        super.fireShot(at: at, velocity: velocity)
        let shot:SniperBullet = SniperBullet(game: self.game, weapon: self)
        let velocity:SCNVector3 = self.getShotStartVelocity(bulletNode: shot)
        shot.position = self.getShotStartPosition()
        shot.rotation = self.getShotStartRotation()
        shot.physicsBody?.velocity = velocity

        self.game.physicsHelper.qeueNode2Add2Scene(node: shot)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
