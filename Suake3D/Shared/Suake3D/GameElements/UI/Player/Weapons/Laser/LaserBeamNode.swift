//
//  LaserBeamNode.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class LaserBeamNode: BulletBase {
    
    let droidEntity:DroidEntity
    
    init(game: GameController, droidEntity:DroidEntity, to:SCNVector3, weaponArsenalManager:WeaponArsenalManager) {
        self.droidEntity = droidEntity
        super.init(game: game, weapon: LasergunComponent(game: game, weaponArsenalManager: weaponArsenalManager), sceneName: "art.scnassets/nodes/droid/LaserBeam.scn", scale: SCNVector3(1, 1, 1))
        
        self.damage = 5.0
        self.shootingVelocity = 180.0
        
        let from:SCNVector3 = droidEntity.position
        
        let shootingVect:SCNVector3 = to - from
        if(shootingVect.x == 0 && shootingVect.z == 0){
            return
        }
        self.position = from
        self.position.y = 14
        
        self.eulerAngles = SCNVector3Make(CGFloat(Float(Double.pi/2)), acos((to.z-from.z)/CGFloat(shootingVect.length())), atan2((to.y-from.y), (to.x-from.x) ))
        self.eulerAngles.x = 0.0
        
        let laserShotShape = SCNPhysicsShape(geometry: (self.cloneNode.flattenedClone().geometry!), options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: laserShotShape)
        self.physicsBody?.categoryBitMask = CollisionCategory.laserbeam.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.laserbeam.rawValue | CollisionCategory.suakeOpp.rawValue | CollisionCategory.suake.rawValue | CollisionCategory.floor.rawValue

        var newVect:SCNVector3 = SCNVector3(0, 0, 0)
        var multX:CGFloat = 1.0
        var multZ:CGFloat = 1.0
        if(shootingVect.x < 0){
           multX = -1.0
        }
        if(shootingVect.z < 0){
            multZ = -1.0
        }
        if(abs(shootingVect.x) > abs(shootingVect.z)){
            newVect.z = 1 * multZ
            if(abs(shootingVect.x) == 0 || (abs(shootingVect.z) / abs(shootingVect.x)) == 0){
                newVect.x = 0
            }else{
                newVect.x = 1 / (abs(shootingVect.z) / abs(shootingVect.x)) * multX
            }
        }else{
            newVect.x = 1 * multX
            if(abs(shootingVect.z) == 0 || (abs(shootingVect.x) / abs(shootingVect.z)) == 0){
                newVect.z = 0
            }else{
                newVect.z = 1 / (abs(shootingVect.x) / abs(shootingVect.z)) * multZ
            }
        }
        newVect.y = -12.0
        let defShootingVect:SCNVector3 = SCNVector3(newVect.x * self.shootingVelocity, 0, newVect.z * self.shootingVelocity)
        self.physicsBody?.velocity = defShootingVect
        self.physicsBody?.applyForce(defShootingVect, asImpulse: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
