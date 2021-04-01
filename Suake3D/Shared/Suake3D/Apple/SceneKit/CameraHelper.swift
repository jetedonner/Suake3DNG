//
//  CameraHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 11.03.21.
//

import Foundation
import SceneKit


class CameraHelper: SuakeGameClass {
    
    var cameraGroupNode:SCNNode = SCNNode()
    var cameraNode:SCNNode = SCNNode()
    var cameraNodeFP:SCNNode = SCNNode()
    
    var cameraNodeOpp:SCNNode = SCNNode()
    var cameraNodeFPOpp:SCNNode = SCNNode()
    
    var fpv:Bool = false
    var animatingFPV:Bool = false
    
    var blurVision:BlurVision = .BlurOff
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func initCameras(){
        cameraGroupNode.name = "CameraGroup"
        
        cameraNode = self.game.scene.rootNode.childNode(withName: "ownCamera3rd", recursively: true)!
        cameraNode.removeFromParentNode()
        cameraNode.name = "ownCamera3rd"
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zFar = 4600.0
        cameraNode.camera?.zNear = 0.111
        cameraNode.camera?.focusDistance = 0.025
        cameraNode.transform = SCNMatrix4MakeRotation(CGFloat(Double.pi) * 1.0, 0.0, -1.0, 0.0)
        cameraNode.position = SCNVector3(0, 45, -190)
        
        cameraGroupNode.addChildNode(cameraNode)
        
        cameraNodeFP.camera = SCNCamera()
        cameraNodeFP.name = "ownCamera1st"
        
        cameraNodeFP.camera?.zFar = (cameraNode.camera?.zFar)!
        cameraNodeFP.camera?.zNear = (cameraNode.camera?.zNear)!
        cameraNodeFP.camera?.fieldOfView = (cameraNode.camera?.fieldOfView)!
        cameraNodeFP.camera?.focalLength = (cameraNode.camera?.focalLength)!
        cameraNodeFP.camera?.focusDistance = (cameraNode.camera?.focusDistance)!
        cameraNodeFP.transform = SCNMatrix4MakeRotation(CGFloat(Double.pi) * 1.0, 0.0, -1.0, 0.0)
        cameraNodeFP.position = SCNVector3(0, 0, 0)
        cameraNodeFP.position.z += 75.0
        cameraNodeFP.position.y += 12.0
        cameraGroupNode.addChildNode(cameraNodeFP)
        
        if(self.game.usrDefHlpr.loadOpp){
            cameraNodeOpp.camera = SCNCamera()
            cameraNodeOpp.name = "oppCamera3rd"
            cameraNodeOpp.camera?.zFar = 4600.0
            cameraNodeOpp.camera?.zNear = 0.111
            cameraNodeOpp.camera?.focusDistance = 0.025
            cameraNodeOpp.transform = SCNMatrix4MakeRotation(CGFloat(Double.pi) * 1.0, 0.0, -1.0, 0.0)
//            if(DbgVars.startLoad_Enemies && DbgVars.startLoad_Opponent){
    //            cameraNodeOpp.position = self.game.playerEntityManager.getOppPlayerEntity()!.position
                cameraNodeOpp.position = SCNVector3(SuakeVars.oppPos.x * SuakeVars.fieldSize, 45, (SuakeVars.oppPos.z * SuakeVars.fieldSize) - 190) // SCNVector3(-150, 45, -190)
    //            cameraNodeOpp.position.z -= 190
    //            cameraNodeOpp.position.y += 45
                //cameraNodeOpp.eulerAngles.y = 0.0
                cameraGroupNode.addChildNode(cameraNodeOpp)
//            }

            cameraNodeFPOpp.camera = SCNCamera()
            cameraNodeFPOpp.name = "oppCamera1st"

            cameraNodeFPOpp.camera?.zFar = (cameraNodeFP.camera?.zFar)!
            cameraNodeFPOpp.camera?.zNear = (cameraNodeFP.camera?.zNear)!
            cameraNodeFPOpp.camera?.fieldOfView = (cameraNodeFP.camera?.fieldOfView)!
            cameraNodeFPOpp.camera?.focalLength = (cameraNodeFP.camera?.focalLength)!
            cameraNodeFPOpp.camera?.focusDistance = (cameraNodeFP.camera?.focusDistance)!
            cameraNodeFPOpp.transform = SCNMatrix4MakeRotation(CGFloat(Double.pi) * 1.0, 0.0, -1.0, 0.0)
            cameraNodeFPOpp.position = SCNVector3(SuakeVars.oppPos.x * SuakeVars.fieldSize, 0, SuakeVars.oppPos.z * SuakeVars.fieldSize) // SCNVector3(-150, 0, 0)
            cameraNodeFPOpp.position.z += 75.0
            cameraNodeFPOpp.position.y += 12.0
            cameraGroupNode.addChildNode(cameraNodeFPOpp)
        }
        self.game.scnView.pointOfView = self.cameraNode
        
        game.physicsHelper.qeueNode2Add2Scene(node: cameraGroupNode)
        self.allowCameraControl(allow: SuakeVars.initialCameraControl)
    }
    
