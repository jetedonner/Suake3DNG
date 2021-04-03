//
//  SuakeDirTurnDirHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 14.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class SuakeDirTurnDirHelper {
    
    @discardableResult
    static func initNodeRotation(node:SCNNode, dir:SuakeDir = .UP)->SCNVector3{
        var rotation:SCNVector3 = SCNVector3(0, 0, 0)
        if(dir == .UP){
            rotation = SCNVector3(x: 0, y: 0, z: 0)
        }else if(dir == .DOWN){
            rotation = SCNVector3(x: 0, y: -1 * CGFloat(Double.pi), z: 0)
        }else if(dir == .LEFT){
            rotation = SCNVector3(x: 0, y: 0.5 * CGFloat(Double.pi), z: 0)
        }else if(dir == .RIGHT){
            rotation = SCNVector3(x: 0, y: -0.5 * CGFloat(Double.pi), z: 0)
        }
        node.eulerAngles = rotation
        return rotation
    }
    
    static func getSuakeDirFromTurnDir(oldSuakeDir:SuakeDir, turnDir:TurnDir)->SuakeDir{
        if(oldSuakeDir == .UP && turnDir == .Straight ||
            oldSuakeDir == .LEFT && turnDir == .Right ||
            oldSuakeDir == .RIGHT && turnDir == .Left ||
            oldSuakeDir == .DOWN && turnDir == .One80){
            return .UP
        }else if(oldSuakeDir == .DOWN && turnDir == .Straight ||
            oldSuakeDir == .RIGHT && turnDir == .Right ||
            oldSuakeDir == .LEFT && turnDir == .Left ||
            oldSuakeDir == .UP && turnDir == .One80){
            return .DOWN
        }else if(oldSuakeDir == .LEFT && turnDir == .Straight ||
            oldSuakeDir == .DOWN && turnDir == .Right ||
            oldSuakeDir == .UP && turnDir == .Left ||
            oldSuakeDir == .RIGHT && turnDir == .One80){
            return .LEFT
        }else if(oldSuakeDir == .RIGHT && turnDir == .Straight ||
            oldSuakeDir == .UP && turnDir == .Right ||
            oldSuakeDir == .DOWN && turnDir == .Left ||
            oldSuakeDir == .LEFT && turnDir == .One80){
            return .RIGHT
        }else{
            return .UP
        }
    }
    
    static func getTurnDirFromSuakeDirs(oldSuakeDir:SuakeDir, newSuakeDir:SuakeDir)->TurnDir{
        if(oldSuakeDir == .DOWN && newSuakeDir == .DOWN ||
            oldSuakeDir == .UP && newSuakeDir == .UP ||
            oldSuakeDir == .LEFT && newSuakeDir == .LEFT ||
            oldSuakeDir == .RIGHT && newSuakeDir == .RIGHT){
            return .Straight
        }else if(oldSuakeDir == .DOWN && newSuakeDir == .RIGHT ||
            oldSuakeDir == .UP && newSuakeDir == .LEFT ||
            oldSuakeDir == .LEFT && newSuakeDir == .DOWN ||
            oldSuakeDir == .RIGHT && newSuakeDir == .UP){
            return .Left
        }else if(oldSuakeDir == .DOWN && newSuakeDir == .LEFT ||
            oldSuakeDir == .UP && newSuakeDir == .RIGHT ||
            oldSuakeDir == .LEFT && newSuakeDir == .UP ||
            oldSuakeDir == .RIGHT && newSuakeDir == .DOWN){
            return .Right
        }else if(oldSuakeDir == .DOWN && newSuakeDir == .UP ||
           oldSuakeDir == .UP && newSuakeDir == .DOWN ||
           oldSuakeDir == .LEFT && newSuakeDir == .RIGHT ||
           oldSuakeDir == .RIGHT && newSuakeDir == .LEFT){
           return .One80
        }else if(oldSuakeDir == .UP && newSuakeDir == .PORTATIOM ||
            oldSuakeDir == .PORTATIOM && newSuakeDir == .UP){
            return .Straight
         }else{
            return .Straight
        }
    }
}
