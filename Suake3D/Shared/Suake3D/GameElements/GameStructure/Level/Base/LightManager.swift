//
//  LightManager.swift
//  Suake3D
//
//  Created by Kim David Hauser on 06.04.21.
//

import Foundation
import SceneKit
import NetTestFW

class LightManager: SuakeGameClass {
    
    var ambientLightNode = SCNNode()
    
    override init(game: GameController) {
        super.init(game: game)
        self.ambientLightNode.name = "Ambient light"
    }
    
    func initLights(){
        self.initAmbientLight()
    }
    
    func initAmbientLight(){
        if(SuakeVars.showAmbientLight){
            ambientLightNode.light = SCNLight()
            ambientLightNode.light!.type = .ambient
            self.setAmbientLight(intensity: LightIntensity.normal, color: NSColor.lightGray)
            if(ambientLightNode.parent == nil){
                self.game.scene.rootNode.addChildNode(ambientLightNode)
            }
        }
    }
    
    func setAmbientLight(intensity:LightIntensity, color:NSColor = .white){
        self.ambientLightNode.light?.intensity = CGFloat(intensity.rawValue)
        self.ambientLightNode.light?.color = color
    }
}