    func allowCameraControl(allow:AllowCameraControl = .Undefined){
        
        if(allow == .Undefined){
            self.game.scnView.allowsCameraControl = !self.game.scnView.allowsCameraControl
        }else{
            self.game.scnView.allowsCameraControl = (allow == .Allow)
            self.game.scnView.cameraControlConfiguration.panSensitivity = 0.1
            self.game.scnView.cameraControlConfiguration.rotationSensitivity = 0.1
            self.game.scnView.cameraControlConfiguration.truckSensitivity = 0.1
        }
        
        if(!self.game.scnView.allowsCameraControl){
            self.game.showDbgMsg(dbgMsg: SuakeMsgs.camOff, dbgLevel: .Verbose)
        }else{
            self.game.showDbgMsg(dbgMsg: SuakeMsgs.camOn, dbgLevel: .Verbose)
        }
    }
    
    var fpvOpp:Bool = false
    func toggleFPVOpp(){
        toggleFPVOpp(newFPV: !fpvOpp)
    }

    func toggleFPVOpp(newFPV:Bool){
        if(!self.game.usrDefHlpr.loadOpp){
            return
        }
        if(animatingFPV){
            return
        }else{
            self.animatingFPV = true
        }
        if(!newFPV){
            fpvOpp = newFPV
        }
        let oldTransform:SCNMatrix4 = (newFPV ? self.game.cameraHelper.cameraNodeOpp : self.game.cameraHelper.cameraNodeFPOpp).transform
        if(newFPV){
            SCNTransaction.begin()
            SCNTransaction.animationDuration = SuakeVars.switchCameraDuration
            self.game.scnView.pointOfView?.transform = self.cameraNodeFPOpp.transform
            SCNTransaction.completionBlock = {
                self.game.scnView.pointOfView = self.cameraNodeFPOpp
                self.cameraNodeOpp.transform = oldTransform
                self.animatingFPV = false
//                self.game.overlayManager.hud.overlayScene.crosshairEntity.isHidden = false
                self.fpvOpp = newFPV
            }
            SCNTransaction.commit()
            self.game.overlayManager.hud.healthBars[self.game.playerEntityManager.oppPlayerEntity]?.isHidden = true
            MouseHelper.showMouseCursor(show: false)
        }else{
            SCNTransaction.begin()
            SCNTransaction.animationDuration = SuakeVars.switchCameraDuration
            self.game.scnView.pointOfView?.transform = self.cameraNodeOpp.transform
            SCNTransaction.completionBlock = {
                self.game.scnView.pointOfView = self.cameraNodeOpp
                self.cameraNodeFPOpp.transform = oldTransform
                self.animatingFPV = false
                self.game.overlayManager.hud.healthBars[self.game.playerEntityManager.oppPlayerEntity]?.isHidden = false
            }
            SCNTransaction.commit()
//            self.game.overlayManager.hud.overlayScene.crosshairEntity.isHidden = true
            MouseHelper.showMouseCursor()
        }
    }
    
    func toggleFPV(){
        toggleFPV(newFPV: !fpv)
    }
    
