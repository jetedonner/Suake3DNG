//
//  PhysicsHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

class PhysicsHelper: SuakeGameClass, SCNSceneRendererDelegate {
    
    var currentTime:TimeInterval = 0.0
    var lastUpdateTime:TimeInterval!
    var gameStartTime:TimeInterval!
    var pauseStartTime:TimeInterval!
//    
    var deltaTime:TimeInterval = 0.0
    
    override init(game: GameController) {
        super.init(game: game)
    }
//
    var firstMove:Bool = true
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//         
//        
//        if(self.game.stateMachine.currentState is SuakeStateGameLoading && !self.game.isLoading){
//            self.game.loadGame()
//            return
//        }
//        
        if(!(self.game.stateMachine.currentState is SuakeStatePlaying) && !(self.game.stateMachine.currentState is SuakeStateMultiplayerPlaying)){
            return
        }
//        return
        self.currentTime = time
        if(self.pauseStartTime != nil){
            self.togglePause(time: time)
        }
//        
////        self.game.showDbgMsg(dbgMsg: "START RENDERING", dbgLevel: .Verbose)
        if(self.lastUpdateTime == nil){
            self.lastUpdateTime = time
            self.startTimer(time: time)
        }else{
            self.deltaTime = time - lastUpdateTime
            if(self.deltaTime >= SuakeVars.gameStepInterval){
                self.lastUpdateTime = time
                if(self.game.usrDefHlpr.testOppAI){
                    if let oppPlayerEntity = self.game.playerEntityManager.oppPlayerEntity {
                        oppPlayerEntity.update(deltaTime: self.deltaTime)
                    }
                }else{
                    self.game.playerEntityManager.ownPlayerEntity.moveComponent.inBetweenMove = false
                    if let ownSuakeEntity = self.game.playerEntityManager.ownPlayerEntity {
                        ownSuakeEntity.pos = ownSuakeEntity.moveComponent.posAfterNetSend
                        ownSuakeEntity.update(deltaTime: self.deltaTime)
                    }
                    
                    for droidEntity in self.game.playerEntityManager.droidsNotDead{
                        droidEntity.update(deltaTime: self.deltaTime)
                    }
                    
//                    self.game.overlayManager.hud.overlayScene!.map.movePlayerNodes()
                    self.game.overlayManager.hud.overlayScene!.arrows.showHideHelperArrows()
                }
            }else{
                if(self.game.usrDefHlpr.testOppAI){
                    
                }else{
                    if(self.game.playerEntityManager.ownPlayerEntity != nil && self.game.playerEntityManager.ownPlayerEntity.moveComponent.turnQueue.count > 0 &&
                        self.deltaTime <= 0.64 &&
                        !self.game.playerEntityManager.ownPlayerEntity.moveComponent.inBetweenMove){
                        self.game.playerEntityManager.ownPlayerEntity.pos = self.game.playerEntityManager.ownPlayerEntity.moveComponent.posAfterNetSend
                        self.game.playerEntityManager.ownPlayerEntity.update(deltaTime: deltaTime)
//                        self.game.overlayManager.hud.overlayScene!.map.rotatePlayerNodes(delta: deltaTime)
                    }
                }
            }
            self.game.levelManager.distanceManager.updateDistances()
            self.updateGameTime(time: time)
        }
////        self.game.showDbgMsg(dbgMsg: "STOP RENDERING", dbgLevel: .Verbose)
    }
//    
//    var opponentWaitingForRecalc:Bool = false
//    
//    func updateOpponentSuake(deltaTime:TimeInterval, dbgID:String = "Default"){
//        if let oppEntity:SuakeOppPlayerEntity = self.game.playerEntityManager.getOppPlayerEntity(){
//            if(!oppEntity.died){
//                if(!oppEntity.modeChanged2SeekMedKitAndNotLoaded){
//                    if(self.opponentWaitingForRecalc){
//                        self.opponentWaitingForRecalc = false
//                    }
////                    print("RENDERER-UPDATING OPPONENT ID: " + dbgID)
//                    oppEntity.intelligenceComponent.update(deltaTime: self.deltaTime)
//                }else{
//                    self.opponentWaitingForRecalc = true
//                }
//            }
//        }
//    }
//    
//    func updateDroids(deltaTime:TimeInterval){
//        if(DbgVars.startLoad_Droids && DbgVars.startLoad_Droids_Active){
//            for droidEntity in self.game.playerEntityManager.droidsNotDead {
//                droidEntity.update(deltaTime: self.deltaTime)
//            }
//        }
//    }
//    
    func startTimer(time:TimeInterval){
        self.pauseStartTime = nil
        self.gameStartTime = time
//        self.updateGameTime(time: time)
    }
//    
    func togglePause(time:TimeInterval){
        if(self.pauseStartTime != nil){
            self.lastUpdateTime += time - self.pauseStartTime
            self.gameStartTime += time - self.pauseStartTime
            self.pauseStartTime = nil
        }else{
            self.pauseStartTime = time
        }
    }
//
//    let tmpGameTime:TimeInterval = TimeInterval(60 * 2)
    public func updateGameTime(time:TimeInterval = 0.0){
//        if(self.game.levelManager.currentLevel.duration == .Infinite){
//            let timeElapsed:TimeInterval = time - self.gameStartTime
//            self.game.overlayManager.hud.setTime(time: timeElapsed)
//        }else{
        var updateDeltaTime:TimeInterval = self.game.levelManager.currentLevel.levelConfigEnv.matchDuration.rawValue // self.game.levelManager.currentLevel.duration.rawValue
            if(time > 0.0 && self.gameStartTime > 0.0){
                updateDeltaTime = updateDeltaTime - (time - self.gameStartTime)
            }
        self.game.overlayManager.hud.setGameTimer(time: updateDeltaTime)
//                
            if(updateDeltaTime <= 0.0){
                self.game.stateMachine.enter(SuakeStateMatchOver.self)
//                if((self.game.levelManager.currentLevel.levelID == LevelID.TUT_00 || self.game.levelManager.currentLevel.levelID == LevelID.TUT_01) && DbgVars.showTutorialsAtStartup){
//                    _ = self.game.stateMachine.enter(SuakeStateTutorialCompleted.self)
//                    self.game.overlayManager.tutorialCompletedOverlay.setTutorialLevel(tutorialLevel: self.game.levelManager.currentLevel as! TutorialLevel)
//                }else{
//                    self.game.stateMachine.showGameOver(youLost: false)
//                }
            }
//        }
    }
    
    func qeueNode2Add2Scene(node:SCNNode){
        self.game.scene.rootNode.addChildNode(node)
    }
        
    func qeueNode2Remove(node:SCNNode){
//        node.cleanup()
        node.runAction(SCNAction.removeFromParentNode())
    }
}
