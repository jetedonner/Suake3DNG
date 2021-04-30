//
//  GoodyEntity.swift
//  Suake3D
//
//  Created by Kim David Hauser on 15.03.21.
//

import Foundation
import SceneKit
import NetTestFW

class GoodyEntity: SuakeBasePlayerEntity {
    
    let goodyComponent:GoodyComponent
//    let healthComponent:SuakeHealthComponent
    let particlesComponent:RisingParticlesComponent
//    let goodyValue:Int = 100
    var tmpScore:Int = 0
    
    init(game: GameController, id:Int = 0) {
        self.goodyComponent = GoodyComponent(game: game, id: id)
//        self.healthComponent = SuakeHealthComponent(game: game)
        self.particlesComponent = RisingParticlesComponent(game: game)
        
        super.init(game: game, playerType: .Goody, id: id)
        
        self.killScore = SuakeVars.goodyKillScore
        self.addComponent(self.goodyComponent)
//        self.addComponent(self.healthComponent)
        self.addComponent(self.particlesComponent)
    }
    
    func goodyHit(bullet:BulletBase){
        if(self.game.gameCenterHelper.isMultiplayerGameRunning && self.game.gameCenterHelper.matchMakerHelper.ownPlayerNetObj.playerId == self.game.gameCenterHelper.matchMakerHelper.dbgClientPlayerId){
            return
        }
        self.healthComponent.decHealth(decVal: bullet.damage * 1.25)
        self.goodyHit(playerEntity: bullet.weapon.weaponArsenalManager.playerEntity, withBullet: true)
        if(self.game.gameCenterHelper.isMultiplayerGameRunning && self.game.gameCenterHelper.matchMakerHelper.ownPlayerNetObj.playerId != self.game.gameCenterHelper.matchMakerHelper.dbgClientPlayerId){
            self.game.gameCenterHelper.matchMakerHelper.sendHitByBulletMsg(itemType: .goody, weaponType: bullet.weapon.weaponType, value: bullet.damage, pos: bullet.position)//(itemType: .goody, value: CGFloat(self.killScore), newPos: newPos)
        }
    }
    
    func goodyHitNet(hitByBulletMsg:HitByBulletNetworkData){
//        if(self.game.gameCenterHelper.isMultiplayerGameRunning && self.game.gameCenterHelper.matchMakerHelper.ownPlayerNetObj.playerId == self.game.gameCenterHelper.matchMakerHelper.dbgClientPlayerId){
//            return
//        }
        self.healthComponent.decHealth(decVal: hitByBulletMsg.value * 1.25)
        self.goodyHit(playerEntity: self.game.playerEntityManager.ownPlayerEntity, withBullet: true)
//        if(self.game.gameCenterHelper.isMultiplayerGameRunning && self.game.gameCenterHelper.matchMakerHelper.ownPlayerNetObj.playerId != self.game.gameCenterHelper.matchMakerHelper.dbgClientPlayerId){
//            self.game.gameCenterHelper.matchMakerHelper.sendHitByBulletMsg(itemType: .goody, weaponType: bullet.weapon.weaponType, value: bullet.damage, pos: bullet.position)//(itemType: .goody, value: CGFloat(self.killScore), newPos: newPos)
//        }
    }
    
    func goodyHit(playerEntity:SuakeBasePlayerEntity, withBullet:Bool = false){
        if(!withBullet || self.healthComponent.died){
            if(self.game.gameCenterHelper.matchMakerHelper.ownPlayerNetObj != nil && self.game.gameCenterHelper.matchMakerHelper.ownPlayerNetObj.playerId == self.game.gameCenterHelper.matchMakerHelper.dbgClientPlayerId){
                return
            }
            self.game.soundManager.playSound(soundType: .pick_goody)
            
            playerEntity.statsComponent.addNewStats(statsType: .goodyCatched, score: self.killScore)
            self.game.overlayManager.hud.msgOnHudComponent.setAndShowLbl(msg: String(format: SuakeMsgs.pointAddString, self.killScore), pos: self.goodyComponent.node.position)
            
            self.particlesComponent.node.position = self.goodyComponent.node.position
            
            let newPos:SCNVector3 = self.goodyComponent.initPosRandom()
            if(self.game.gameCenterHelper.isMultiplayerGameRunning){
                self.game.gameCenterHelper.matchMakerHelper.sendPickedUpMsg(itemType: .goody, value: CGFloat(self.killScore), newPos: newPos)
            }
            self.healthComponent.resetHealth()
            self.healthComponent.died = false
            
            self.particlesComponent.node.isHidden = false
            self.particlesComponent.node.opacity = 1.0
            self.particlesComponent.node.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.3), SCNAction.fadeOut(duration: 0.7)]), completionHandler: {
                self.particlesComponent.node.position = self.goodyComponent.node.position
            })
        }
        self.game.overlayManager.hud.healthBars[self.game.playerEntityManager.goodyEntity]?.drawHealthBar()
//        self.game.overlayManager.hud.healthBarGoodyComponent.drawHealthBar()
    }
    
    func reposGoodyAfterCatch(newPos:SCNVector3){
        self.goodyComponent.initPosRandom(newPos: newPos)
        self.healthComponent.resetHealth()
        self.healthComponent.died = false
        
        self.particlesComponent.node.isHidden = false
        self.particlesComponent.node.opacity = 1.0
        self.particlesComponent.node.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.3), SCNAction.fadeOut(duration: 0.7)]), completionHandler: {
            self.particlesComponent.node.position = self.goodyComponent.node.position
        })
    }
    
    func add2Scene(){
        self.goodyComponent.add2Scene()
        self.game.physicsHelper.qeueNode2Add2Scene(node: self.particlesComponent.node)
        self.particlesComponent.node.isHidden = true
    }
    
    func resetPlayerEntity(){
        self.healthComponent.resetHealth()
//        self.dir = .UP
//        self.dirOld = .UP
//        self.pos = SuakeVars.ownPos
//        self.moveComponent.resetMoveComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
