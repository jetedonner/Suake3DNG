//
//  PosHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 18.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class PosHelper {
    
    static func getNextPos4DirNG(daDir:SuakeDir, suakePart:SuakePart, daPos:SCNVector3)->SCNVector3{
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
    
    static func getDirFromDif(dx:Int32, dz:Int32)->SuakeDir{
        if(dx > 0){
            return .LEFT
        }else if(dx < 0){
            return .RIGHT
        }else if(dz < 0){
            return .DOWN
        }else{
            return .UP
        }
    }
}
