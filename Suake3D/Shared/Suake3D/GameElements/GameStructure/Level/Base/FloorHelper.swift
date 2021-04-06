//
//  FloorHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 11.03.21.
//

import Foundation
import SceneKit
import NetTestFW

class FloorHelper: SuakeGameClass {
    
    let floorType:FloorType
    
    init(game: GameController, floorType:FloorType) {
        self.floorType = floorType
        super.init(game: game)
    }
    
    func setFloor(){
        self.setFloor(type: self.floorType)
    }
    
    func setFloor(type:FloorType){
        if(type == .RandomFloor){
            self.setFloor(type: FloorType.random())
        }else{
            self.game.floorNode.geometry?.firstMaterial?.diffuse.contents = type.toString()
        }
    }
}
