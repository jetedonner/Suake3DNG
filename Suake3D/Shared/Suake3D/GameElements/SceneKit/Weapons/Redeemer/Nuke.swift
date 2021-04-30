//
//  RPGRocket.swift
//  Suake3D
//
//  Created by Kim David Hauser on 06.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class Nuke: BulletBase {
    
    //let weapon:RedeemerComponent
    let nukeBlast:NukeBlast
    
    var rescale:CGFloat = 5.0
    let shotParticleNode = SCNNode()
    
    let cameraNode:SCNNode = SCNNode()
    override var camera:SCNCamera?{
        get{ return self.cameraNode.camera }
        set{ self.cameraNode.camera = newValue }
    }
    
    var isExploded:Bool = false
    
    init(game: GameController, weapon:RedeemerComponent) {
        //self.weapon = weapon
        self.nukeBlast = NukeBlast(game: game, weapon: weapon)
        super.init(game: game, weapon: weapon, sceneName: "art.scnassets/nodes/weapons/rpg/rocketlauncher_shell.scn", scale: SCNVector3(5, 5, 5))
//        super.init(game: game, weapon: weapon, sceneName: "art.scnassets/nodes/weapons/rpg/rocketlauncher_shell.scn", scale: SCNVector3(5, 5, 5), animName: "")
        self.name = "Redeemer nuke"
        self.shootingVelocity = 85.0
        self.loadRocket()
    }
    
    func loadRocket(){
        self.rescale = 23
        self.damage = SuakeVars.RPG_DAMAGE
        
        self.scale.x = self.rescale
        self.scale.y = self.rescale
        self.scale.z = self.rescale

        let shotParticleSystem = SCNParticleSystem(named: "ShotBurst", inDirectory: SuakeVars.DIR_PARTICLES)

        shotParticleNode.addParticleSystem(shotParticleSystem!)
        shotParticleNode.position = self.position
        shotParticleNode.name = "ShotParticle"
//        shotParticleNode.position.z -= self.boundingBox.max.z
        self.name = "NukeNode"
        self.addChildNode(shotParticleNode)
        
//        let box = SCNBox(width: (self.presentation.boundingBox.max.x), height: (self.presentation.boundingBox.max.y), length: (self.presentation.boundingBox.max.z), chamferRadius: 0)
        let box = SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0)
