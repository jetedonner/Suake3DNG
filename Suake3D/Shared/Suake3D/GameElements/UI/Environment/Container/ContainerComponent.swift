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
    
//    let itemType:ItemType = .MedKit
    let rescale:SCNVector3 = SCNVector3(0.5, 0.5, 0.5)
    
//    init(game: GameController, prelaod:SuakeBaseSCNNode, id:Int = 0) {
//        super.init(game: game, node: prelaod.flattenedClone(), id: id)
//        self.node.name = "MedKit: " + self.id.description
//        self.initPhysics()
//        self.node.categoryBitMask = CollisionCategory.medKit.rawValue
//        self.node.childNode(withName: "Med_Kit", recursively: true)?.categoryBitMask = CollisionCategory.medKit.rawValue
//    }
    
    init(game: GameController, id:Int = 0) {
        super.init(game: game, node: SuakeBaseSCNNode(game: game, sceneName: "art.scnassets/nodes/environment/container/Container.scn", scale: self.rescale), locationType: .Container, id: id)
        self.node.name = "Container: " + self.id.description
        self.initPhysics()
        self.node.categoryBitMask = CollisionCategory.container.rawValue
        self.node.position = SCNVector3(self.node.position.x + 75.0, self.node.position.y, self.node.position.z + 75.0)
//        self.node.childNode(withName: "group1", recursively: <#T##Bool#>)
//        self.initSetupPos()
//        self.node.childNode(withName: "Med_Kit", recursively: true)?.categoryBitMask = CollisionCategory.medKit.rawValue
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        self.initSetupPos()
    }
    
    func initPhysics(){
        let containerShape1 = SCNPhysicsShape(geometry: self.node.cloneNode.flattenedClone().geometry!, options: [SCNPhysicsShape.Option.scale: self.rescale /* 1.15*/])
//        let translate = SCNMatrix4MakeTranslation(75.0, 0.0, 75.0)
//         let translateMatrix = NSValue.init(scnMatrix4: translate)
//        let containerShape = SCNPhysicsShape(shapes: [containerShape1], transforms: [translateMatrix])
        self.node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: containerShape1)
        self.node.physicsBody?.isAffectedByGravity = true
        self.node.physicsBody?.restitution = 1.0
        self.node.physicsBody?.mass = 160
        self.node.physicsBody?.categoryBitMask = CollisionCategory(category: .container).rawValue
        self.node.physicsBody?.contactTestBitMask = CollisionCategory.getAllBulletCats()
        self.node.physicsBody?.collisionBitMask = CollisionCategory.floor.rawValue | CollisionCategory.wall.rawValue | CollisionCategory.getAllBulletCats()
//        self.node.physicsBody?.collisionBitMask = 0
    }
    
    func initSetupPos(){
        let pos:SCNVector3 = self.game.levelManager.gameBoard.getRandomFreePos()
        if(self.id == 0){
            (self.entity as! SuakeBaseNodeEntity).pos = SCNVector3(2, 0, 3)//SCNVector3(-2, 0, 1)
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
