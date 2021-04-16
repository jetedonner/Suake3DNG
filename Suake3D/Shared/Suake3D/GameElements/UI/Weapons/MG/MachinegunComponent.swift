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

class MachinegunComponent: BaseWeaponComponent {
    
    init(game:GameController, weaponArsenalManager:WeaponArsenalManager) {
        super.init(game: game, weaponType: .mg, weaponArsenalManager: weaponArsenalManager)
        self.cadence = SuakeVars.INITIAL_MACHINEGUN_CADENCE
        self.clipSize = SuakeVars.INITIAL_MACHINEGUN_CLIPSIZE
        self.ammoCount = SuakeVars.INITIAL_MACHINEGUN_AMMOCOUNT
    }

    override func fireShot(at:SCNVector3? = nil){
        super.fireShot(at: at)
        let shot:MachinegunBullet = MachinegunBullet(game: self.game, weapon: self)
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
