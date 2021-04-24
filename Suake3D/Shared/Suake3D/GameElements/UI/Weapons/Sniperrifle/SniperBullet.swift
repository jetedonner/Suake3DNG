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

class SniperBullet: BulletBase {
    
    var rescale:CGFloat = 2.0
    let shotParticleNode = SCNNode()
    let shotParticleNodeWhite = SCNNode()
    
    init(game: GameController, weapon:SniperrifleComponent) {
//        super.init(game: game, weapon: weapon, sceneName: "art.scnassets/nodes/weapons/sniperrifle/SniperBulllet.scn", scale: SCNVector3(2, 2, 2), animName: "")
        super.init(game: game, weapon: weapon, sceneName: "art.scnassets/nodes/weapons/mg/MachinegunBulllet.scn", scale: SCNVector3(2, 2, 2), nodeName: "BulletObject")
        self.name = "SniperBullet"
        self.shootingVelocity = 2485.0
        self.setupPhysics()
    }
    
    func setupPhysics(){
        self.rescale = 2.0
        self.damage = SuakeVars.SNIPERRIFLE_DAMAGE
        
        self.scale.x = rescale
        self.scale.y = rescale
        self.scale.z = rescale
        
        let shotParticleSystem = SCNParticleSystem(named: "ShotBurstRings", inDirectory: SuakeVars.DIR_PARTICLES)
        let shotParticleSystemWhite = SCNParticleSystem(named: "ShotBurstWhite", inDirectory: SuakeVars.DIR_PARTICLES)
        
        shotParticleNode.addParticleSystem(shotParticleSystem!)
        shotParticleNode.position = self.position
        shotParticleNode.name = "sniperShotParticle"
//        shotParticleNode.position.z -= self.boundingBox.max.z
        
        let sizeAnimation:CAKeyframeAnimation = CAKeyframeAnimation()
        sizeAnimation.values = [1.0, 2.0, 3.5, 5.0]
        
        let opacityAnimation:CAKeyframeAnimation = CAKeyframeAnimation()
        opacityAnimation.values = [1.0, 0.7, 0.3, 0.0]
        
        let sizeController = SCNParticlePropertyController(animation: sizeAnimation)
        let opatityController = SCNParticlePropertyController(animation: opacityAnimation)
        
        shotParticleSystem?.propertyControllers = [SCNParticleSystem.ParticleProperty.size: sizeController, SCNParticleSystem.ParticleProperty.opacity: opatityController]
//        self.name = "shotNode"
        self.addChildNode(shotParticleNode)
        
        shotParticleNodeWhite.addParticleSystem(shotParticleSystemWhite!)
        shotParticleNodeWhite.position = self.position
        shotParticleNodeWhite.name = "shotParticleWhite"
//        shotParticleNodeWhite.position.z -= self.boundingBox.max.z
        self.addChildNode(shotParticleNodeWhite)
        
        //let sphere = SCNSphere(radius: self.rescale)
        let box = SCNBox(width: self.rescale, height: self.rescale, length: self.rescale, chamferRadius: 0)
        
        self.setupPhysics(geometry: box, type: .dynamic, categoryBitMask: CollisionCategory.sniperRifleBullet, catBitMasks: [CollisionCategory.suake, CollisionCategory.suakeOpp, CollisionCategory.goody, CollisionCategory.droid, CollisionCategory.medKit, CollisionCategory.wall, CollisionCategory.floor])
        //self.physicsBody?.continuousCollisionDetectionThreshold = 0.1
    }
    
    
    override func hitTarget(targetCat:CollisionCategory, targetNode:SCNNode, contactPoint:SCNVector3? = nil)->Bool{
        return super.hitTarget(targetCat: targetCat, targetNode: targetNode, contactPoint: contactPoint)
//        if(!self.isTargetHit){
//            self.isTargetHit = true
//            //self.explodeRocket(targetNode: targetNode, removeTargetNode: false, pos: contactPoint)
//            _ = super.hitTarget(targetCat: targetCat, targetNode: targetNode, contactPoint: contactPoint)
//            return true
//            //return super.hitTarget(targetCat: targetCat, targetNode: targetNode, contactPoint: contactPoint)
//        }
//        return false
    }
    
    override func getNewBullet()->SniperBullet{
        return SniperBullet(game: self.game, weapon: self.weapon as! SniperrifleComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
