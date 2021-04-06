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
    
    let skyboxType:SkyboxType
    
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
            self.game.scene.background.contents = SkyboxType.getSkybox(type: type)
        }
    }
}
