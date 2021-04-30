//
//  BasePlantNode.swift
//  Suake3D
//
//  Created by dave on 23.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class ContainerGroupItem:SuakeNodeGroupItemBase {
    
//    var explodeNode:SCNNode!
//    var translateVector:SCNVector3 = SCNVector3(x: 37.5, y: 8.0, z: 37.5)
    let containerComponent:ContainerComponent
    
    override init(game:GameController, id:Int = 0) {
        self.containerComponent = ContainerComponent(game: game, id: id)
        
        super.init(game: game, id: id)
        
        self.addComponent(self.containerComponent)
        
        
//        let containerType:String = "Container.scn"
        
//        super.init(game: game, sceneName: "art.scnassets/nodes/levels/container/" + containerType, copyNodes: ["group1"], nodeName: "ContainerItem", hasPhysicsBody: false)
//        self.scale = SCNVector3(0.5, 0.5, 0.5)
//        self.initPhysics()
//        self.physicsBody?.isAffectedByGravity = false
//        self.physicsBody?.categoryBitMask = CollisionCategoryNG.container.rawValue // CollisionCategory.PortalInCategory
//        self.physicsBody?.contactTestBitMask = CollisionCategoryNG.rocket.rawValue|CollisionCategoryNG.mgbullet.rawValue|CollisionCategoryNG.pellet.rawValue|CollisionCategoryNG.railbeam.rawValue|CollisionCategoryNG.sniperRifleBullet.rawValue
//        self.physicsBody?.collisionBitMask = 0
//        self.pos = self.game.gameBoard.initRandomPos()
    }
    
//    override func initPhysics(){
//        let daNode = self.childNode(withName: "group1", recursively: true)
//        let shape = SCNPhysicsShape(geometry: (daNode!.flattenedClone().geometry)!, options: [SCNPhysicsShape.Option.scale: SCNVector3(0.5, 0.5, 0.5)])
//        let shape2 = SCNPhysicsShape(shapes: [shape], transforms: [SCNMatrix4MakeTranslation(translateVector.x, 0, translateVector.z) as NSValue])
//        self.physicsBody = SCNPhysicsBody(type: self.physicsBodyType, shape: shape2)
//        self.physicsBody?.isAffectedByGravity = false
//    }
//
//    func explodeRailgunBeam(pos:SCNVector3){
//        let particleEmitter:SCNParticleSystem = SCNParticleSystem(named: "ExplosionRailgun", inDirectory: SuakeVar.DIR_PARTICLES)!
//        self.explodeNode = SCNNode()
//        let shotParticleNode = SCNNode()
//        shotParticleNode.addParticleSystem(particleEmitter)
//        shotParticleNode.scale = SCNVector3(3, 3, 3)
//        explodeNode.addChildNode(shotParticleNode)
//        explodeNode.position = pos// (node.entity as? SuakeCharacter)!.mainNodeNG.position
//        explodeNode.position.z += translateVector.x
//        explodeNode.position.y += translateVector.y
//        explodeNode.position.x += translateVector.z
//        self.game.physicsHelper.qeueNode2Add2Scene(node: explodeNode)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
