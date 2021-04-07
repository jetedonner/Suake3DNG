//
//  SuakeMoveComponentExt.swift
//  Suake3D
//
//  Created by Kim David Hauser on 14.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

extension SuakeMoveComponent{
    func nextPos(dir:SuakeDir, suakePart:SuakePart)->SCNVector3{
        var posRes:SCNVector3 = self.playerEntity.pos
        switch(dir){
            case .UP:
                if(suakePart == .leftToStraight){
                    posRes.x -= 1
                }else if(suakePart == .rightToStraight){
                    posRes.x += 1
                }else if(suakePart == .leftToLeft || suakePart == .leftToRight || suakePart == .rightToRight || suakePart == .rightToLeft){
                    
                }else{
                    posRes.z += 1
                }
            case .DOWN:
                if(suakePart == .leftToStraight){
                    posRes.x += 1
                }else if(suakePart == .rightToStraight){
                    posRes.x -= 1
                }else if(suakePart == .leftToLeft || suakePart == .leftToRight || suakePart == .rightToRight || suakePart == .rightToLeft){
                    
                }else{
                    posRes.z -= 1
                }
            case .LEFT:
                if(suakePart == .leftToStraight){
                    posRes.z += 1
                }else if(suakePart == .rightToStraight){
                    posRes.z -= 1
                }else if(suakePart == .leftToLeft || suakePart == .leftToRight || suakePart == .rightToRight || suakePart == .rightToLeft){
                    
                }else{
                    posRes.x += 1
                }
                break
            case .RIGHT:
                if(suakePart == .leftToStraight){
                    posRes.z -= 1
                }else if(suakePart == .rightToStraight){
                    posRes.z += 1
                }else if(suakePart == .leftToLeft || suakePart == .leftToRight || suakePart == .rightToRight || suakePart == .rightToLeft){
                    
                }else{
                    posRes.x -= 1
                }
            case .NONE:
                break
            case .PORTATIOM:
                break
        }
//        self.game.showDbgMsg(dbgMsg: "x: \(posRes.x), z: \(posRes.z), dir: \(self.dir.rawValue)", dbgLevel: .Verbose)
        
        return posRes
    }
    
    @discardableResult
    func moveNode(newPos:SCNVector3, seconds:TimeInterval)->Bool{
        self.playerEntity.pos = newPos
        self.playerEntity.suakePlayerComponent.currentSuakeComponent.node.animationNode?.animationPlayer(forKey: self.playerEntity.suakePlayerComponent.currentSuakeComponent.node.animationKey!)?.stop()
        self.playerEntity.suakePlayerComponent.currentSuakeComponent.node.animationNode?.animationPlayer(forKey: self.playerEntity.suakePlayerComponent.currentSuakeComponent.node.animationKey!)?.play()
        self.playerEntity.cameraComponent.moveFollowCamera()
        self.game.overlayManager.hud.setPositionTxt(pos: newPos)
        return true
    }
}
