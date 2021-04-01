//
//  LightTypes.swift
//  Suake3D
//
//  Created by Kim David Hauser on 02.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit

enum LightIntensity:CGFloat {
    case noLight =  0.0
    case low =      250.0
    case medium =   400.0
    case normal =   1500.0
    case high =     3000.0
    case veryHigh = 4500.0
    
    static func lightIntensity(from:String)->LightIntensity{
        switch from {
        case "NoLight":
            return .noLight
        case "Low":
            return .low
        case "Medium":
            return .medium
        case "Normal":
            return .normal
        case "High":
            return .high
        case "VeryHigh":
            return .veryHigh
        default:
            return .normal
        }
    }
}

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
        self.ambientLightNode.light?.intensity = intensity.rawValue
        self.ambientLightNode.light?.color = color
    }
}