    func toggleFPV(newFPV:Bool){
        if(animatingFPV){
            return
        }else{
            self.animatingFPV = true
        }
        if(!newFPV){
            fpv = newFPV
        }
        let oldTransform:SCNMatrix4 = self.game.scnView.pointOfView!.transform
        if(newFPV){
            SCNTransaction.begin()
            SCNTransaction.animationDuration = SuakeVars.switchCameraDuration
            self.game.scnView.pointOfView?.transform = self.cameraNodeFP.transform
            SCNTransaction.completionBlock = {
                self.game.scnView.pointOfView = self.cameraNodeFP
                self.cameraNode.transform = oldTransform
                self.animatingFPV = false
                self.game.overlayManager.hud.overlayScene.crosshairEntity.isHidden = false
                self.fpv = newFPV
            }
            SCNTransaction.commit()
            self.game.overlayManager.hud.healthBars[self.game.playerEntityManager.ownPlayerEntity]?.isHidden = true
            MouseHelper.showMouseCursor(show: false)
        }else{
            SCNTransaction.begin()
            SCNTransaction.animationDuration = SuakeVars.switchCameraDuration
            self.game.scnView.pointOfView?.transform = self.cameraNode.transform
            SCNTransaction.completionBlock = {
                self.game.scnView.pointOfView = self.cameraNode
                self.cameraNodeFP.transform = oldTransform
                self.animatingFPV = false
                self.game.overlayManager.hud.healthBars[self.game.playerEntityManager.ownPlayerEntity]?.isHidden = false
            }
            SCNTransaction.commit()
            self.game.overlayManager.hud.overlayScene.crosshairEntity.isHidden = true
            MouseHelper.showMouseCursor()
        }
    }
    
    func blurVision(blurOn:BlurVision = .Undefined){
       if(blurOn == .Undefined){
           if(self.blurVision == .BlurOff){
               self.blurVision = .BlurOn
            self.game.showDbgMsg(dbgMsg: "BLUR ON", dbgLevel: .Verbose)
           }else{
              self.blurVision = .BlurOff
               self.game.showDbgMsg(dbgMsg: "BLUR OFF", dbgLevel: .Verbose)
           }
       }else{
           self.blurVision = blurOn
           self.game.showDbgMsg(dbgMsg: "BLUR " + blurOn.rawValue, dbgLevel: .Verbose)
       }
       self.setWantsDepthOfField(wants: (self.blurVision == .BlurOn))
       self.game.showDbgMsg(dbgMsg: "BLUR set to: " + self.blurVision.rawValue, dbgLevel: .Verbose)
   }
   
    private func setWantsDepthOfField(wants:Bool){
//        if(!wants){
//            return
//        }
        self.cameraNode.camera?.wantsDepthOfField = wants
//        self.cameraNodeOpp.camera?.wantsDepthOfField = wants
        self.cameraNodeFP.camera?.wantsDepthOfField = wants
//        self.cameraNodeFPOpp.camera?.wantsDepthOfField = wants
        self.game.scnView.pointOfView!.camera?.wantsDepthOfField = wants
        if(wants){
            cameraNode.camera?.focusDistance = 0.5
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.65
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            cameraNode.camera?.focusDistance = 0.095
            SCNTransaction.commit()
        }else{
            cameraNode.camera?.focusDistance = 2.5
        }
   }
    
    func resetCameraView(){
        self.initCameras()
//        if(DbgVars.startLoad_Opponent_Dbg_AI){
//            self.switchToCameraView(cameraView: .Opp3rdPerson)
//        }else{
            self.switchToCameraView(cameraView: .Own3rdPerson)
//        }
    }
    
    func switchToCameraView(cameraView:CameraView, animate:Bool = true){
        var animationDuration:TimeInterval = 0.5
        if(!animate){
            animationDuration = 0.0
        }
        SCNTransaction.begin()
        SCNTransaction.animationDuration = animationDuration
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        if(cameraView == .Opp3rdPerson){
//            self.game.scnView.pointOfView = self.cameraNodeOpp
//        }else if(cameraView == .Opp1stPerson){
//            game.scnView.pointOfView = self.cameraNodeFPOpp
//        }else{
            SCNTransaction.completionBlock = {
//                for i in (0..<self.game.droid.count){
//                    self.game.overlayMgr.hud.updateDroidLblPos(id: self.game.droid[i].id)
//                }
            }
            if(cameraView == .Own3rdPerson){
                game.scnView.pointOfView = self.cameraNode
                self.fpv = false
            }else if(cameraView == .Own1stPerson){
                game.scnView.pointOfView = self.cameraNodeFP
                self.fpv = true
            }
//        }
        SCNTransaction.commit()
        self.game.showDbgMsg(dbgMsg: "Switched to camera: " + cameraView.rawValue)
    }
}
