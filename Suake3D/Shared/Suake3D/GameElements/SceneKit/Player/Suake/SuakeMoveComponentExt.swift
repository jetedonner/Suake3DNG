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
    
    func getNextPos4DirNG(daDir:SuakeDir, suakePart:SuakePart, daPos:SCNVector3)->SCNVector3{
        var posRet:SCNVector3 = daPos
        switch daDir {
            case .UP:
                if(suakePart == .rightToStraight){
                    posRet.z += 1 // FIXED THEO posRet.x += 1
                }else if(suakePart == .rightToLeft){
                    posRet.z += 1 // FIXED THEO !!!!!posRet.x += 1
                }else if(suakePart == .straightToLeft){ // THEORETICALLY
                    posRet.z += 1
                }else if(suakePart == .rightToRight){ // THEORETICALLY
                    posRet.z += 1 // FIXED THEO !!!! posRet.x += 1
                }else if(suakePart == .leftToRight){ // THEORETICALLY
                    posRet.z += 1 // FIXED THEO !!!! posRet.x -= 1
                }else if(suakePart == .leftToLeft){ // THEORETICALLY
                    posRet.z += 1 // FIXED THEO !!!! posRet.x -= 1
                }else if(suakePart == .leftToStraight){
                    posRet.z += 1 // FIXED THEO posRet.x -= 1
                }else {
                    posRet.z += 1
                }
            case .DOWN:
                if(suakePart == .rightToStraight){
                    posRet.z -= 1 // FIXED THEO posRet.x -= 1
                }else if(suakePart == .rightToLeft){
                    posRet.z -= 1 // FIXED THEO !!!! posRet.x -= 1
                }else if(suakePart == .straightToLeft){
                    posRet.z -= 1
                }else if(suakePart == .rightToRight){
                    posRet.z -= 1 // FIXED THEO !!!!! posRet.x -= 1
                }else if(suakePart == .leftToRight){
                    posRet.z -= 1 // FIXED !!!!! posRet.x += 1
                }else if(suakePart == .leftToLeft){ // Theoretically
                    posRet.z -= 1 // FIXED !!!!! posRet.x += 1
                }else if(suakePart == .leftToStraight){
                    posRet.z -= 1 // FIXED posRet.x += 1
                }else{
                    posRet.z -= 1
                }
            case .LEFT:
                if(suakePart == .leftToStraight){
                    posRet.x += 1 // FIXED posRet.z += 1
                }else if(suakePart == .leftToRight){
                    posRet.x += 1 // FIXED !!!! posRet.z += 1
                }else if(suakePart == .rightToStraight){
                    posRet.x += 1 // FIXED THEO posRet.z -= 1
                }else if(suakePart == .rightToLeft){
                    posRet.x += 1 // FIXED THEO !!!!! posRet.z -= 1
                }else if(suakePart == .rightToRight){ // THEORETICALLY
                    posRet.x += 1 // FIXED THEO !!!!! posRet.z -= 1
                }else if(suakePart == .leftToLeft){
                    posRet.x += 1 // FIXED !!!! posRet.z += 1
                }else{
                    posRet.x += 1
                }
            case .RIGHT:
                if(suakePart == .rightToRight){
                    posRet.x -= 1 // FIXED THEO !!!!! posRet.z += 1
                }else if(suakePart == .rightToStraight){
                    posRet.x -= 1 // FIXED posRet.z += 1
                }else if(suakePart == .leftToStraight){
                    posRet.x -= 1 // FIXED THEO posRet.z -= 1
                }else if(suakePart == .leftToRight){
                    posRet.x -= 1 // FIXED THEO !!!!! posRet.z -= 1
                }else if(suakePart == .leftToLeft){ // THEORETICALLY
                    posRet.x -= 1 // FIXED THEO !!!!! posRet.z -= 1
                }else if(suakePart == .rightToLeft){ // THEORETICALLY
                    posRet.x -= 1 // FIXED THEO !!!!! posRet.z += 1
                }else{
                    posRet.x -= 1
                }
            case .NONE:
                break
            case .PORTATIOM:
                break
        }
        return posRet
    }
    
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
    func moveNode(newPos:SCNVector3, seconds:TimeInterval, opponent:Bool = false)->Bool{
        self.playerEntity.pos = newPos
        self.playerEntity.playerComponent.currentSuakeComponent.node.animationNode?.animationPlayer(forKey: self.playerEntity.playerComponent.currentSuakeComponent.node.animationKey!)?.stop()
        self.playerEntity.playerComponent.currentSuakeComponent.node.animationNode?.animationPlayer(forKey: self.playerEntity.playerComponent.currentSuakeComponent.node.animationKey!)?.play()
        self.playerEntity.cameraComponent.moveFollowCamera()
        if(!opponent){
            self.game.overlayManager.hud.setPositionTxt(pos: newPos)
        }
        return true
    }
}
