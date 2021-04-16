//
//  RPGRocket.swift
//  Suake3D
//
//  Created by Kim David Hauser on 16.04.21.
//

import Foundation
import GameplayKit
import SceneKit

class RPGRocket: BulletBase {
    
    var rescale:CGFloat = 5.0
    let shotParticleNode = SCNNode()
    let shotParticleNode2 = SCNNode()
    let shotParticleNodeWhite = SCNNode()
    var isExploded:Bool = false
    
    init(game: GameController, weapon:RPGComponent) {
        super.init(game: game, weapon: weapon, sceneName: "art.scnassets/nodes/weapons/rpg/rocketlauncher_shell.scn", scale: SCNVector3(5, 5, 5))
        self.name = "RPGRocket"
        self.shootingVelocity = 485.0
        self.loadRocket()
    }
    
    func loadRocket(){
        self.rescale = 23
        self.damage = SuakeVars.RPG_DAMAGE
        
        self.scale.x = self.rescale
        self.scale.y = self.rescale
        self.scale.z = self.rescale

        let shotParticleSystem = SCNParticleSystem(named: SuakeVars.PARTICLES_RPG_BURST, inDirectory: SuakeVars.DIR_PARTICLES)

        self.shotParticleNode.addParticleSystem(shotParticleSystem!)
        self.shotParticleNode.position = self.position
        self.shotParticleNode.name = "shotParticle"
        //self.shotParticleNode.position.z -= self.boundingBox.max.z
        self.addChildNode(shotParticleNode)
        
        let shotParticleSystem2 = SCNParticleSystem(named: "ShotBurstRings", inDirectory: SuakeVars.DIR_PARTICLES)
        let shotParticleSystemWhite = SCNParticleSystem(named: "ShotBurstWhite", inDirectory: SuakeVars.DIR_PARTICLES)
        
        shotParticleNode2.addParticleSystem(shotParticleSystem2!)
        shotParticleNode2.position = self.position
        shotParticleNode2.name = "sniperShotParticle2"
//        shotParticleNode2.position.z -= self.boundingBox.max.z
        
        let sizeAnimation:CAKeyframeAnimation = CAKeyframeAnimation()
        sizeAnimation.values = [1.0, 2.0, 3.5, 5.0]
        
        let opacityAnimation:CAKeyframeAnimation = CAKeyframeAnimation()
        opacityAnimation.values = [1.0, 0.7, 0.3, 0.0]
        
        let sizeController = SCNParticlePropertyController(animation: sizeAnimation)
        let opatityController = SCNParticlePropertyController(animation: opacityAnimation)
        
        shotParticleSystem?.propertyControllers = [SCNParticleSystem.ParticleProperty.size: sizeController, SCNParticleSystem.ParticleProperty.opacity: opatityController]
//        self.name = "shotNode"
        self.addChildNode(shotParticleNode2)
        
        shotParticleNodeWhite.addParticleSystem(shotParticleSystemWhite!)
        shotParticleNodeWhite.position = self.position
        shotParticleNodeWhite.name = "shotParticleWhite"
//        shotParticleNodeWhite.position.z -= self.boundingBox.max.z
        self.addChildNode(shotParticleNodeWhite)
        
        
        let box = SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0)
//        let box = SCNBox(width: (self.boundingBox.max.x), height: (self.boundingBox.max.y), length: (self.boundingBox.max.z), chamferRadius: 0)
//        self.geometry = box
        
        self.setupPhysics(geometry: box, type: .dynamic, categoryBitMask: CollisionCategory.rocket, catBitMasks: [CollisionCategory.suake, CollisionCategory.suakeOpp, CollisionCategory.goody, CollisionCategory.droid, CollisionCategory.medKit, CollisionCategory.wall, CollisionCategory.floor])
        self.physicsBody?.damping = 0.0
    }
    
    override func hitTarget(targetCat:CollisionCategory, targetNode:SCNNode, contactPoint:SCNVector3? = nil)->Bool{
        if(!self.isTargetHit){
            self.isTargetHit = true
            self.explodeRocket(targetNode: targetNode, removeTargetNode: false, pos: contactPoint)
            return true
            //return super.hitTarget(targetCat: targetCat, targetNode: targetNode, contactPoint: contactPoint)
        }
        return false
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
            let particle2:SCNParticleSystem = SCNParticleSystem(named: SuakeVars.PARTICLES_EXPLOSION_BASIC, inDirectory: SuakeVars.DIR_PARTICLES)!
            particle2.birthRate *= 27
            shotParticleNode2.addParticleSystem(particle2)
            shotParticleNode2.scale = SCNVector3(3, 3, 3)
            let shotParticleNode = SCNNode()
            shotParticleNode.addParticleSystem(exp)
            if(removeTargetNode){
                shotParticleNode.position = targetNode.presentation.position
                shotParticleNode2.position = targetNode.presentation.position
                targetNode.runAction(SCNAction.removeFromParentNode(), completionHandler: {
                    
                })
            }else{
                shotParticleNode.position = self.presentation.position
                shotParticleNode2.position = self.presentation.position
            }
            self.game.soundManager.playSound(soundType: .explosion)
//            self.game.soundManager.playSoundPositional(soundType: .explosion, node: targetNode, completionHandler: {
//                self.game.showDbgMsg(dbgMsg: "Rocket explosion finished", dbgLevel: .Verbose)
//                self.game.physicsHelper.qeueNode2Remove(node: shotParticleNode)
//                self.game.physicsHelper.qeueNode2Remove(node: shotParticleNode2)
//                self.game.physicsHelper.qeueNode2Remove(node: self)
//            })
            self.game.physicsHelper.qeueNode2Add2Scene(node: shotParticleNode)
            self.game.physicsHelper.qeueNode2Add2Scene(node: shotParticleNode2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
