//
//  WormHoleHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import SceneKit.ModelIO // This is NEEDED for: SCNCamera(mdlCamera: mdl)

class WormHoleHelper:SuakeGameClass{
    
    var starsParticeSystem:SCNParticleSystem!
    var starsParticeSystem2:SCNParticleSystem!
    var starsParticeSystemNode2:SCNNode!
    
    var cameraNodeWormHole:SCNNode!
    
    var newView:SCNView!
    var newScene:SCNScene = SCNScene()
    var playerType:SuakePlayerType!
    
    var beamProcessStarted:TimeInterval = 0
    
    override init(game:GameController){
        super.init(game: game)
        self.setupCameraWormHole()
    }
    
    func setupCameraWormHole(){
        cameraNodeWormHole = SCNNode()
        cameraNodeWormHole.name = "Camera - WormHole"
        self.game.cameraHelper.cameraGroupNode.addChildNode(cameraNodeWormHole)
        let mdl:MDLCamera = MDLCamera()
        mdl.barrelDistortion = 0.5
        mdl.fisheyeDistortion = 0.2
        cameraNodeWormHole.camera = SCNCamera(mdlCamera: mdl)
        cameraNodeWormHole.position = SCNVector3Make(0, 0, 14)

        starsParticeSystem = SCNParticleSystem(named: "Stars", inDirectory: SuakeVars.DIR_PARTICLES)!
        starsParticeSystem2 = SCNParticleSystem(named: "PortalScene", inDirectory: SuakeVars.DIR_PARTICLES)!
        self.starsParticeSystemNode2 = SCNNode()
        self.starsParticeSystemNode2.addParticleSystem(self.starsParticeSystem2)

        self.newScene.rootNode.addParticleSystem(self.starsParticeSystem)
        self.newScene.rootNode.addChildNode(self.starsParticeSystemNode2)
        self.newView = SCNView(frame: ((self.game.scnView as! GameViewMacOS).viewController?.view.frame)!)
        self.newView.scene = self.newScene
        self.newView.scene?.isPaused = true
        self.newView.backgroundColor = .black
        self.newView.pointOfView = self.cameraNodeWormHole
        self.newView.isPlaying = false
        self.newView.isHidden = true
    }
    
    func enterWormHole(playerType:SuakePlayerType){
        self.showWormHole(playerType: playerType)
    }
    
    var endPos:SCNVector3!
    
    func showWormHole(playerType:SuakePlayerType, endPos:SCNVector3! = nil, show:Bool = true){
        self.playerType = playerType
        if(endPos != nil){
            self.endPos = endPos
        }
        
            DispatchQueue.main.async {
                if(show){
                self.beamProcessStarted = CACurrentMediaTime()
//                if(playerType == .OwnSuake || DbgVars.startLoad_Opponent_Dbg_AI){
                    if(self.game.scene.background.contents is [String]){
                        let bgImg:String = (self.game.scene.background.contents as! [String])[4]
                        self.newScene.background.contents = bgImg
                    }else{
                        self.newScene.background.contents = NSColor.black
                    }
//                }
//                if(playerType == .OwnSuake){
//                    self.game.playerEntityManager.getOwnPlayerEntity().isBeaming = true
//                    self.game.playerEntityManager.getOwnPlayerEntity().statsHelper.addStatsValue2Score(statsType: .teleportations, value: 200)
//
//                }else if(playerType == .OppSuake){
//                    self.game.playerEntityManager.getOppPlayerEntity()!.isBeaming = true
//                    self.game.playerEntityManager.oppPlayerEntity.isPaused = true
//                    self.game.playerEntityManager.getOppPlayerEntity()!.statsHelper.addStatsValue2Score(statsType: .teleportations, value: 200)
//                }
//                //self.game.overlayManager.hud.hudEntity.setScore(score: self.game.playerEntityManager.getOwnPlayerEntity().stats.score)
//                if(self.playerType == .OwnSuake || DbgVars.startLoad_Opponent_Dbg_AI){
                    self.moveWormHoleRingsRnd()
//                }else if(self.playerType == .OppSuake && !DbgVars.startLoad_Opponent_Dbg_AI){
////                    self.game.playerEntityManager.getOppPlayerEntity()!.isPaused = true
//                    self.game.playerEntityManager.getOppPlayerEntity()!.currentSuakeComponent.node.runAction(SCNAction.wait(duration: SuakeVars.wormHolePortationDuration), completionHandler: {
//                        self.game.playerEntityManager.getOppPlayerEntity()!.isPaused = false
//                        self.showWormHole(show: false, playerType: .OppSuake)
//                    })
//                }
//                self.newView.pointOfView = self.cameraNodeWormHole
            
                self.game.scnView.scene = self.newScene
                self.game.scnView.pointOfView = self.cameraNodeWormHole
            }else{
                self.starsParticeSystemNode2.removeAllAnimations()
                self.game.scnView.scene = self.game.scene
                if(self.game.cameraHelper.fpv){
                    self.game.scnView.pointOfView = self.game.cameraHelper.cameraNodeFP
                }else{
                    self.game.scnView.pointOfView = self.game.cameraHelper.cameraNode
                }
                self.game.playerEntityManager.ownPlayerEntity._pos = self.endPos
                self.newView.removeFromSuperview()
            }
                    
            if(self.playerType == .OwnSuake/* || DbgVars.startLoad_Opponent_Dbg_AI*/){
                
                self.newView.isHidden = !show
                self.newView.isPlaying = show
                self.newScene.isPaused = !show
                self.game.overlayManager.hud.overlayScene.isHidden = show
            }
        }
    }
    
    

    func moveWormHoleRingsRnd() {
        let animGrp:CAAnimationGroup = CAAnimationGroup()
        let anim:CABasicAnimation = self.createAnimation(keyPath: "position.x", toValue: Int.random(in: -5..<5))
        let anim2:CABasicAnimation = self.createAnimation(keyPath: "position.y", toValue: Int.random(in: -5..<5))
        animGrp.animations = [anim, anim2]
        animGrp.delegate = self
        self.starsParticeSystemNode2.addAnimation(animGrp, forKey: "animation")
    }

    func createAnimation(keyPath:String, toValue:Int)->CABasicAnimation{
        let anim:CABasicAnimation = CABasicAnimation(keyPath: keyPath)
        anim.toValue = toValue
        anim.duration = 0.25
        return anim
    }
}

extension WormHoleHelper: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
    
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if(CACurrentMediaTime() - self.beamProcessStarted < SuakeVars.wormHolePortationDuration){
            self.moveWormHoleRingsRnd()
        }else{
            self.showWormHole(playerType: self.playerType, show: false)
            if(self.playerType == .OwnSuake){
                
                self.game.playerEntityManager.ownPlayerEntity.cameraComponent.moveFollowCamera(turnDir: .Straight, duration: 0.0)
                
//                self.game.playerEntityManager.ownPlayerEntity.cameraComponent.moveRotateFPCamera(duration: animDuration, turnDir: newTurnDir)
            }
        }
        
    }
}

