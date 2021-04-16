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

        let shotParticleSystem = SCNParticleSystem(named: "shotBurst", inDirectory: SuakeVars.DIR_PARTICLES)

        self.shotParticleNode.addParticleSystem(shotParticleSystem!)
        self.shotParticleNode.position = self.position
        self.shotParticleNode.name = "shotParticle"
        //self.shotParticleNode.position.z -= self.boundingBox.max.z
        self.addChildNode(shotParticleNode)
        
        let box = SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0)
//        let box = SCNBox(width: (self.boundingBox.max.x), height: (self.boundingBox.max.y), length: (self.boundingBox.max.z), chamferRadius: 0)
//        self.geometry = box
        
        self.setupPhysics(geometry: box, type: .dynamic, categoryBitMask: CollisionCategory.rocket, catBitMasks: [CollisionCategory.suake, CollisionCategory.suakeOpp, CollisionCategory.goody, CollisionCategory.droid, CollisionCategory.medKit, CollisionCategory.wall, CollisionCategory.floor])
        self.physicsBody?.damping = 0.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
