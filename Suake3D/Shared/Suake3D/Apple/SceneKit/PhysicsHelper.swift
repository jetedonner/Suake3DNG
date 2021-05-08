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
  
    var deltaTime:TimeInterval = 0.0
    var takeSS:Bool = false
    var firstMove:Bool = true
    
    override init(game: GameController) {
        super.init(game: game)
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        if(!(self.game.stateMachine.currentState is SuakeStatePlaying) && !(self.game.stateMachine.currentState is SuakeStateMultiplayerPlaying)){
            return
        }
        
        self.currentTime = time
        if(self.pauseStartTime != nil){
            self.togglePause(time: time)
        }

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
                    if let ownSuakeEntity = self.game.playerEntityManager.ownPlayerEntity {
                        ownSuakeEntity.moveComponent.inBetweenMove = false
                        if(ownSuakeEntity.moveComponent.posAfterNetSend != nil){
                            ownSuakeEntity.pos = ownSuakeEntity.moveComponent.posAfterNetSend!
                            ownSuakeEntity.moveComponent.posAfterNetSend = nil
                        }
                        ownSuakeEntity.update(deltaTime: self.deltaTime)
                    }
                    for droidEntity in self.game.playerEntityManager.droidsNotDead{
                        droidEntity.update(deltaTime: self.deltaTime)
                    }
                    self.game.overlayManager.hud.overlayScene!.arrows.showHideHelperArrows()
                }
            }else{
                if(self.game.usrDefHlpr.testOppAI){
                    
                }else{
                    if(self.game.playerEntityManager.ownPlayerEntity != nil && self.game.playerEntityManager.ownPlayerEntity.moveComponent.turnQueue.count > 0 &&
                        self.deltaTime <= 0.64 &&
                        !self.game.playerEntityManager.ownPlayerEntity.moveComponent.inBetweenMove){
                        if let ownSuakeEntity = self.game.playerEntityManager.ownPlayerEntity {
                            if(ownSuakeEntity.moveComponent.posAfterNetSend != nil){
                                ownSuakeEntity.pos = ownSuakeEntity.moveComponent.posAfterNetSend!
                                ownSuakeEntity.moveComponent.posAfterNetSend = nil
                            }
                            ownSuakeEntity.update(deltaTime: deltaTime)
                        }
                    }
                }
            }
            self.game.levelManager.distanceManager.updateDistances()
            self.updateGameTime(time: time)
        }
    }
    
    func startTimer(time:TimeInterval){
        self.pauseStartTime = nil
        self.gameStartTime = time
    }
    
    func togglePause(time:TimeInterval){
        if(self.pauseStartTime != nil){
            self.lastUpdateTime += time - self.pauseStartTime
            self.gameStartTime += time - self.pauseStartTime
            self.pauseStartTime = nil
        }else{
            self.pauseStartTime = time
        }
    }

    public func updateGameTime(time:TimeInterval = 0.0){
        var updateDeltaTime:TimeInterval = self.game.levelManager.currentLevel.levelConfigEnv.matchDuration.rawValue
        
        if(time > 0.0 && self.gameStartTime > 0.0){
            updateDeltaTime = updateDeltaTime - (time - self.gameStartTime)
        }
        self.game.overlayManager.hud.setGameTimer(time: updateDeltaTime)
        if(updateDeltaTime <= 0.0){
            self.game.stateMachine.enter(SuakeStateMatchOver.self)
        }
    }
    
    func qeueNode2Add2Scene(node:SCNNode){
        self.game.scene.rootNode.addChildNode(node)
    }
        
    func qeueNode2Remove(node:SCNNode){
        node.runAction(SCNAction.removeFromParentNode())
    }
}
