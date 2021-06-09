//
//  SuakePlayerEntity.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class SuakePlayerEntity: SuakeBaseExplodingPlayerEntity {

    let playerComponent:SuakePlayerComponent
    let moveComponent:SuakeMoveComponent
    let cameraComponent:SuakeCameraComponent
    let respawnComponent:SuakeRespawnComponent
//    var pathfinderParticles:PathfinderComponent!
    
    var isBeaming:Bool = false
    
    override var pos:SCNVector3{
        get{ return super.pos }
        set{
            if(self.game.levelManager.gameBoard.getGameBoardField(pos: newValue) == .portal){
                var tmp0 = -1
                tmp0 /= -1
                self.game.levelManager.gameBoard.setGameBoardField(pos: newValue, suakeField: .own_suake)
                super.pos = newValue
                self.playerComponent.mainNode.position = SCNVector3(super.pos.x * SuakeVars.fieldSize, 0, super.pos.z * SuakeVars.fieldSize)
                return
            }else{
                self.game.levelManager.gameBoard.setGameBoardField(pos: self.pos, suakeField: .empty, overrideOrig: true)
            }
            super.pos = newValue
            if(self.playerType == .OwnSuake){
                self.reposMapNodeInit()
            }else{
                
            }
            self.game.levelManager.gameBoard.setGameBoardField(pos: newValue, suakeField: (self.playerType == .OwnSuake ? .own_suake : .opp_suake))
            self.playerComponent.mainNode.position = SCNVector3(super.pos.x * SuakeVars.fieldSize, 0, super.pos.z * SuakeVars.fieldSize)
        }
    }
    
    override func setup(posDir: SuakePosDir) {
        super.setup(posDir: posDir)
        SuakeDirTurnDirHelper.initNodeRotation(node: self.playerComponent.mainNode, dir: posDir.dir)
        self.cameraComponent.moveFollowCamera(turnDir: .Straight, duration: 0.0, moveDifference: 0.0)
        self.cameraComponent.moveRotateFPCamera(duration: 0.0, turnDir: .Straight, moveDifference: 0.0)
    }
    
