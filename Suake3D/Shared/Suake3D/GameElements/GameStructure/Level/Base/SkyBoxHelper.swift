//
//  SkyBoxHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 11.03.21.
//

import Foundation
import SceneKit
import NetTestFW

class SkyBoxHelper: SuakeGameClass {
    
    var skyboxType:SkyboxType
    
    init(game: GameController, skyboxType:SkyboxType) {
        self.skyboxType = skyboxType
        super.init(game: game)
    }
    
    func setSkybox(){
        self.setSkybox(type: self.skyboxType)
    }
    
    func setSkybox(type:SkyboxType){
        if(type == .RandomSkyBox){
            self.setSkybox(type: SkyboxType.random())
        }else{
            self.skyboxType = type
            self.game.scene.background.contents = SkyboxType.getSkybox(type: type)
            self.game.showDbgMsg(dbgMsg: "Setting skybox: \(type.toString())")
//            self.game.scene.background.contentsTransform = SCNMatrix4Make Translation(0, 3800, 0)
        }
    }
    
    func getFloor4QuakeSkybox(dbgFloor:Bool = false)->String{
        return SkyboxType.getFloor4QuakeSkybox(type: self.skyboxType, dbgFloor: dbgFloor)
    }
}
