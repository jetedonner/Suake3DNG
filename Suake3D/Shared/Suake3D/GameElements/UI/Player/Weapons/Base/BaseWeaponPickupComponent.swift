//
//  BaseWeaponPickupComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 26.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class BaseWeaponPickupComponent: SuakeBaseSCNNodeComponent {
    
    var rescale:SCNVector3 = SCNVector3(x: 1.0, y: 1.0, z: 1.0)
    
    init(game: GameController, node: SuakeBaseSCNNode, id:Int = 0, rescale:CGFloat = 1.0){
        super.init(game: game, node: node, id: id)
        self.rescale = SCNVector3(x: rescale, y: rescale, z: rescale)
        self.node.addAnimation(RotationAnimHelper.getRotationAnim(), forKey: nil)
        self.node.addAnimation(RotationAnimHelper.getUpDownAnim(), forKey: "position.y")
    }
    
    init(game: GameController, sceneName:String, rescale:CGFloat = 1.0, id: Int = 0) {
        self.rescale = SCNVector3(rescale, rescale, rescale)
        super.init(game: game, node: SuakeBaseSCNNode(game: game, sceneName: sceneName, scale: self.rescale), id: id)
        self.node.addAnimation(RotationAnimHelper.getRotationAnim(), forKey: "rotation")
        self.node.addAnimation(RotationAnimHelper.getUpDownAnim(), forKey: "position.y")
    }
    
    func removeFromScene() {
        self.removeComponentFromScene(component: self)
    }
    
    func removeComponentFromScene(component:SuakeBaseSCNNodeComponent){
        self.game.physicsHelper.qeueNode2Remove(node: self.node)
        self.node.removeFromParentNode()
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        self.setupPhysics(geometry: self.node.flattenedClone().geometry!, type: .kinematic, categoryBitMask: (self.entity as! BaseWeaponPickupEntity).collisionCategory, catBitMasks: CollisionCategory.allBulletCategories, options: [SCNPhysicsShape.Option.scale: self .rescale])
    }
    
    func initSetupPos(addToScene:Bool = true){
        let pos:SCNVector3 = self.game.levelManager.gameBoard.getRandomFreePos()
        (self.entity as! BaseWeaponPickupEntity).pos = pos
        self.node.position.y = 5.0
        if(addToScene){
            self.addToScene()
        }
//        super.initSetupPos(addToScene: addToScene)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
