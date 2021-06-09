//
//  PosHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 18.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class PosHelper {
    
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
    
    static func rotateSuake(nextSuakePart:SuakePart, newDir:SuakeDir, node:SCNNode){
        if(nextSuakePart == .rightToLeft){
            if(newDir == .RIGHT){
                _ = self.initNodeRotation(node: node, dir: .DOWN)
            }else if(newDir == .DOWN){
                _ = self.initNodeRotation(node: node, dir: .LEFT)
            }else if(newDir == .LEFT){
                _ = self.initNodeRotation(node: node, dir: .UP)
            }else if(newDir == .UP){
                _ = self.initNodeRotation(node: node, dir: .RIGHT)
            }else{
                _ = self.initNodeRotation(node: node, dir: .UP)
            }
//            self.game.showDbgMsg(dbgMsg: "RONTATING (nextSuakePart == .rightToLeft): " + newDir.rawValue, dbgLevel: .Info)
        }else if(nextSuakePart == .leftToRight){
//                    self.currentSuakePart = nextSuakePart
            if(newDir == .UP){
                _ = self.initNodeRotation(node: node, dir: .LEFT)
            }else if(newDir == .DOWN){
                _ = self.initNodeRotation(node: node, dir: .RIGHT)
            }else if(newDir == .LEFT){
                _ = self.initNodeRotation(node: node, dir: .DOWN)
            }else if(newDir == .RIGHT){
                _ = self.initNodeRotation(node: node, dir: .UP)
            }
//            self.game.showDbgMsg(dbgMsg: "RONTATING (nextSuakePart == .leftToRight): " + newDir.rawValue, dbgLevel: .Info)
        }else if(nextSuakePart == .rightToRight){
            if(newDir == .DOWN){
                _ = self.initNodeRotation(node: node, dir: .RIGHT)
            }else if(newDir == .LEFT){
                _ = self.initNodeRotation(node: node, dir: .DOWN)
            }else if(newDir == .RIGHT){
                _ = self.initNodeRotation(node: node, dir: .UP)
            }else if(newDir == .UP){
                _ = self.initNodeRotation(node: node, dir: .LEFT)
            }
//            self.game.showDbgMsg(dbgMsg: "RONTATING (nextSuakePart == .rightToRight): " + newDir.rawValue, dbgLevel: .Info)
        }else if(nextSuakePart == .leftToLeft){
            if(newDir == .DOWN){
                _ = self.initNodeRotation(node: node, dir: .LEFT)
            }else if(newDir == .LEFT){
                _ = self.initNodeRotation(node: node, dir: .UP)
            }else if(newDir == .RIGHT){
                _ = self.initNodeRotation(node: node, dir: .DOWN)
            }else if(newDir == .UP){
                _ = self.initNodeRotation(node: node, dir: .RIGHT)
            }
//            self.game.showDbgMsg(dbgMsg: "RONTATING (nextSuakePart == .leftToLeft): " + newDir.rawValue, dbgLevel: .Info)
        }
    }
    
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
    
    public static func getNewSuakeParts(suakeEntity:SuakeOppPlayerEntity, newTurnDir:TurnDir, currentSuakePart:SuakePart)->NewSuakePartComponentStruct{
        
        var componentRet:NewSuakePartComponentStruct = NewSuakePartComponentStruct()
        
        if(currentSuakePart == .straightToRight && newTurnDir == .Right ||
            currentSuakePart == .rightToRight && newTurnDir == .Right ||
            currentSuakePart == .leftToRight && newTurnDir == .Right){
            componentRet.nextSuakePart = .rightToRight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeRight2RightComponent// .component(ofType: SuakePlayerComponentRightToRight.self)!
        }else if(currentSuakePart == .straightToLeft && newTurnDir == .Left ||
                    currentSuakePart == .rightToLeft && newTurnDir == .Left ||
                    currentSuakePart == .leftToLeft && newTurnDir == .Left){
            componentRet.nextSuakePart = .leftToLeft
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeLeft2LeftComponent//.component(ofType: SuakePlayerComponentLeftToLeft.self)!
        }else if(currentSuakePart == .straightToStraight && newTurnDir == .Left ||
                    currentSuakePart == .rightToStraight && newTurnDir == .Left ||
                    currentSuakePart == .leftToStraight && newTurnDir == .Left){
            componentRet.nextSuakePart = .straightToLeft
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeStraight2LeftComponent//.component(ofType: SuakePlayerComponentStraightToLeft.self)!
        }else if(currentSuakePart == .straightToStraight && newTurnDir == .Right ||
                    currentSuakePart == .leftToStraight && newTurnDir == .Right ||
                    currentSuakePart == .rightToStraight && newTurnDir == .Right ){
            componentRet.nextSuakePart = .straightToRight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeStraight2RightComponent//.component(ofType: SuakePlayerComponentStraightToRight.self)!
        }else if(currentSuakePart == .straightToRight && newTurnDir == .Left ||
                    currentSuakePart == .leftToRight && newTurnDir == .Left ||
                    currentSuakePart == .rightToRight && newTurnDir == .Left){
            componentRet.nextSuakePart = .rightToLeft
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeRight2LeftComponent//.component(ofType: SuakePlayerComponentRightToLeft.self)!
        }else if(currentSuakePart == .straightToLeft && newTurnDir == .Right ||
                    currentSuakePart == .rightToLeft && newTurnDir == .Right ||
                    currentSuakePart == .leftToLeft && newTurnDir == .Right){
            componentRet.nextSuakePart = .leftToRight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeLeft2RightComponent//.component(ofType: SuakePlayerComponentLeftToRight.self)!
        }else if(currentSuakePart == .rightToLeft && newTurnDir == .Straight ||
                    currentSuakePart == .leftToLeft && newTurnDir == .Straight ||
                    currentSuakePart == .rightToLeft && newTurnDir == .Straight){
            componentRet.nextSuakePart = .leftToStraight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeLeft2StraightComponent//.component(ofType: SuakePlayerComponentLeftToStraight.self)!
        }else if(currentSuakePart == .leftToRight && newTurnDir == .Straight ||
                    currentSuakePart == .rightToRight && newTurnDir == .Straight ||
                    currentSuakePart == .straightToRight && newTurnDir == .Straight){
            componentRet.nextSuakePart = .rightToStraight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeRight2StraightComponent//.component(ofType: SuakePlayerComponentRightToStraight.self)!
        }else if(currentSuakePart == .straightToStraight && newTurnDir == .Straight ||
                    currentSuakePart == .rightToStraight && newTurnDir == .Straight ||
                    currentSuakePart == .leftToStraight && newTurnDir == .Straight){
            componentRet.nextSuakePart = .straightToStraight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeStraight2StraightComponent//.component(ofType: SuakePlayerComponentStraight.self)!
        }else if(currentSuakePart == .rightToRight && newTurnDir == .Straight ||
                    currentSuakePart == .straightToRight && newTurnDir == .Straight ||
                    currentSuakePart == .leftToRight && newTurnDir == .Straight){
            componentRet.nextSuakePart = .rightToStraight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeRight2StraightComponent//.component(ofType: SuakePlayerComponentRightToStraight.self)!
        }else if(currentSuakePart == .straightToLeft && newTurnDir == .Straight ||
                    currentSuakePart == .rightToLeft && newTurnDir == .Straight ||
                    currentSuakePart == .leftToLeft && newTurnDir == .Straight){
            componentRet.nextSuakePart = .leftToStraight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeLeft2StraightComponent//.component(ofType: SuakePlayerComponentLeftToStraight.self)!
        }
        return componentRet
    }
}
