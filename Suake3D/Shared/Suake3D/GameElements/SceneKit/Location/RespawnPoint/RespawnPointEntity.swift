//
//  DbgPoint.swift
//  Suake3D
//
//  Created by Kim David Hauser on 23.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class RespawnPointEntity: SuakeBaseNodeEntity {
    
    let respawnPointComponent:RespawnPointComponent
    
    override init(game: GameController, id:Int = 0) {
        self.respawnPointComponent = RespawnPointComponent(game: game, id: id)
        super.init(game: game, id: id)
        
        self.addComponent(self.respawnPointComponent)
    }
    
    func showRespawnPoint(pos:SCNVector3, duration:TimeInterval = 3.0){
        self.respawnPointComponent.initSetupPos(pos: pos)
        self.game.physicsHelper.qeueNode2Add2Scene(node: self.respawnPointComponent.node)
        let newNode = self.respawnPointComponent.particlesClone.clone()
        self.respawnPointComponent.node.addChildNode(newNode)
        self.respawnPointComponent.node.opacity = 1.0
        self.respawnPointComponent.node.runAction(SCNAction.fadeOut(duration: duration), completionHandler: {
//            newNode.particleSystems![0].reset()
//            newNode.removeFromParentNode()
            self.game.physicsHelper.qeueNode2Remove(node: self.respawnPointComponent.node)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
