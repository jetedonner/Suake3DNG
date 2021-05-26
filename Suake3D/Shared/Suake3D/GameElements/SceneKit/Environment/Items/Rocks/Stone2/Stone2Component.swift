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

class Stone2Component: SuakeBaseLocationComponent {
    
    let rescale:SCNVector3 = SCNVector3(0.05, 0.05, 0.05)
    
    init(game: GameController, id:Int = 0) {
        super.init(game: game, node: SuakeBaseSCNNode(game: game, sceneName: "art.scnassets/nodes/environment/static/rocks/stone2/Stone2.scn", scale: self.rescale), locationType: .Stone2, id: id)
        self.node.name = "Stone2: " + self.id.description
        self.initPhysics()
        self.node.categoryBitMask = CollisionCategory.rock.rawValue
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        self.initSetupPos()
    }
    
    func initPhysics(){
        let generatorhape1 = SCNPhysicsShape(geometry: self.node.cloneNode.flattenedClone().geometry!, options: [SCNPhysicsShape.Option.scale: self.rescale /* 1.15*/])
        self.node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: generatorhape1)
        self.node.physicsBody?.isAffectedByGravity = false
        self.node.physicsBody?.restitution = 1.0
        self.node.physicsBody?.mass = 60
//        self.node.physicsBody?.
        self.node.physicsBody?.categoryBitMask = CollisionCategory(category: .rock).rawValue
        self.node.physicsBody?.contactTestBitMask = CollisionCategory.getAllBulletCats()
    }
    
    func initSetupPos(){
        let pos:SCNVector3 = self.game.levelManager.gameBoard.getRandomFreePos()
        if(self.id == 0){
            (self.entity as! SuakeBaseNodeEntity).pos = SCNVector3(2, 0, 3)//SCNVector3(-2, 0, 1)
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
