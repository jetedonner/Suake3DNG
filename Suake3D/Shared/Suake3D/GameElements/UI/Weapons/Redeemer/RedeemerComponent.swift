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

class RedeemerComponent: BaseWeaponComponent {
    
    var nukes:[Nuke] = [Nuke]()
    public var nukeFlying:Bool = false
    
    init(game:GameController, weaponArsenalManager:WeaponArsenalManager) {
        super.init(game: game, weaponType: .redeemer, weaponArsenalManager: weaponArsenalManager)
        self.cadence = SuakeVars.INITIAL_REDEEMER_CADENCE
        
        //Tmp
        self.clipSize = SuakeVars.INITIAL_REDEEMER_CLIPSIZE
        self.ammoCount = SuakeVars.INITIAL_REDEEMER_AMMOCOUNT
    }
    
    override func shoot(at: SCNVector3? = nil, velocity: Bool = false) {
        if(self.nukeFlying){
            if(self.nukes.count > 0){
                self.nukes.first?.explodeNuke()
                self.nukes.remove(at: 0)
            }
        }else{
            super.shoot(at: at, velocity: velocity)
        }
    }
    
    override func fireShot(at: SCNVector3? = nil, velocity: Bool = false) {
        super.fireShot(at: at, velocity: velocity)
        self.nukeFlying = true
        let nuke:Nuke = Nuke(game: self.game, weapon: self)
        nuke.position = self.getShotStartPosition()
        nuke.rotation = self.getShotStartRotation()
        //nuke.physicsBody?.velocity = self.getShotStartVelocity(bulletNode: nuke)
        nukes.append(nuke)
        self.game.physicsHelper.qeueNode2Add2Scene(node: nuke)
        
//        self.game.overlayManager.hud.overlayScene.crosshairEntity.redeemerCrosshairComponent.showRocketView(show: true, nuke: nuke)
        nuke.moveInZaxis()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
