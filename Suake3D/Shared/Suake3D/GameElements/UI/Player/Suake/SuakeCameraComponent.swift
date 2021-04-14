//
//  SuakeCameraComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 13.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class SuakeCameraComponent: SuakeBaseComponent {
    
    var cameraNode:SCNNode!
    var cameraNodeFP:SCNNode!
    
//    let cameraType:CameraView
    let cameraViewType:CameraViewType
    var playerType:SuakePlayerType!
    
    init(game: GameController, playerType:SuakePlayerType){
        
        self.playerType = playerType
//        self.cameraType = (playerType == .OwnSuake ? .Own3rdPerson : .Opp3rdPerson)
        self.cameraViewType = (playerType == .OwnSuake ? .ThirdPerson : .FirstPerson)
        
        if(self.playerType == .OwnSuake){
            self.cameraNode = game.cameraHelper.cameraNode
            self.cameraNodeFP = game.cameraHelper.cameraNodeFP
        }else{
            self.cameraNode = game.cameraHelper.cameraNodeOpp
            self.cameraNodeFP = game.cameraHelper.cameraNodeFPOpp
        }
        super.init(game: game)
    }
    
    func moveFollowCamera(turnDir:TurnDir = .Straight, duration:TimeInterval = 1.0, moveDifference:CGFloat = SuakeVars.fieldSize){
        
//        let moveDifference:CGFloat = SuakeVars.fieldSize
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
        
        if let playerEntity = self.entity{
            let suakePlayerEntity = (playerEntity as! SuakePlayerEntity)
            let suakeDir:SuakeDir = suakePlayerEntity.dir
            if(suakeDir == .UP){
                cameraNode.transform = SCNMatrix4MakeRotation(CGFloat(Double.pi) * 1.0, 0.0, -1.0, 0.0)
                if(turnDir == .Left){
                    setFollowCameraPos(newPos: SCNVector3(suakePlayerEntity.position.x - moveDifference, 45, suakePlayerEntity.position.z - SuakeVars.cameraDist))
                }else if(turnDir == .Right){
                    setFollowCameraPos(newPos: SCNVector3(suakePlayerEntity.position.x + moveDifference, 45, suakePlayerEntity.position.z - SuakeVars.cameraDist))
                }else{
                    setFollowCameraPos(newPos: SCNVector3(suakePlayerEntity.position.x, 45, suakePlayerEntity.position.z - SuakeVars.cameraDist + moveDifference))
                }
            }else if(suakeDir == .DOWN){
                cameraNode.transform = SCNMatrix4MakeRotation(0.0, 0.0, -1.0, 0.0)
                if(turnDir == .Left){
                    setFollowCameraPos(newPos: SCNVector3(suakePlayerEntity.position.x + moveDifference, 45, suakePlayerEntity.position.z + SuakeVars.cameraDist))
                }else if(turnDir == .Right){
                    setFollowCameraPos(newPos: SCNVector3(suakePlayerEntity.position.x - moveDifference, 45, suakePlayerEntity.position.z + SuakeVars.cameraDist))
                }else{
                    setFollowCameraPos(newPos: SCNVector3(suakePlayerEntity.position.x, 45, suakePlayerEntity.position.z + SuakeVars.cameraDist - moveDifference))
                }
            }else if(suakeDir == .LEFT){
                cameraNode.transform = SCNMatrix4MakeRotation(CGFloat(Double.pi) * 0.5, 0.0, -1.0, 0.0)
                if(turnDir == .Left){
                    setFollowCameraPos(newPos: SCNVector3(suakePlayerEntity.position.x - SuakeVars.cameraDist, 45, suakePlayerEntity.position.z + moveDifference))
                }else if(turnDir == .Right){
                    setFollowCameraPos(newPos: SCNVector3(suakePlayerEntity.position.x - SuakeVars.cameraDist, 45, suakePlayerEntity.position.z - moveDifference))
                }else{
                    setFollowCameraPos(newPos: SCNVector3(suakePlayerEntity.position.x - SuakeVars.cameraDist + moveDifference, 45, suakePlayerEntity.position.z))
                }
            }else if(suakeDir == .RIGHT){
                cameraNode.transform = SCNMatrix4MakeRotation(CGFloat(Double.pi) * -0.5, 0.0, -1.0, 0.0)
                if(turnDir == .Left){
                    setFollowCameraPos(newPos: SCNVector3(suakePlayerEntity.position.x + SuakeVars.cameraDist, 45, suakePlayerEntity.position.z - moveDifference))
                }else if(turnDir == .Right){
                    setFollowCameraPos(newPos: SCNVector3(suakePlayerEntity.position.x + SuakeVars.cameraDist, 45, suakePlayerEntity.position.z + moveDifference))
                }else{
                    setFollowCameraPos(newPos: SCNVector3(suakePlayerEntity.position.x + SuakeVars.cameraDist - moveDifference, 45, suakePlayerEntity.position.z))
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
    
    func moveRotateFPCamera(duration:TimeInterval = 1.0, turnDir:TurnDir = .Straight, beamed:Bool = false, moveDifference:CGFloat = SuakeVars.fieldSize){
        
        if let playerEntity = self.entity{
            let suakePlayerEntity = (playerEntity as! SuakePlayerEntity)
            
            var yReset:CGFloat = 0.0
            switch suakePlayerEntity.dir {
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
            
            self.cameraNodeFP.runAction(SCNAction.rotateTo(x: 0, y: yReset, z: 0, duration: duration, usesShortestUnitArc: true), completionHandler: {
                
            })
            SCNTransaction.begin()
            SCNTransaction.animationDuration = duration
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            
            if(suakePlayerEntity.dirOld == .UP){
                if(turnDir == .Left){
                    self.cameraNodeFP.position.z = suakePlayerEntity.position.z + moveDifference
                    self.cameraNodeFP.position.x = suakePlayerEntity.position.x + SuakeVars.cameraFPAhead
                }else if(turnDir == .Right){
                    self.cameraNodeFP.position.z = suakePlayerEntity.position.z + moveDifference
                    self.cameraNodeFP.position.x = suakePlayerEntity.position.x - SuakeVars.cameraFPAhead
                }else{
                    self.cameraNodeFP.position.z = suakePlayerEntity.position.z + (beamed ? 0 : moveDifference) + SuakeVars.cameraFPAhead
                    self.cameraNodeFP.position.x = suakePlayerEntity.position.x
                }
            }else if(suakePlayerEntity.dirOld == .DOWN){
                if(turnDir == .Left){
                    self.cameraNodeFP.position.z = suakePlayerEntity.position.z - moveDifference
                    self.cameraNodeFP.position.x = suakePlayerEntity.position.x - SuakeVars.cameraFPAhead
                }else if(turnDir == .Right){
                    self.cameraNodeFP.position.z = suakePlayerEntity.position.z - moveDifference
                    self.cameraNodeFP.position.x = suakePlayerEntity.position.x + SuakeVars.cameraFPAhead
                }else{
                    self.cameraNodeFP.position.z = suakePlayerEntity.position.z - moveDifference - SuakeVars.cameraFPAhead
                    self.cameraNodeFP.position.x = suakePlayerEntity.position.x
                }
            }else if(suakePlayerEntity.dirOld == .LEFT){
                if(turnDir == .Left){
                    self.cameraNodeFP.position.x = suakePlayerEntity.position.x + moveDifference
                    self.cameraNodeFP.position.z = suakePlayerEntity.position.z - SuakeVars.cameraFPAhead
                }else if(turnDir == .Right){
                    self.cameraNodeFP.position.x = suakePlayerEntity.position.x + moveDifference
                    self.cameraNodeFP.position.z = suakePlayerEntity.position.z + SuakeVars.cameraFPAhead
                }else{
                    self.cameraNodeFP.position.x = suakePlayerEntity.position.x + moveDifference + SuakeVars.cameraFPAhead
                    self.cameraNodeFP.position.z = suakePlayerEntity.position.z
                }
            }else if(suakePlayerEntity.dirOld == .RIGHT){
                if(turnDir == .Left){
                    self.cameraNodeFP.position.x = suakePlayerEntity.position.x - moveDifference
                    self.cameraNodeFP.position.z = suakePlayerEntity.position.z + SuakeVars.cameraFPAhead
                }else if(turnDir == .Right){
                    self.cameraNodeFP.position.x = suakePlayerEntity.position.x - moveDifference
                    self.cameraNodeFP.position.z = suakePlayerEntity.position.z - SuakeVars.cameraFPAhead
                }else{
                    self.cameraNodeFP.position.x = suakePlayerEntity.position.x - moveDifference - SuakeVars.cameraFPAhead
                    self.cameraNodeFP.position.z = suakePlayerEntity.position.z
                }
            }
            self.cameraNodeFP.position.y = 8
            SCNTransaction.commit()
//            if(self.cameraViewType == .FirstPerson){
//                print("MoveRotateFPCamera (2) pos: \(self.cameraNodeFP.position)")
//            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
