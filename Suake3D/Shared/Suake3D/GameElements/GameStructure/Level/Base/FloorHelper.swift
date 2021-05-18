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
    
    var floorType:FloorType
    
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
            self.setFloor(imageName: type.toString())
//            self.game.floorNode.geometry?.firstMaterial?.diffuse.contents = type.toString()
        }
    }
    
    func setFloor(imageName:String){
        self.game.floorNode.geometry?.firstMaterial?.diffuse.contents = imageName
    }
}
