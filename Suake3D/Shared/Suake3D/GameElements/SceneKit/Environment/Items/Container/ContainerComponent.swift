//
//  DbgPointComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 23.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class ContainerComponent: SuakeBaseLocationComponent {
    
    let rescale:SCNVector3 = SCNVector3(0.5, 0.5, 0.5)
    
    init(game: GameController, id:Int = 0) {
        super.init(game: game, node: SuakeBaseSCNNode(game: game, sceneName: "art.scnassets/nodes/environment/movable/container/Container.scn", scale: self.rescale), locationType: .Container, id: id)
        self.node.name = "Container: " + self.id.description
        self.initPhysics()
        self.node.categoryBitMask = CollisionCategory.container.rawValue
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        self.initSetupPos()
    }
    
    func initPhysics(){
        let containerShape1 = SCNPhysicsShape(geometry: self.node.cloneNode.flattenedClone().geometry!, options: [SCNPhysicsShape.Option.scale: self.rescale /* 1.15*/, SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox])
        let clone = self.node.cloneNode.flattenedClone()
        let testGeo:SCNBox = SCNBox(width: CGFloat(31.0), height: CGFloat(31.0), length: CGFloat(31.0), chamferRadius: 5.0)
        let testShape:SCNPhysicsShape = SCNPhysicsShape(geometry: testGeo/*, options: [/*SCNPhysicsShape.Option.scale: self.rescale*/ /* 1.15*//*, SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox*/]*/)
        self.node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: testShape)// containerShape1)
//        self.node.physicsBody?.physicsShape =
        self.node.physicsBody?.isAffectedByGravity = true
        self.node.physicsBody?.restitution = 0.5
//        self.node.physicsBody?.allowsResting = true
        self.node.physicsBody?.mass = 60
        self.node.physicsBody?.angularRestingThreshold = 0.0
        self.node.physicsBody?.linearRestingThreshold = 0.0
        self.node.physicsBody?.angularVelocityFactor = SCNVector3(1.0, 0.0, 1.0)
//        self.node.physicsBody?.momentOfInertia = SCNVector3(0.0, 0.0, 0.0)
        
//        self.node.physicsBody?.allowsResting = true
//        self.node.physicsBody?.usesDefaultMomentOfInertia = false
        self.node.physicsBody?.centerOfMassOffset = SCNVector3(0, 15.0, 0)
        self.node.physicsBody?.categoryBitMask = CollisionCategory(category: .container).rawValue
        self.node.physicsBody?.contactTestBitMask = CollisionCategory.getAllBulletCats()
        self.node.physicsBody?.collisionBitMask = CollisionCategory.container.rawValue | CollisionCategory.generator.rawValue | CollisionCategory.floor.rawValue | CollisionCategory.wall.rawValue | CollisionCategory.suake.rawValue | CollisionCategory.getAllBulletCats() | CollisionCategory.rocketBlast.rawValue
    }
    
    func initSetupPos(){
        let pos:SCNVector3 = self.game.levelManager.gameBoard.getRandomFreePos()
        if(self.id == 0){
            (self.entity as! SuakeBaseNodeEntity).pos = SCNVector3(2, 0, 3)//SCNVector3(-2, 0, 1)
        }else if(self.id == 1){
            (self.entity as! SuakeBaseNodeEntity).pos = SCNVector3(-2, 0, 2)//SCNVector3(-2, 0, 1)
        }else{
            (self.entity as! SuakeBaseNodeEntity).pos = pos
        }
        
        let daPos = (self.entity as! SuakeBaseNodeEntity).pos
        
        self.node.position = SCNVector3((daPos.x * SuakeVars.fieldSize) + 75.0, self.node.position.y, (daPos.z * SuakeVars.fieldSize) + 75.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
