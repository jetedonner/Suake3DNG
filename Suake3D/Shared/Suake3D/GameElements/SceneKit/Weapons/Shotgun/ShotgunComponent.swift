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

class ShotgunComponent: BaseWeaponComponent {
    
    init(game:GameController, weaponArsenalManager:WeaponArsenalManager) {
        super.init(game: game, weaponType: .shotgun, weaponArsenalManager: weaponArsenalManager)
//        self.cadence = 0.75

        //Tmp
        self.clipSize = SuakeVars.INITIAL_SHOTGUN_CLIPSIZE
        self.ammoCount = SuakeVars.INITIAL_SHOTGUN_AMMOCOUNT
        self.cadence = SuakeVars.INITIAL_SHOTGUN_CADENCE
    }
    var shot:ShotgunPelletGrp!
    
//    override func fireShotNG(atNode:SCNVector3){
//        super.fireShotNG(atNode: atNode)
////        let shot:MachinegunBullet = self.origBaseShot.clone()
//        let newShot:ShotgunPelletGrp = ShotgunPelletGrp(game: self.game, weapon: self)
//        newShot.setAfterInit(game: self.game, weapon: self)
//        newShot.position = self.getShotStartPosition()
//        let velocity23 = self.getShotStartVelocityNG2(projectile: newShot, target: atNode, angle: Float(0.4))
////        print("velocity23: \(velocity23)")
//        for pellet in newShot.pellets{
//            pellet.physicsBody?.velocity = (velocity23 * Float(newShot.shootingVelocity))
//        }
//        newShot.rotation = self.getShotStartRotation()
//        self.firedShots.append(newShot)
//        self.game.physicsHelper.qeueNode2Add2Scene(node: newShot)
////        shot.rotation = self.getShotStartRotation()
////        shot.physicsBody?.velocity = (velocity23 * Float(shot.shootingVelocity))
////        self.game.physicsHelper.qeueNode2Add2Scene(node: shot)
//    }
    
    var firedShots:[ShotgunPelletGrp] = [ShotgunPelletGrp]()
    override func fireShot(at:SCNVector3? = nil, velocity:Bool = false){
        super.fireShot(at: at, velocity: velocity)
        let newShot:ShotgunPelletGrp = ShotgunPelletGrp(game: self.game, weapon: self)
        //let newShot:ShotgunPelletGrp = shot.flattenedClone()
//        newShot.game = self.game
//        newShot.weapon = shot.weapon
        let velocity:SCNVector3 = self.getShotStartVelocity(bulletNode: newShot)
        newShot.position = self.getShotStartPosition()
        for pellet in newShot.pellets{
            pellet.physicsBody?.velocity = velocity
        }
        newShot.rotation = self.getShotStartRotation()
        self.firedShots.append(newShot)
        self.game.physicsHelper.qeueNode2Add2Scene(node: newShot)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//
//  MachineGunComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 27.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

//import Foundation
//import GameplayKit
//import SceneKit
//
//class ShotgunComponent: BaseWeaponComponent {
//
//    var origBaseShot:ShotgunPelletGrp!
//
//    init(game:GameController, weaponArsenalManager:WeaponArsenalManager) {
//        super.init(game: game, weaponType: .shotgun, weaponArsenalManager: weaponArsenalManager)
//        self.cadence = 0.75
//        self.origBaseShot = ShotgunPelletGrp(game: self.game, weapon: self)
//        //Tmp
//        self.clipSize = SuakeVars.INITIAL_SHOTGUN_CLIPSIZE
//        self.ammoCount = SuakeVars.INITIAL_SHOTGUN_AMMOCOUNT
//    }
////    var shot:ShotgunPelletGrp!
//
////    func prepareBullets(){
////        self.shot = ShotgunPelletGrp(game: self.game, weapon: self)
////        self.game.scnView.prepare([shot], completionHandler: { success in
////            print("Preparation of SHOTGUN PELLET GROUP completed (" + success.description + ")")
////        })
////    }
//    var firedShots:[ShotgunPelletGrp] = [ShotgunPelletGrp]()
//    override func fireShot(at:SCNVector3? = nil){
//        super.fireShot(at: at)
//        let newShot:ShotgunPelletGrp = self.origBaseShot.clone()
//        newShot.setAfterInit(game: self.game, weapon: self)
////        let newShot:ShotgunPelletGrp = ShotgunPelletGrp(game: self.game, weapon: self)
//        //let newShot:ShotgunPelletGrp = shot.flattenedClone()
////        newShot.game = self.game
////        newShot.weapon = shot.weapon
//        let velocity:SCNVector3 = self.getShotStartVelocity(bulletNode: newShot)
//        newShot.position = self.getShotStartPosition()
//        for pellet in newShot.pellets{
//            pellet.setupPhysics4Pellet()
//            pellet.physicsBody?.velocity = velocity
//        }
//        newShot.rotation = self.getShotStartRotation()
//        self.firedShots.append(newShot)
//        self.game.physicsHelper.qeueNode2Add2Scene(node: newShot)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
