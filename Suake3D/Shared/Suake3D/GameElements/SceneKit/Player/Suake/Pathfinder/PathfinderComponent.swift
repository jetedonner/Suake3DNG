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

class PathfinderComponent: ExplodingComponent {
    
    override init(game:GameController) {
        super.init(game: game)
    }
    
    override func didAddToEntity() {
        self.explode()
    }
    
    func resetPos(){
        self.explodeNode.position = (self.entity as! SuakePlayerEntity).position
    }
    
    func moveOneField(){
        
//        let ownPos:SCNVector3 = self.explodeNode.position
//        let goodyPos:SCNVector3 = self.game.playerEntityManager.goodyEntity.position
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        
        self.explodeNode.position.z += SuakeVars.fieldSize
        
        SCNTransaction.commit()
    }
    
    func moveTowardGoody(){
        
//        let ownPos:SCNVector3 = self.explodeNode.position
        let goodyPos:SCNVector3 = self.game.playerEntityManager.goodyEntity.position
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 10.0
        
        self.explodeNode.position = goodyPos
        
        SCNTransaction.commit()
    }
    
    func createTrail() -> SCNParticleSystem {
//        let scene = SCNScene(named: "art.scnassets/particles/PathfinderParticlesNG.scn")
//        let node:SCNNode = (scene?.rootNode.childNode(withName: "PathfinderParticles", recursively: true)!)!
//        let particleSystem:SCNParticleSystem = (node.particleSystems?.first)!
        
        
        
        let particleEmitter:SCNParticleSystem = SCNParticleSystem(named: SuakeVars.PARTICLES_NG, inDirectory: SuakeVars.DIR_PARTICLES)!
        return particleEmitter
//        particleSystem.particleColor = color
//        particleSystem.emitterShape = geometry
//        return particleSystem
    }
    
    func createFollowParticleNode()->SCNNode{
        return SuakeBaseSCNNode(game: game, sceneName: "art.scnassets/particles/FollowTheGoodyParticles.scn")
    }
    
    override func explode(){
//        let particleEmitter:SCNParticleSystem = self.createTrail()
        self.explodeNode = self.createFollowParticleNode().childNode(withName: "ParentNode", recursively: true)!// SCNNode()
        self.explodeNode.name = "Pathfinder-Particles"
//        let shotParticleNode = SCNNode()
//        shotParticleNode.addParticleSystem(particleEmitter)
        self.explodeNode.position.y += 33

//        self.explodeNode.addChildNode(shotParticleNode)
        let playerEntity = (node.entity as! SuakeBaseExplodingPlayerEntity)
        var explodePos:SCNVector3!
        explodePos = PositionHelper.suakePos2ScenePos(pos: (playerEntity as! SuakePlayerEntity).moveComponent.nextPos ?? (playerEntity as! SuakePlayerEntity).pos)
        self.explodeNode.position = explodePos
        self.explodeNode.position.y += 33
        self.game.physicsHelper.qeueNode2Add2Scene(node: self.explodeNode)
    }

//    override func explode(){
//        let particleEmitter:SCNParticleSystem = self.createTrail()
//        self.explodeNode = SCNNode()
//        self.explodeNode.name = "Pathfinder-Particles"
//        let shotParticleNode = SCNNode()
//        shotParticleNode.addParticleSystem(particleEmitter)
//        shotParticleNode.position.y += 33
//
//        self.explodeNode.addChildNode(shotParticleNode)
//        let playerEntity = (node.entity as! SuakeBaseExplodingPlayerEntity)
//        var explodePos:SCNVector3!
//        explodePos = PositionHelper.suakePos2ScenePos(pos: (playerEntity as! SuakePlayerEntity).moveComponent.nextPos ?? (playerEntity as! SuakePlayerEntity).pos)
//        self.explodeNode.position = explodePos
//        self.game.physicsHelper.qeueNode2Add2Scene(node: self.explodeNode)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
