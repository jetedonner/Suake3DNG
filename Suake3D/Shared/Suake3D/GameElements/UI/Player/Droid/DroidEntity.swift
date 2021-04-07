//
//  DroidEntity.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class DroidEntity: SuakeBaseExplodingPlayerEntity {
    
    let droidComponent:DroidComponent
    let droidAIComponent:DroidAIComponent
    var attackComponent:DroidAttackComponent!
    
    var droidStates:DroidStateMachine!
    
    override var pos:SCNVector3{
        get{ return super.pos }
        set{
//            self.game.levelManager.gameBoard.setGameBoardField(pos: self.pos, suakeField: .empty)
            super.pos = newValue
//            self.game.levelManager.gameBoard.setGameBoardField(pos: newValue, suakeField: .own_suake)
            self.droidComponent.node.position = SCNVector3(super.pos.x * SuakeVars.fieldSize, 0, super.pos.z * SuakeVars.fieldSize)
        }
    }
    
    init(game: GameController, id: Int = 0) {
        self.droidComponent = DroidComponent(game: game, id: id)
        self.droidAIComponent = DroidAIComponent(game: game)
        
        super.init(game: game, playerType: .Droid, id: id)
        
        self.killScore = SuakeVars.droidKillScore
        self.attackComponent = DroidAttackComponent(game: game, playerEnity: self)
        
        self.droidStates = DroidStateMachine(game: game, droidEntity: self)
        
        self.addComponent(self.droidComponent)
        self.addComponent(self.droidAIComponent)
        self.addComponent(self.attackComponent)
        
        self.droidStates.enter(DroidStatePatroling.self)
    }
    
    override func reposMapNodeInit(duration:TimeInterval = 0.0, pos:SCNVector3? = nil){
        super.reposMapNodeInit(duration: (self.game.physicsHelper.deltaTime >= 1.0 ? 1.0 : 1.0 - self.game.physicsHelper.deltaTime), pos: self.pos)
    }
    
    override func rotateMapNodeInit(duration: TimeInterval = 0.0, dir: SuakeDir? = nil) {
        return
    }
    var targetEntity:SuakePlayerEntity!
    var dist2Target:CGFloat = 0.0
    
    override func update(deltaTime seconds: TimeInterval) {
        self.targetEntity = self.game.playerEntityManager.ownPlayerEntity
        self.dist2Target = self.game.levelManager.distanceManager.getDistanceBetween(node1: self, node2: self.game.playerEntityManager.ownPlayerEntity)
        let dist2Opp = self.game.levelManager.distanceManager.getDistanceBetween(node1: self, node2: self.game.playerEntityManager.oppPlayerEntity)
        if(!self.game.playerEntityManager.oppPlayerEntity.died && dist2Opp <= self.dist2Target){
            self.dist2Target = dist2Opp
            self.targetEntity = self.game.playerEntityManager.oppPlayerEntity
        }
        if(self.dist2Target <= self.game.usrDefHlpr.droidsChaseDist){
            if(self.dist2Target <= self.game.usrDefHlpr.droidsAttackDist){
                self.droidStates.enter(DroidStateAttacking.self)
            }else{
                if(!(self.droidStates.currentState is DroidStateChasing)){
                    self.droidStates.enter(DroidStateChasing.self)
                }
            }
        }else{
            self.droidStates.enter(DroidStatePatroling.self)
        }
        self.droidStates.currentState?.update(deltaTime: seconds)
    }
    
    func hitByBullet(bullet:BulletBase){
        self.healthComponent.decHealth(decVal: bullet.damage * 1.25)
        self.hitByBullet(playerEntity: bullet.weapon.weaponArsenalManager.playerEntity, withBullet: true)
    }
    
    func hitByBullet(playerEntity:SuakeBasePlayerEntity, withBullet:Bool = false){
        if(!withBullet || self.healthComponent.died){
//            self.died = true
            playerEntity.statsComponent.addNewStats(statsType: .droidKilled, score: self.killScore)
            self.game.overlayManager.hud.msgOnHudComponent.setAndShowLbl(msg: String(format: SuakeMsgs.pointAddString, self.killScore), pos: self.droidComponent.node.position)
            
            self.droidDied(killedBy: playerEntity.playerType)
        }
    }
    
    func droidDied(killedBy:SuakePlayerType){
        self.droidComponent.flashLightInner.isHidden = true
        self.droidComponent.node.runAction(SCNAction.fadeOut(duration: 0.25), completionHandler: {
            self.game.physicsHelper.qeueNode2Remove(node: self.droidComponent.node)
        })
        for droidNode in self.game.overlayManager.hud.overlayScene!.map.droidNodes{
            if(droidNode.id == self.id){
                droidNode.removeFromParent()
                break
            }
        }
        self.game.overlayManager.hud.healthBars[self]?.node.removeFromParent()
        self.explodingComponent.explode()
    }

    func loadPath(){
        self.droidAIComponent.findPath2Entity(entity: self.targetEntity)
    }
    
    func add2Scene(){
        self.droidComponent.addToScene()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