//        self.geometry = box
        
        self.cameraNode.camera = SCNCamera()
        //self.cameraNode.rotation.y = 0 //CGFloat.pi
        self.addChildNode(self.cameraNode)
        self.cameraNode.transform = SCNMatrix4MakeRotation(CGFloat(Double.pi), 0.0, 1.0, 0.0)
        self.cameraNode.position.y = 0.5
        
        self.setupPhysics(geometry: box, type: .dynamic, categoryBitMask: CollisionCategory.nuke, catBitMasks: [CollisionCategory.suake, CollisionCategory.suakeOpp, CollisionCategory.goody, CollisionCategory.droid, CollisionCategory.medKit, CollisionCategory.wall, CollisionCategory.floor])
        
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.damping = 0.0
    }
    
    //override func hitTarget(targetCat:CollisionCategory, targetNode:SCNNode, contactPoint:SCNVector3? = nil)->Bool{
    override func hitTarget(targetCat:CollisionCategory, targetNode:SCNNode, contact: SCNPhysicsContact)->Bool{
        if(!self.isTargetHit){
            self.isTargetHit = true
            //self.weapon.nukeFlying = false
            self.game.scnView.pointOfView = self.game.cameraHelper.cameraNode
            self.explodeRocket(targetNode: targetNode, removeTargetNode: false, pos: contact.contactPoint)
            return true
        }
        return false
    }
    
    let moveSpeedFactor:Float = 1.2
    
    func moveInZaxis() {
        let newDir:SIMD3<Float> = characterDirection(withPointOfView: self.cameraNode)
        let moveAction = SCNAction.customAction(duration: 0.1) { (node, elapsedTime) in
            node.simdPosition += simd_float3(x: newDir.x * -self.moveSpeedFactor, y: newDir.y, z: newDir.z * -self.moveSpeedFactor)
        }
        self.runAction(moveAction, forKey: "moveAction", completionHandler: {
            if true { // Configure your `Bool` to check whether to continue to move your node or not.
                self.moveInZaxis()
            }
        })
    }
    
    func characterDirection(withPointOfView pointOfView: SCNNode?) -> SIMD3<Float> {
        let controllerDir = SIMD2<Float>(x: 0, y: 1) // self.direction
        if controllerDir.allZero() {
            return SIMD3<Float>.zero
        }
        
        var directionWorld = SIMD3<Float>.zero
        if let pov = pointOfView {
            let p1 = pov.presentation.simdConvertPosition(SIMD3<Float>(controllerDir.x, 0.0, controllerDir.y), to: nil)
            let p0 = pov.presentation.simdConvertPosition(SIMD3<Float>.zero, to: nil)
            directionWorld = p1 - p0
            directionWorld.y = 0
            if simd_any(directionWorld != SIMD3<Float>.zero) {
                let minControllerSpeedFactor = Float(7.0)
                let maxControllerSpeedFactor = Float(8.0)
                let speed = simd_length(controllerDir) * (maxControllerSpeedFactor - minControllerSpeedFactor) + minControllerSpeedFactor
                directionWorld = speed * simd_normalize(directionWorld)
            }
        }
        return directionWorld
    }

    func explodeRocket(targetNode:SCNNode, removeTargetNode:Bool, pos:SCNVector3? = nil){
        if(!self.isExploded){
            self.isExploded = true
            let exp = SCNParticleSystem()
            exp.loops = false
            exp.birthRate = 5000
            exp.emissionDuration = 0.01
            exp.spreadingAngle = 140
            exp.particleDiesOnCollision = true
            exp.particleLifeSpan = 0.5
            exp.particleLifeSpanVariation = 0.3
            exp.particleVelocity = 500
            exp.particleVelocityVariation = 3
            exp.particleSize = 0.05
            exp.stretchFactor = 0.05
            exp.particleColor = NSColor.orange
            
            let shotParticleNode2 = SCNNode()
            let particle2:SCNParticleSystem = SCNParticleSystem(named: "ExplosionBasic", inDirectory: SuakeVars.DIR_PARTICLES)!
            particle2.birthRate *= 27
            shotParticleNode2.addParticleSystem(particle2)
            shotParticleNode2.scale = SCNVector3(3, 3, 3)
            let shotParticleNode = SCNNode()
            shotParticleNode.addParticleSystem(exp)
            
            self.nukeBlast.detonateNuke(pos: self.position)
            
            if(removeTargetNode){
                shotParticleNode.position = targetNode.presentation.position
                shotParticleNode2.position = targetNode.presentation.position
                targetNode.runAction(SCNAction.removeFromParentNode(), completionHandler: {
                    
                })
            }else{
                shotParticleNode.position = self.presentation.position
                shotParticleNode2.position = self.presentation.position
            }
            self.game.soundManager.playSoundPositional(soundType: .explosion, node: targetNode, completionHandler: {
                self.game.showDbgMsg(dbgMsg: "Nuke explosion finished")
                self.game.physicsHelper.qeueNode2Remove(node: shotParticleNode)
                self.game.physicsHelper.qeueNode2Remove(node: shotParticleNode2)
                self.game.physicsHelper.qeueNode2Remove(node: self)
                (self.weapon as! RedeemerComponent).nukeFlying = false
            })
            self.game.physicsHelper.qeueNode2Add2Scene(node: shotParticleNode)
            self.game.physicsHelper.qeueNode2Add2Scene(node: shotParticleNode2)
            self.game.overlayManager.hud.overlayScene.crosshairEntity.redeemerCrosshairComponent.showRocketView(show: false)
        }
    }
    
    func explodeNuke(){
        self.explodeRocket(targetNode: self, removeTargetNode: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
