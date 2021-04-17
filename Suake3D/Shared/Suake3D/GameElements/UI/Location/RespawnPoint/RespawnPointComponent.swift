//
//  RespawnPointComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 15.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class RespawnPointComponent: SuakeBaseLocationComponent {
    
    var planeNode:SCNNode!
    var particles:SCNNode!
    var particlesClone:SCNNode!
    
    init(game: GameController, id: Int = 0) {
        super.init(game: game, node: SuakeBaseSCNNode(game: game, sceneName: "art.scnassets/particles/RespawnPoint.scn"), locationType: .RespawnPoint, id: id)
        self.node.name = "RespawnPoint: " + self.id.description
        self.planeNode = self.node.childNode(withName: "plane", recursively: true)
        self.particles = self.node.childNode(withName: "particles", recursively: true)
        self.particlesClone = self.particles.clone()
        self.particles.removeFromParentNode()
    }
    
//    override func didAddToEntity() {
//        super.didAddToEntity()
//    }
    
    func initSetupPos(pos:SCNVector3){
        self.node.position = SCNVector3(150 * pos.x, 0, 150 * pos.z)
        (self.entity as! SuakeBaseNodeEntity).pos = pos
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
