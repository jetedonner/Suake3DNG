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

class RailgunExplodingComponent: ExplodingComponent {
    
    override init(game:GameController) {
        super.init(game: game)
    }
    
    func explode(position:SCNVector3){
        let particleEmitter:SCNParticleSystem = SCNParticleSystem(named: "ExplosionRailgun", inDirectory: SuakeVars.DIR_PARTICLES)!
        
        self.explodeNode = SCNNode()
        self.explodeNode.name = "Railgun explosion"
        let shotParticleNode = SCNNode()
        
        particleEmitter.birthRate *= 27
        
        shotParticleNode.addParticleSystem(particleEmitter)
        shotParticleNode.position.y += 13
        
        explodeNode.addChildNode(shotParticleNode)
        
        self.node.position = position
        let waitAction = SCNAction.wait(duration: TimeInterval(particleEmitter.particleLifeSpan))
        self.node.runAction(waitAction, completionHandler: {
            self.node.removeFromParentNode()
        })
        self.node.addChildNode(self.explodeNode)
        self.game.physicsHelper.qeueNode2Add2Scene(node: self.node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
