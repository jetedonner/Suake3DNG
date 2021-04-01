//
//  SuakeCameraComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 13.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeCameraComponent: SuakeBaseComponent {
    
    var cameraNode:SCNNode!
    var cameraNodeFP:SCNNode!
    let cameraType:CameraView
    
    init(game: GameController, cameraType:CameraView){
        self.cameraNode = game.cameraHelper.cameraNode
        self.cameraType = cameraType
        if(cameraType == .Own3rdPerson){
            self.cameraNode = game.cameraHelper.cameraNode
            self.cameraNodeFP = game.cameraHelper.cameraNodeFP
        }else if(cameraType == .Own1stPerson){
            self.cameraNode = game.cameraHelper.cameraNode
            self.cameraNodeFP = game.cameraHelper.cameraNodeFP
        }/*else if(cameraType == .Opp3rdPerson){
            self.cameraNode = game.cameraHelper.cameraNodeOpp
        }else if(cameraType == .Opp1stPerson){
            self.cameraNode = game.cameraHelper.cameraNodeFPOpp
        }*/
        super.init(game: game)
    }
    
    func moveFollowCamera(turnDir:TurnDir = .Straight, duration:TimeInterval = 1.0){
        
        let moveDifference:CGFloat = SuakeVars.fieldSize
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        SCNTransaction.completionBlock = {
            let gameBoardSize =  self.game.levelManager.currentLevel.levelConfigEnv.levelSize.getNSSize()
            if(self.cameraNode.position.z >= ((gameBoardSize.height * SuakeVars.fieldSize) / 2) ||
                self.cameraNode.position.z < ((gameBoardSize.height * SuakeVars.fieldSize) / -2) ||
                self.cameraNode.position.x >= ((gameBoardSize.width * SuakeVars.fieldSize) / 2) ||
                self.cameraNode.position.x < ((gameBoardSize.width * SuakeVars.fieldSize) / -2)){
            }else{
                self.game.levelManager.wallManager.wallFactory.wallGrp.runAction(SCNAction.fadeIn(duration: 0.1))
                self.game.levelManager.wallManager.wallFactory.wallGrpUpper.runAction(SCNAction.fadeIn(duration: 0.1))
                self.game.levelManager.wallManager.wallFactory.wallGrpLower.runAction(SCNAction.fadeIn(duration: 0.1))
                self.game.levelManager.wallManager.wallFactory.wallGrpLeft.runAction(SCNAction.fadeIn(duration: 0.1))
                self.game.levelManager.wallManager.wallFactory.wallGrpRight.runAction(SCNAction.fadeIn(duration: 0.1))
            }
        }
        
        if(turnDir != .Straight){
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
        
        if let ownEntity = self.entity{
            let ownPlayerEntity = (ownEntity as! SuakePlayerEntity)
            let testDir:SuakeDir = ownPlayerEntity.dir
            if(testDir == .UP){
                if(turnDir == .Left){
                    cameraNode.transform = SCNMatrix4MakeRotation(CGFloat(Double.pi) * 1.0, 0.0, -1.0, 0.0)
                    setFollowCameraPos(newPos: SCNVector3(ownPlayerEntity.position.x - moveDifference, 45, ownPlayerEntity.position.z - SuakeVars.cameraDist))
                }else if(turnDir == .Right){
                    cameraNode.transform = SCNMatrix4MakeRotation(CGFloat(Double.pi) * 1.0, 0.0, -1.0, 0.0)
                    setFollowCameraPos(newPos: SCNVector3(ownPlayerEntity.position.x + moveDifference, 45, ownPlayerEntity.position.z - SuakeVars.cameraDist))
                }else{
                    setFollowCameraPos(newPos: SCNVector3(ownPlayerEntity.position.x, 45, ownPlayerEntity.position.z - SuakeVars.cameraDist + moveDifference))
                }
            }else if(testDir == .DOWN){
                if(turnDir == .Left){
                    cameraNode.transform = SCNMatrix4MakeRotation(0.0, 0.0, -1.0, 0.0)
                    setFollowCameraPos(newPos: SCNVector3(ownPlayerEntity.position.x + moveDifference, 45, ownPlayerEntity.position.z + SuakeVars.cameraDist))
                }else if(turnDir == .Right){
                    cameraNode.transform = SCNMatrix4MakeRotation(0.0, 0.0, -1.0, 0.0)
                    setFollowCameraPos(newPos: SCNVector3(ownPlayerEntity.position.x - moveDifference, 45, ownPlayerEntity.position.z + SuakeVars.cameraDist))
                }else{
                    setFollowCameraPos(newPos: SCNVector3(ownPlayerEntity.position.x, 45, ownPlayerEntity.position.z + SuakeVars.cameraDist - moveDifference))
                }
            }else if(testDir == .LEFT){
                if(turnDir == .Left){
                    cameraNode.transform = SCNMatrix4MakeRotation(CGFloat(Double.pi) * 0.5, 0.0, -1.0, 0.0)
                    setFollowCameraPos(newPos: SCNVector3(ownPlayerEntity.position.x - SuakeVars.cameraDist, 45, ownPlayerEntity.position.z + moveDifference))
                }else if(turnDir == .Right){
                    cameraNode.transform = SCNMatrix4MakeRotation(CGFloat(Double.pi) * 0.5, 0.0, -1.0, 0.0)
                    setFollowCameraPos(newPos: SCNVector3(ownPlayerEntity.position.x - SuakeVars.cameraDist, 45, ownPlayerEntity.position.z - moveDifference))
                }else{
                    setFollowCameraPos(newPos: SCNVector3(ownPlayerEntity.position.x - SuakeVars.cameraDist + moveDifference, 45, ownPlayerEntity.position.z))
                }
            }else if(testDir == .RIGHT){
                if(turnDir == .Left){
                    cameraNode.transform = SCNMatrix4MakeRotation(CGFloat(Double.pi) * -0.5, 0.0, -1.0, 0.0)
                    setFollowCameraPos(newPos: SCNVector3(ownPlayerEntity.position.x + SuakeVars.cameraDist, 45, ownPlayerEntity.position.z - moveDifference))
                }else if(turnDir == .Right){
                    cameraNode.transform = SCNMatrix4MakeRotation(CGFloat(Double.pi) * -0.5, 0.0, -1.0, 0.0)
                    setFollowCameraPos(newPos: SCNVector3(ownPlayerEntity.position.x + SuakeVars.cameraDist, 45, ownPlayerEntity.position.z + moveDifference))
                }else{
                    setFollowCameraPos(newPos: SCNVector3(ownPlayerEntity.position.x + SuakeVars.cameraDist - moveDifference, 45, ownPlayerEntity.position.z))
                }
            }
        }
        SCNTransaction.commit()
    }
    
    
    func setFollowCameraPos(newPos:SCNVector3){
        self.cameraNode.position = newPos
        let gameBoardSize = self.game.levelManager.currentLevel.levelConfigEnv.levelSize.getNSSize()
        if(self.cameraNode.position.z < ((gameBoardSize.height * SuakeVars.fieldSize) / -2)){
            self.game.levelManager.wallManager.wallFactory.wallGrpLower.runAction(SCNAction.fadeOut(duration: 0.15))
        }else if(self.cameraNode.position.z >= ((gameBoardSize.height * SuakeVars.fieldSize) / 2)){
            self.game.levelManager.wallManager.wallFactory.wallGrpUpper.runAction(SCNAction.fadeOut(duration: 0.15))
        }else if(self.cameraNode.position.x >= ((gameBoardSize.width * SuakeVars.fieldSize) / 2)){
            self.game.levelManager.wallManager.wallFactory.wallGrpLeft.runAction(SCNAction.fadeOut(duration: 0.15))
        }else if(self.cameraNode.position.x < ((gameBoardSize.width * SuakeVars.fieldSize) / -2)){
            self.game.levelManager.wallManager.wallFactory.wallGrpRight.runAction(SCNAction.fadeOut(duration: 0.15))
        }
    }
    
    var currRotation:CGFloat = 0.0
    var currFullRotations:Int = 0
    
    func moveRotateFPCamera(duration:TimeInterval = 1.0, turnDir:TurnDir = .Straight, beamed:Bool = false){
        
        if let ownEntity = self.entity{
            let ownPlayerEntity = (ownEntity as! SuakePlayerEntity)
            
            let rotationMultiplyer:CGFloat = 0.0
            var yReset:CGFloat = 0.0
            switch ownPlayerEntity.dir {
            case .UP:
                yReset = CGFloat.pi
            case .LEFT:
                yReset = CGFloat.pi / -2
            case .RIGHT:
                yReset = CGFloat.pi / 2
            case .DOWN:
                yReset = 0
            default:
                yReset = 0.0
            }
            let rotateBy:CGFloat = CGFloat.pi * rotationMultiplyer
            self.currRotation += rotateBy
            
            self.currFullRotations = Int(self.currRotation / CGFloat.pi)
            self.cameraNodeFP.runAction(SCNAction.rotateTo(x: 0, y: yReset, z: 0, duration: duration, usesShortestUnitArc: true), completionHandler: {
                
            })
            SCNTransaction.begin()
            SCNTransaction.animationDuration = duration
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            
            if(ownPlayerEntity.dirOld == .UP){
                if(turnDir == .Left){
                    self.cameraNodeFP.position.z = ownPlayerEntity.position.z + SuakeVars.fieldSize
                    self.cameraNodeFP.position.x = ownPlayerEntity.position.x + SuakeVars.cameraFPAhead
                }else if(turnDir == .Right){
                    self.cameraNodeFP.position.z = ownPlayerEntity.position.z + SuakeVars.fieldSize
                    self.cameraNodeFP.position.x = ownPlayerEntity.position.x - SuakeVars.cameraFPAhead
                }else{
                    self.cameraNodeFP.position.z = ownPlayerEntity.position.z + (beamed ? 0 : SuakeVars.fieldSize) + SuakeVars.cameraFPAhead
                    self.cameraNodeFP.position.x = ownPlayerEntity.position.x
                }
            }else if(ownPlayerEntity.dirOld == .DOWN){
                if(turnDir == .Left){
                    self.cameraNodeFP.position.z = ownPlayerEntity.position.z - SuakeVars.fieldSize
                    self.cameraNodeFP.position.x = ownPlayerEntity.position.x - SuakeVars.cameraFPAhead
                }else if(turnDir == .Right){
                    self.cameraNodeFP.position.z = ownPlayerEntity.position.z - SuakeVars.fieldSize
                    self.cameraNodeFP.position.x = ownPlayerEntity.position.x + SuakeVars.cameraFPAhead
                }else{
                    self.cameraNodeFP.position.z = ownPlayerEntity.position.z - SuakeVars.fieldSize - SuakeVars.cameraFPAhead
                    self.cameraNodeFP.position.x = ownPlayerEntity.position.x
                }
            }else if(ownPlayerEntity.dirOld == .LEFT){
                if(turnDir == .Left){
                    self.cameraNodeFP.position.x = ownPlayerEntity.position.x + SuakeVars.fieldSize
                    self.cameraNodeFP.position.z = ownPlayerEntity.position.z - SuakeVars.cameraFPAhead
                }else if(turnDir == .Right){
                    self.cameraNodeFP.position.x = ownPlayerEntity.position.x + SuakeVars.fieldSize
                    self.cameraNodeFP.position.z = ownPlayerEntity.position.z + SuakeVars.cameraFPAhead
                }else{
                    self.cameraNodeFP.position.x = ownPlayerEntity.position.x + SuakeVars.fieldSize + SuakeVars.cameraFPAhead
                    self.cameraNodeFP.position.z = ownPlayerEntity.position.z
                }
            }else if(ownPlayerEntity.dirOld == .RIGHT){
                if(turnDir == .Left){
                    self.cameraNodeFP.position.x = ownPlayerEntity.position.x - SuakeVars.fieldSize
                    self.cameraNodeFP.position.z = ownPlayerEntity.position.z + SuakeVars.cameraFPAhead
                }else if(turnDir == .Right){
                    self.cameraNodeFP.position.x = ownPlayerEntity.position.x - SuakeVars.fieldSize
                    self.cameraNodeFP.position.z = ownPlayerEntity.position.z - SuakeVars.cameraFPAhead
                }else{
                    self.cameraNodeFP.position.x = ownPlayerEntity.position.x - SuakeVars.fieldSize - SuakeVars.cameraFPAhead
                    self.cameraNodeFP.position.z = ownPlayerEntity.position.z
                }
            }
            self.cameraNodeFP.position.y = 8
            SCNTransaction.commit()
            if(self.cameraType == .Own1stPerson){
                print("MoveRotateFPCamera (2) pos: \(self.cameraNodeFP.position)")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