//    override func setup(pos: SCNVector3, dir:SuakeDir){
//        super.setup(pos: pos, dir: dir)
//        SuakeDirTurnDirHelper.initNodeRotation(node: self.playerComponent.mainNode, dir: dir)
//        self.cameraComponent.moveFollowCamera(turnDir: .Straight, duration: 0.0, moveDifference: 0.0)
//        self.cameraComponent.moveRotateFPCamera(duration: 0.0, turnDir: .Straight, moveDifference: 0.0)
//    }
    
    override init(game: GameController, playerType: SuakePlayerType = .OwnSuake, id: Int = 0) {
        self.playerComponent = SuakePlayerComponent(game: game, playerType: playerType)
        self.moveComponent = SuakeMoveComponent(game: game)
        self.cameraComponent = SuakeCameraComponent(game: game, playerType: playerType)
        self.respawnComponent = SuakeRespawnComponent(game: game)

        super.init(game: game, playerType: playerType, id: id)
        
        self.killScore = SuakeVars.suakePlayerKillScore
        self.addComponent(self.playerComponent)
        self.addComponent(self.moveComponent)
        self.addComponent(self.cameraComponent)
        self.addComponent(self.respawnComponent)
        
//        self.pathfinderParticles = PathfinderComponent(game: game)
//        self.addComponent(self.pathfinderParticles)
        
        self.weapons = WeaponArsenalManager(game: game, playerEntity: self)
        self.weapons.initWeaponArsenal(with: WeaponType.init(weaponTypes: [.mg, .shotgun, .rpg, .railgun, .sniperrifle, .redeemer]))
    }
    
    func hitByBullet(bullet:BulletBase){
        self.game.physicsHelper.qeueNode2Remove(node: bullet)
        self.game.showDbgMsg(dbgMsg: "Suake (opp) hit by bullet > damage: " + bullet.damage.description, dbgLevel: .Verbose)
        
        if(self.healthComponent.decHealth(decVal: bullet.damage)){
            self.playerDied(removeFromScene: true)
//            self.game.physicsHelper.qeueNode2Remove(node: self.playerComponent.mainNode)
//            self.explodingComponent.explode()
//            self.game.overlayManager.hud.healthBars[self]?.node.removeFromParent()
//
//            self.statsComponent.add2StatsValue(suakeStatsType: .deaths)
            
            bullet.weapon.weaponArsenalManager.playerEntity.statsComponent.addNewStats(statsType: .opponetKilled, score: self.killScore)
            
            self.game.overlayManager.hud.msgOnHudComponent.setAndShowLbl(msg: String(format: SuakeMsgs.pointAddString, self.killScore), pos: self.playerComponent.mainNode.position)
            
        }else{
            self.game.overlayManager.hud.healthBars[self]?.drawHealthBar()
        }
    }
    
    func playerDied(removeFromScene:Bool) {
        if removeFromScene {
            self.game.levelManager.gameBoard.setGameBoardField(pos: self.pos, suakeField: .empty)
            self.game.physicsHelper.qeueNode2Remove(node: self.playerComponent.mainNode)
            self.game.overlayManager.hud.healthBars[self]?.node.removeFromParent()
            self.mapNode?.removeFromParent()
        }
        self.playerDied()
    }
    
    override func playerDied(){
        self.explodingComponent.explode()
        self.statsComponent.add2StatsValue(suakeStatsType: .deaths)
        super.playerDied()
    }
    
    override func reposMapNodeInit(duration:TimeInterval = 0.0, pos:SCNVector3? = nil){
        super.reposMapNodeInit(duration: (self.game.physicsHelper.deltaTime >= 1.0 ? 1.0 : 1.0 - self.game.physicsHelper.deltaTime), pos: self.moveComponent.overNextPos)
    }
    
    override func rotateMapNodeInit(duration: TimeInterval = 0.0, dir: SuakeDir? = nil) {
        super.rotateMapNodeInit(duration: self.game.physicsHelper.deltaTime, dir: self.dir)
    }
    
    let shootingBlur:Int = 1
    func autoAimAndShootOwnAt(entity:SuakeBasePlayerEntity, aimDur:TimeInterval = 0.15){
        
        var tmpPos:SCNVector3 = entity.position
        let rndDifMin = (1.1 - 0.5 /*DbgVars.initOppShootGoodyAggr*/)
        let rndDif:Int = Int.random(range: (-self.shootingBlur * Int(rndDifMin))..<(self.shootingBlur * Int(rndDifMin)))
        tmpPos.x += CGFloat(rndDif)
        tmpPos.z += CGFloat(rndDif)
        tmpPos.y += CGFloat(10.0)
        let waitTime:Double = Double.random(in: 0.0..<0.05)
        
        if(entity.playerType == .Droid){
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = aimDur
//            SCNTransaction.completionBlock = {
//                self.shoot()
//            }
            tmpPos = (entity as! DroidEntity).droidComponent.node.position
            tmpPos.y = self.game.cameraHelper.cameraNodeFP.position.y
//            self.game.cameraHelper.cameraNodeFP.look(at: lookAtPos)
//            SCNTransaction.commit()
//        }
//        self.game.playerEntityManager.ownPlayerEntity.isPaused = false
//        self.game.playerEntityManager.ownPlayerEntity.currentSuakeComponent.node.isPaused = false
            self.playerComponent.mainNode.runAction(SCNAction.wait(duration: waitTime), completionHandler: {
                self.shoot(at: tmpPos) // (entity as! GoodyEntity).goodyComponent.node.position)
            })
        }else if(entity.playerType == .Goody){
            tmpPos = (entity as! GoodyEntity).goodyComponent.node.position
            tmpPos.y = self.game.cameraHelper.cameraNodeFP.position.y
            SCNTransaction.begin()
            SCNTransaction.animationDuration = aimDur
            SCNTransaction.completionBlock = {
                self.playerComponent.mainNode.runAction(SCNAction.wait(duration: waitTime), completionHandler: {
                    self.shoot(at: tmpPos) // (entity as! GoodyEntity).goodyComponent.node.position)
                })
            }
            self.game.cameraHelper.cameraNodeFP.look(at: tmpPos)
            SCNTransaction.commit()
        }
    }
    
    var isShooting:Bool = false
    var shootTimer:Timer!
    var lastShot:TimeInterval = 0.0
    
    func startShooting(){
        if(!isShooting){
            if((lastShot != 0.0 && self.weapons.currentWeapon.checkCadenceDelay()) || lastShot == 0.0){
                
                isShooting = true
                shootTimer = Timer.scheduledTimer(withTimeInterval: self.weapons.currentWeapon.cadence, repeats: true, block: { (timer) in
                   self.shoot()
                   return
               })
                self.shoot()
            }
        }
    }

    func finishShooting(){
       if(isShooting){
           isShooting = false
           if(shootTimer != nil){
               self.shootTimer.invalidate()
           }
       }
    }
    
    func shoot(at:SCNVector3? = nil, velocity:Bool = false){
        self.weapons.shoot(at: at, velocity: velocity)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        self.moveComponent.update(deltaTime: seconds)
    }
    
    func appendTurn(turn:KeyboardDirection){
        self.moveComponent.appendTurn(turn: turn)
    }
    
    func appendTurn(turnDir:TurnDir){
        self.moveComponent.appendTurn(turnDir: turnDir)
    }
    
    func setupPlayerEntity(){
        self.playerComponent.add2Scene()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
