//
//  MachinegunBullet.swift
//  Suake3D
//
//  Created by Kim David Hauser on 28.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class MachinegunBullet: BulletBase {
    
    var rescale:CGFloat = 2.0
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    init(game: GameController, weapon:MachinegunComponent) {
        super.init(game: game, weapon: weapon, sceneName: "art.scnassets/nodes/weapons/mg/MachinegunBulllet.scn", scale: SCNVector3(2, 2, 2), nodeName: "BulletObject")
        self.name = "MachinegunBullet"
        
        self.shootingVelocity = 485.0
        self.setupPhysics()
    }
    
    func setupPhysics(){
        self.rescale = 2.0
        self.damage = SuakeVars.MACHINEGUN_DAMAGE
        
        self.scale.x = rescale
        self.scale.y = rescale
        self.scale.z = rescale
        
        let box = SCNBox(width: self.rescale, height: self.rescale, length: self.rescale, chamferRadius: 0)
        
        self.setupPhysics(geometry: box, type: .dynamic, categoryBitMask: CollisionCategory.mgbullet, catBitMasks: [CollisionCategory.suake, CollisionCategory.suakeOpp, CollisionCategory.goody, CollisionCategory.droid, CollisionCategory.medKit, CollisionCategory.portal, CollisionCategory.wall, CollisionCategory.floor, CollisionCategory.container])
        
    }
    
    override func hitTarget(targetCat: CollisionCategory, targetNode: SCNNode, contact: SCNPhysicsContact, overrideIsTargetHit: Bool = false) -> Bool {
        let bRet:Bool = super.hitTarget(targetCat: targetCat, targetNode: targetNode, contact: contact, overrideIsTargetHit: overrideIsTargetHit)
        
        if(bRet){
            let explosionCompoenent:BulletImpactExplodingComponent = BulletImpactExplodingComponent(game: self.game)
            explosionCompoenent.explode(position: contact.contactPoint)
        }
        
        return bRet
    }
    
    override func hitTarget(targetCat: CollisionCategory, targetNode: SCNNode, contact: SCNPhysicsContact) -> Bool {
        let bRet:Bool = super.hitTarget(targetCat: targetCat, targetNode: targetNode, contact: contact)
        
        if(bRet){
            print("PenetrationDistance: \(contact.penetrationDistance)")
            let explosionCompoenent:BulletImpactExplodingComponent = BulletImpactExplodingComponent(game: self.game)
            var impactPos:SCNVector3 = contact.contactPoint
            print("ContactNormal: \(contact.contactNormal)")
            impactPos.z -= (contact.penetrationDistance * contact.contactNormal.z)
            impactPos.x -= (contact.penetrationDistance * contact.contactNormal.x)
            explosionCompoenent.explode(position: impactPos)
        }
        
        return bRet
    }
    
    override func getNewBullet()->MachinegunBullet{
        return MachinegunBullet(game: self.game, weapon: self.weapon as! MachinegunComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
