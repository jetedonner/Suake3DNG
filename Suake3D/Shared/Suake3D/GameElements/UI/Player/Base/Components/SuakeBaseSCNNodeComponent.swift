//
//  SuakeBaseSCNNodeComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 12.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeBaseSCNNodeComponent: GKSCNNodeComponent {
    
    let game:GameController
    let id:Int
    
    override var node:SuakeBaseSCNNode{
        get{ return super.node as! SuakeBaseSCNNode }
    }
    
    init(game:GameController, node:SuakeBaseSCNNode, id:Int = 0) {
        self.game = game
        self.id = id
        super.init(node: node)
    }
    
    func setupPhysics(geometry:SCNGeometry, type:SCNPhysicsBodyType, categoryBitMask:CollisionCategory, catBitMasks:[CollisionCategory], options: [SCNPhysicsShape.Option : Any]? = nil){
        
        let bulletShape = SCNPhysicsShape(geometry: geometry, options: options)
        self.node.physicsBody = SCNPhysicsBody(type: type, shape: bulletShape)
        self.node.physicsBody?.categoryBitMask = categoryBitMask.rawValue
        var contactTestBitMask:Int = 0
        for catBitMask in catBitMasks{
            contactTestBitMask = contactTestBitMask | catBitMask.rawValue
        }
        self.node.physicsBody?.contactTestBitMask = contactTestBitMask
        self.node.physicsBody?.collisionBitMask = 0
        self.node.physicsBody?.isAffectedByGravity = false
    }
    
//    func initSetupPos(addToScene:Bool = true){
////        self.dir = .UP
////        self.dirOld = .UP
//        
////        if(self.node.isKind(of: SuakeBaseAnimatedSCNNode.self)){
////            (self.node as! SuakeBaseAnimatedSCNNode).resetAllAnims()
////        }
//        if(addToScene){
//            self.addToScene()
//        }
//    }
    
    func addToScene() {
        self.game.physicsHelper.qeueNode2Add2Scene(node: self.node)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
