//
//  GameBoardExt.swift
//  Suake3D
//
//  Created by Kim David Hauser on 15.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

extension GameBoard{
    
    func getRandomFreePos(diff:Int = 0)->SCNVector3{
//        self.printAllGamerBoardFields()
        var newPos:SCNVector3 = SCNVector3(0, 0, 0)
        var found:Bool = false
        repeat{
            found = false
            let newX = self.getNewX(diff: diff)
            let newZ = self.getNewZ(diff: diff)
            newPos = SCNVector3(newX, 0, newZ)
            if(self.getGameBoardField(pos: newPos) != .empty){
                found = true
                continue
            }else if(self.getGameBoardFieldItem(pos: newPos) != nil){
                found = true
                continue
            }
        }while(found)
        return newPos
    }
    
    func initRandomFreePos(fieldType:SuakeFieldType)->SCNVector3{
        let newPos:SCNVector3 = self.getRandomFreePos()
        self.setGameBoardField(pos: newPos, suakeField: fieldType)
        return newPos
    }
    
    func getNewX(diff:Int = 0)->Int{
        let maxX:Int = (Int(gameBoardFields.count) / 2) - diff
        let minX:Int = -maxX
        return Int.random(range: minX..<maxX)
    }
    
    func getNewZ(diff:Int = 0)->Int{
        let maxZ:Int = (Int(gameBoardFields.count) / 2) - diff
        let minZ:Int = -maxZ
        return Int.random(range: minZ..<maxZ)
    }
}
