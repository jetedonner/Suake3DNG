//
//  GoodyComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 15.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class GoodyComponent: SuakeBaseSCNNodeComponent {
    
    var goodyEntity:GoodyEntity{
        get{ return super.entity as! GoodyEntity }
    }
    
    init(game: GameController, id:Int) {
        super.init(game: game, node: SuakeBaseAnimatedSCNNode(game: game, sceneName: "art.scnassets/nodes/goody/goody.scn", scale: SuakeVars.goodyScale, name: "Goody"), id: id)
        self.node.addAnimation(RotationAnimHelper.getRotationAnim(), forKey: nil)
        
        self.setupPhysics(geometry: (self.node as! SuakeBaseAnimatedSCNNode).cloneNode.flattenedClone().geometry!, type: .static, categoryBitMask: .goody, catBitMasks: CollisionCategory.allBulletCategories, options: [SCNPhysicsShape.Option.scale: SCNVector3(2.5, 2.5, 2.5)])
        // NEEDED for hitTest(with CollisionCategory bitmask option)
        self.node.childNode(withName: "_Sphere002", recursively: true)?.categoryBitMask = CollisionCategory.goody.rawValue
    }
    
//    func setupPhysics(geometry:SCNGeometry, type:SCNPhysicsBodyType, categoryBitMask:CollisionCategory, catBitMasks:[CollisionCategory], options: [SCNPhysicsShape.Option : Any]? = nil){
//
//        let bulletShape = SCNPhysicsShape(geometry: geometry, options: options)
//        self.node.physicsBody = SCNPhysicsBody(type: type, shape: bulletShape)
//        self.node.physicsBody?.categoryBitMask = categoryBitMask.rawValue
//        var contactTestBitMask:Int = 0
//        for catBitMask in catBitMasks{
//            contactTestBitMask = contactTestBitMask | catBitMask.rawValue
//        }
//        self.node.physicsBody?.contactTestBitMask = contactTestBitMask
//        self.node.physicsBody?.collisionBitMask = 0
//        self.node.physicsBody?.isAffectedByGravity = false
//        super.setupPhysics(geometry: <#T##SCNGeometry#>, type: <#T##SCNPhysicsBodyType#>, categoryBitMask: <#T##CollisionCategory#>, catBitMasks: <#T##[CollisionCategory]#>, options: <#T##[SCNPhysicsShape.Option : Any]?#>)
//    }
    
    func initSetupPos(addToScene:Bool = true){
//        (self.node as! SuakeBaseAnimatedSCNNode).scale = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
        let pos:SCNVector3 = SuakeVars.goodyPos
        (self.entity as! SuakeBaseNodeEntity).pos = pos
        self.node.position = SCNVector3(pos.x * SuakeVars.fieldSize, 0, pos.z * SuakeVars.fieldSize)
        self.game.overlayManager.hud.setGoodyPositionTxt(pos: pos)
        self.game.levelManager.gameBoard.setGameBoardField(pos: pos, suakeField: .goody)
    }
    
//    func getPosRandom()->SCNVector3{
//        let pos:SCNVector3 = self.game.levelManager.gameBoard.getRandomFreePos()
//        return pos
//    }
    
    @discardableResult
    func initPosRandom(newPos:SCNVector3? = nil)->SCNVector3{
        self.game.levelManager.gameBoard.setGameBoardField(pos: (self.entity as! SuakeBaseNodeEntity).pos, suakeField: .empty)
        self.game.levelManager.gameBoard.removeGameBoardFieldItem(pos: self.goodyEntity.pos, suakeFieldItem: self.goodyEntity)
        let pos:SCNVector3 = newPos ?? self.game.levelManager.gameBoard.getRandomFreePos()
        (self.entity as! SuakeBaseNodeEntity).pos = pos
        self.node.position = SCNVector3(pos.x * SuakeVars.fieldSize, 0, pos.z * SuakeVars.fieldSize)
        self.game.overlayManager.hud.setGoodyPositionTxt(pos: pos)
        self.game.levelManager.gameBoard.setGameBoardField(pos: pos, suakeField: .goody)
        self.game.levelManager.gameBoard.setGameBoardFieldItem(pos: pos, suakeFieldItem: self.goodyEntity)
        self.game.overlayManager.hud.overlayScene!.map.reposNode(playerNode: self.game.overlayManager.hud.overlayScene!.map.goodyNode, pos: pos)
        self.game.overlayManager.hud.overlayScene.windrose.updateArrowGoodyPos()
        return pos
    }
    
    func add2Scene(){
        self.game.physicsHelper.qeueNode2Add2Scene(node: self.node)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
