//
//  PlayerExplodingComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 31.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class PlayerExplodingComponent: ExplodingComponent {
    
    override init(game:GameController) {
        super.init(game: game)
    }
    
    override func explode(){
        let particleEmitter:SCNParticleSystem = SCNParticleSystem(named: SuakeVars.PARTICLES_EXPLOSION_BASIC, inDirectory: SuakeVars.DIR_PARTICLES)!
        let particleEmitter2:SCNParticleSystem = self.addExplosionParticles2()
        let particleEmitter3:SCNParticleSystem = self.addExplosionParticles3()
        
        self.explodeNode = SCNNode()
        let shotParticleNode = SCNNode()
        let shotParticleNode2 = SCNNode()
        let shotParticleNode3 = SCNNode()
        
        particleEmitter.birthRate *= 27
        
        shotParticleNode.addParticleSystem(particleEmitter)
        shotParticleNode.position.y += 13
        
        shotParticleNode2.addParticleSystem(particleEmitter2)
        shotParticleNode3.addParticleSystem(particleEmitter3)
        
        explodeNode.addChildNode(shotParticleNode)
        explodeNode.addChildNode(shotParticleNode2)
        explodeNode.addChildNode(shotParticleNode3)
        
        let playerEntity = (node.entity as! SuakeBaseExplodingPlayerEntity)
        var explodePos:SCNVector3!
        if(playerEntity.playerType == .Droid){
            explodePos = PositionHelper.suakePos2ScenePos(pos: playerEntity.pos)
        }else{
            explodePos = PositionHelper.suakePos2ScenePos(pos: (playerEntity as! SuakePlayerEntity).moveComponent.nextPos ?? (playerEntity as! SuakePlayerEntity).pos)
        }
        
        explodeNode.position = explodePos
        self.game.physicsHelper.qeueNode2Add2Scene(node: explodeNode)
        self.game.soundManager.playSound(soundType: .explosion)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
            self.game.physicsHelper.qeueNode2Remove(node: self.explodeNode)
        })
    }
    
    func addExplosionParticles2()->SCNParticleSystem{
        let exp = SCNParticleSystem()
        exp.loops = false
        exp.birthRate = 5000
        exp.emissionDuration = 0.01
        exp.spreadingAngle = 140
        exp.particleDiesOnCollision = true
        exp.particleLifeSpan = 0.1
        exp.particleLifeSpanVariation = 0.3
        exp.particleVelocity = 500
        exp.particleVelocityVariation = 3
        exp.particleSize = 0.05
        exp.stretchFactor = 0.05
        exp.particleColor = NSColor.orange
//        exp.handle(SCNParticleEvent.death, forProperties: [], handler: {var1,var2,var3,var4 in
//                var tmp = -1
//                tmp /= -1
//        })
//        let partEvt:SCNParticleEvent = SCNParticleEvent.death
        return exp
    }
    
    func addExplosionParticles3()->SCNParticleSystem{
        let exp = SCNParticleSystem()
        exp.loops = false
        exp.birthRate = 500
        exp.emissionDuration = 0.1
        exp.spreadingAngle = 114
        exp.particleDiesOnCollision = true
        exp.particleLifeSpan = 0.3
        exp.particleLifeSpanVariation = 0.3
        exp.particleVelocity = 300
        exp.particleSize = 1
        exp.particleImage = "art.scnassets/particles/images/spark.png"
        exp.particleColor = NSColor.lightGray
        return exp
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
