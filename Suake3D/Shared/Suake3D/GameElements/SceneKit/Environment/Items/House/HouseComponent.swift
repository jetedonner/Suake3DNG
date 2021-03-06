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

class HouseComponent: SuakeBaseLocationComponent {
    
    let rescale:SCNVector3 = SCNVector3(0.07, 0.07, 0.07)
    
    init(game: GameController, id:Int = 0) {
        super.init(game: game, node: SuakeBaseSCNNode(game: game, sceneName: "art.scnassets/nodes/environment/static/house/hatka_local.scn", scale: self.rescale), locationType: .House, id: id)
        self.node.name = "House: " + self.id.description
        self.initPhysics()
        self.node.categoryBitMask = CollisionCategory.house.rawValue
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        self.initSetupPos()
    }
    
    func initPhysics(){
        let containerShape1 = SCNPhysicsShape(geometry: self.node.cloneNode.flattenedClone().geometry!, options: [SCNPhysicsShape.Option.scale: self.rescale /* 1.15*//*, SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox*/])
        self.node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: containerShape1)
//        self.node.physicsBody?.physicsShape =
        self.node.physicsBody?.isAffectedByGravity = false
        self.node.physicsBody?.restitution = 0.0
        self.node.physicsBody?.mass = 60
        self.node.physicsBody?.centerOfMassOffset = SCNVector3(0.0, 0.0, 0.0)
        self.node.physicsBody?.categoryBitMask = CollisionCategory(category: .house).rawValue
        self.node.physicsBody?.contactTestBitMask = CollisionCategory.getAllBulletCats()
        self.node.physicsBody?.collisionBitMask = CollisionCategory.house.rawValue | CollisionCategory.generator.rawValue | CollisionCategory.floor.rawValue | CollisionCategory.wall.rawValue | CollisionCategory.suake.rawValue | CollisionCategory.getAllBulletCats() | CollisionCategory.rocketBlast.rawValue
    }
    
    func initSetupPos(){
        let pos:SCNVector3 = self.game.levelManager.gameBoard.getRandomFreePos()
        if(self.id == 0){
            (self.entity as! SuakeBaseNodeEntity).pos = SCNVector3(2, 0, 3)//SCNVector3(-2, 0, 1)
        }else{
            (self.entity as! SuakeBaseNodeEntity).pos = pos
        }
        
        let daPos = (self.entity as! SuakeBaseNodeEntity).pos
        
        self.node.position = SCNVector3((daPos.x * SuakeVars.fieldSize) + 75.0, self.node.position.y + 10, (daPos.z * SuakeVars.fieldSize) + 75.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
