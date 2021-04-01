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

class SuakePlayerEntity: SuakeBaseExplodingPlayerEntity {

    let suakePlayerComponent:SuakePlayerComponent
    let moveComponent:SuakeMoveComponent
    let cameraComponent:SuakeCameraComponent
    let respawnComponent:SuakeRespawnComponent
    
    override var pos:SCNVector3{
        get{ return super.pos }
        set{
//            self.game.levelManager.gameBoard.setGameBoardField(pos: self.pos, suakeField: .empty)
            super.pos = newValue
//            self.game.levelManager.gameBoard.setGameBoardField(pos: newValue, suakeField: .own_suake)
            self.suakePlayerComponent.mainNode.position = SCNVector3(super.pos.x * SuakeVars.fieldSize, 0, super.pos.z * SuakeVars.fieldSize)
        }
    }
    
    override init(game: GameController, playerType: SuakePlayerType = .OwnSuake, id: Int = 0) {
        self.suakePlayerComponent = SuakePlayerComponent(game: game, playerType: playerType)
        self.moveComponent = SuakeMoveComponent(game: game)
        self.cameraComponent = SuakeCameraComponent(game: game, cameraType: .Own3rdPerson)
        self.respawnComponent = SuakeRespawnComponent(game: game)

        super.init(game: game, playerType: playerType, id: id)
        
        self.killScore = SuakeVars.suakePlayerKillScore
        self.addComponent(self.suakePlayerComponent)
        self.addComponent(self.moveComponent)
        self.addComponent(self.cameraComponent)
        self.addComponent(self.respawnComponent)
        
        self.weapons = WeaponArsenalManager(game: game, playerEntity: self)
        self.weapons.initWeaponArsenal(with: WeaponType.init(weaponTypes: [.mg]))
    }
    
    func hitByBullet(bullet:BulletBase){
        self.game.physicsHelper.qeueNode2Remove(node: bullet)
        self.game.showDbgMsg(dbgMsg: "Suake (opp) hit by bullet > damage: " + bullet.damage.description, dbgLevel: .Verbose)
        
        if(self.healthComponent.decHealth(decVal: bullet.damage)){
            self.game.physicsHelper.qeueNode2Remove(node: self.suakePlayerComponent.mainNode)
            self.explodingComponent.explode()
            self.game.overlayManager.hud.healthBars[self]?.node.removeFromParent()
            
            self.statsComponent.add2StatsValue(suakeStatsType: .deaths)
            
            bullet.weapon.weaponArsenalManager.playerEntity.statsComponent.addNewStats(statsType: .opponetKilled, score: self.killScore)
            
            self.game.overlayManager.hud.msgOnHudComponent.setAndShowLbl(msg: String(format: SuakeMsgs.pointAddString, self.killScore), pos: self.suakePlayerComponent.mainNode.position)
            
        }else{
            self.game.overlayManager.hud.healthBars[self]?.drawHealthBar()
        }
    }
    
    override func reposMapNodeInit(duration:TimeInterval = 0.0, pos:SCNVector3? = nil){
        super.reposMapNodeInit(duration: (self.game.physicsHelper.deltaTime >= 1.0 ? 1.0 : 1.0 - self.game.physicsHelper.deltaTime), pos: self.moveComponent.overNextPos)
    }
    
    override func rotateMapNodeInit(duration: TimeInterval = 0.0, dir: SuakeDir? = nil) {
        super.rotateMapNodeInit(duration: self.game.physicsHelper.deltaTime, dir: self.dir)
    }
    
//    static var initOppShootGoodyAggr:CGFloat = 0.5
    let shootingBlur:Int = 1
    func autoAimAndShootOwnAt(entity:SuakeBasePlayerEntity, aimDur:TimeInterval = 0.15){
        
        //self.game.playerEntityManager.getOppPlayerEntity()!.weapons.setCurrentWeaponType(weaponType: .mg, playAudio: false)
        
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
            self.suakePlayerComponent.mainNode.runAction(SCNAction.wait(duration: waitTime), completionHandler: {
                self.shoot(at: tmpPos) // (entity as! GoodyEntity).goodyComponent.node.position)
            })
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
    
    func shoot(at:SCNVector3? = nil){
        self.weapons.shoot(at: at)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        self.moveComponent.update(deltaTime: seconds)
    }
    
    func appendTurn(turn:KeyboardDirection){
        self.moveComponent.appendTurn(turn: turn)
    }
    
    func setupPlayerEntity(){
        self.suakePlayerComponent.add2Scene()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
