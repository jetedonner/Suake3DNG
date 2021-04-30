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

class MedKitComponent: SuakeBaseLocationComponent {
    
//    let itemType:ItemType = .MedKit
    let rescale:SCNVector3 = SCNVector3(43, 43, 43)
    
//    init(game: GameController, prelaod:SuakeBaseSCNNode, id:Int = 0) {
//        super.init(game: game, node: prelaod.flattenedClone(), id: id)
//        self.node.name = "MedKit: " + self.id.description
//        self.initPhysics()
//        self.node.categoryBitMask = CollisionCategory.medKit.rawValue
//        self.node.childNode(withName: "Med_Kit", recursively: true)?.categoryBitMask = CollisionCategory.medKit.rawValue
//    }
    
    init(game: GameController, id:Int = 0) {
        super.init(game: game, node: SuakeBaseSCNNode(game: game, sceneName: "art.scnassets/nodes/medKit/medKit.scn", scale: self.rescale), locationType: .MedKit, id: id)
        self.node.name = "MedKit: " + self.id.description
        self.initPhysics()
        self.node.categoryBitMask = CollisionCategory.medKit.rawValue
        self.node.childNode(withName: "Med_Kit", recursively: true)?.categoryBitMask = CollisionCategory.medKit.rawValue
    }
    
    func initPhysics(){
        let medKitShape = SCNPhysicsShape(geometry: self.node.cloneNode.flattenedClone().geometry!, options: [SCNPhysicsShape.Option.scale: self.rescale])
        self.node.physicsBody = SCNPhysicsBody(type: .kinematic, shape: medKitShape)
        self.node.physicsBody?.isAffectedByGravity = false
        self.node.physicsBody?.categoryBitMask = CollisionCategory(category: .medKit).rawValue
        self.node.physicsBody?.contactTestBitMask = CollisionCategory.getAllBulletCats()
//        self.node.physicsBody?.collisionBitMask = 0
    }
    
    func initSetupPos(){
        let pos:SCNVector3 = self.game.levelManager.gameBoard.getRandomFreePos()
        if(self.id == 0){
            (self.entity as! SuakeBaseNodeEntity).pos = SCNVector3(4, 0, 4)//SCNVector3(-2, 0, 1)
        }else{
            (self.entity as! SuakeBaseNodeEntity).pos = pos
        }
//        self.game.levelManager.gameBoard.setGameBoardFieldEntity(pos: (self.entity as! SuakeBaseNodeEntity).pos, entity: self.entity as? SuakeBaseEntity)
//        (self.entity as! SuakeBaseNodeEntity).pos = SCNVector3(0, 0, 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
