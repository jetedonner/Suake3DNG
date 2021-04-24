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
import NetTestFW

class RailgunComponent: BaseWeaponComponent {
    
    init(game:GameController, weaponArsenalManager:WeaponArsenalManager) {
        super.init(game: game, weaponType: .railgun, weaponArsenalManager:weaponArsenalManager)
//        self.cadence = 1.25
        self.clipSize = SuakeVars.INITIAL_RAILGUN_CLIPSIZE
        self.ammoCount = SuakeVars.INITIAL_RAILGUN_AMMOCOUNT
        self.cadence = SuakeVars.INITIAL_RAILGUN_CADENCE
    }
    
    
//    override func fireShotNG(atNode:SCNVector3){
//        super.fireShotNG(atNode: atNode)
//        let beam:RailgunBeam = RailgunBeam(game: self.game, weapon: self)
//        beam.addRailgunShot()
//        self.game.physicsHelper.qeueNode2Add2Scene(node: beam)
//    }
    
    
    override func fireShot(at:SCNVector3? = nil, velocity:Bool = false){
        super.fireShot(at: at, velocity: velocity)
        let beam:RailgunBeam = RailgunBeam(game: self.game, weapon: self)
        beam.addRailgunShot()
        self.game.physicsHelper.qeueNode2Add2Scene(node: beam)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
