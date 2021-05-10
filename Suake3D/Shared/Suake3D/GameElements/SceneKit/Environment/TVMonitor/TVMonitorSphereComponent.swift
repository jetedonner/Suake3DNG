//
//  RespawnPointComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 15.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class TVMonitorSphereComponent: SuakeBaseLocationComponent {
    
//    var planeNode:SCNNode!
//    var particles:SCNNode!
//    var particlesClone:SCNNode!
    
    var tvMonitorSphereScreen:SCNNode!
    
    init(game: GameController, id: Int = 0) {
        super.init(game: game, node: SuakeBaseSCNNode(game: game, sceneName: "art.scnassets/nodes/environment/tvmonitor/TVMonitorSphere.scn"), locationType: .TVMonitorSphere, id: id)
        self.node.name = "TVMonitorSphere: " + self.id.description
        self.node.scale = SCNVector3(75, 75, 75)
        if(id == 0){
            self.node.eulerAngles.y = CGFloat.pi / -2
        }else if(id == 1){
            self.node.eulerAngles.y = CGFloat.pi / 2
        }/*else if(id == 2){
//            self.node.eulerAngles.y = CGFloat.pi / 2
        }*/else if(id == 3){
            self.node.eulerAngles.y = CGFloat.pi
        }
        self.tvMonitorSphereScreen = self.node.childNode(withName: "pSphere1", recursively: true)
//        self.planeNode = self.node.childNode(withName: "plane", recursively: true)
//        self.particles = self.node.childNode(withName: "particles", recursively: true)
//        self.particlesClone = self.particles.clone()
//        self.particles.removeFromParentNode()
    }
    
//    override func didAddToEntity() {
//        super.didAddToEntity()
//    }
    
    func initSetupPos(pos:SCNVector3){
        self.node.position = SCNVector3(SuakeVars.fieldSize * pos.x, SuakeVars.fieldSize * pos.y /*SuakeVars.fieldSize * pos.y*/, SuakeVars.fieldSize * pos.z)
//        (self.entity as! SuakeBaseNodeEntity).pos = pos
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
