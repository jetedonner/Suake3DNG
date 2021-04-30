//
//  DbgPoint.swift
//  Suake3D
//
//  Created by Kim David Hauser on 23.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class MedKitEntity: SuakeNodeGroupItemBase {
    
    var medKitComponent:MedKitComponent!
    var particlesComponent:MedKitRisingParticlesComponent!
    var healthScore:CGFloat = 25.0
    var catchScore:Int = SuakeVars.medKitCatchScore
    
    override var pos:SCNVector3{
        get{ return super._pos }
        set{
//            self.game.levelManager.gameBoard.setGameBoardField(pos: self.pos, suakeField: .empty, overrideOrig: true)
//            self.game.levelManager.gameBoard.setGameBoardFieldEntity(pos: self.pos, entity: nil)
            self.game.levelManager.gameBoard.removeGameBoardFieldItem(pos: self.pos, suakeFieldItem: self)
            super.pos = newValue
            self.game.levelManager.gameBoard.setGameBoardFieldItem(pos: self.pos, suakeFieldItem: self)
            self.medKitComponent.node.position = SCNVector3(self._pos.x * SuakeVars.fieldSize, self._pos.y, self._pos.z * SuakeVars.fieldSize)
//            if(self.game.overlayManager.hud.overlayScene!.map.medKitNodes.count > self.id){
//                self.game.overlayManager.hud.overlayScene!.map.reposNodeInit(locationType: .MedKit, id: self.id, pos: self.pos)
//            }
//            self.game.levelManager.gameBoard.setGameBoardField(pos: self.pos, suakeField: self.suakeField, overrideOrig: true)
//            self.game.levelManager.gameBoard.setGameBoardFieldEntity(pos: self.pos, entity: self)
//            self.game.levelManager.gameBoard[Int(self.pos.x + self.game.levelManager.gameBoard.halfFieldCount), Int(self.pos.z + self.game.levelManager.gameBoard.halfFieldCount)].fieldEntity = self
//            let scnNodeComponents:[SuakeBaseSCNNodeComponent] = self.components(conformingTo: SuakeBaseSCNNodeComponent.self)
//            for i in (0..<scnNodeComponents.count){
//                if( !scnNodeComponents[i].isKind(of: SuakeLightComponent.self) &&
//                    !scnNodeComponents[i].isKind(of: SuakePlayerFollowCameraComponent.self) &&
//                    !scnNodeComponents[i].isKind(of: SuakePlayerFollowCameraFPComponent.self) &&
//                    !scnNodeComponents[i].isKind(of: RisingParticlesComponent.self) &&
//                    !scnNodeComponents[i].isKind(of: MedKitRisingParticlesComponent.self)){
//
//                    if(!scnNodeComponents[i].isKind(of: SuakeBaseSuakePlayerComponent.self)){
//                        scnNodeComponents[i].node.position = SCNVector3(self._pos.x * SuakeVars.fieldSize, self._pos.y, self._pos.z * SuakeVars.fieldSize)
//                    }
//                }
//            }
        }
    }
    
    func removeFromScene(){
//        self.medKitComponent.removeFromScene()
//        self.particlesComponent.node.removeFromParentNode()
    }
   
//    init(game: GameController, preload:SuakeBaseSCNNode, id:Int = 0) {
//        super.init(game: game, id: id)
////        self.setFieldType(playerType: .)
//        self.suakeField = .medKit
//        self.medKitComponent = MedKitComponent(game: game, prelaod: preload, id: id)
//        self.addComponent(self.medKitComponent)
//
//        self.particlesComponent = MedKitRisingParticlesComponent(game: game)
//        self.addComponent(self.particlesComponent)
//        self.game.physicsHelper.qeueNode2Add2Scene(node: self.particlesComponent.node)
//        self.particlesComponent.node.isHidden = true
//    }
    
    override init(game: GameController, id:Int = 0) {
        super.init(game: game, id: id)
        self.suakeField = .medKit
        self.medKitComponent = MedKitComponent(game: game, id: id)
        self.addComponent(self.medKitComponent)
        self.particlesComponent = MedKitRisingParticlesComponent(game: game)
        self.addComponent(self.particlesComponent)
        self.game.physicsHelper.qeueNode2Add2Scene(node: self.particlesComponent.node)
        self.particlesComponent.node.isHidden = true
    }
    
    func add2Scene(initPos:Bool = true){
        if(initPos){
            self.medKitComponent.initSetupPos()
        }
        self.setParticlePos(newPos: self.pos)
        self.medKitComponent.addToScene()
    }
    
    func medKitCollected(bullet:BulletBase){
        self.medKitCollected(playerEntity: bullet.weapon.weaponArsenalManager.playerEntity, withBullet: true)
    }
    
    func medKitCollected(playerEntity:SuakeBasePlayerEntity, withBullet:Bool = false){
        if(self.game.gameCenterHelper.matchMakerHelper.ownPlayerNetObj != nil && self.game.gameCenterHelper.matchMakerHelper.ownPlayerNetObj.playerId == self.game.gameCenterHelper.matchMakerHelper.dbgClientPlayerId){
            return
        }
        playerEntity.healthComponent.addHealth(addVal: self.healthScore)
        playerEntity.statsComponent.addNewStats(statsType: .medKitCollectd, score: self.catchScore)
        self.game.overlayManager.hud.msgOnHudComponent.setAndShowLbl(msg: String(format: SuakeMsgs.pointAddString, self.catchScore), pos: self.medKitComponent.node.position)

        let newPos:SCNVector3 = self.game.levelManager.gameBoard.getRandomFreePos()
        self.showParticles(completion: {
            self.setParticlePos(newPos: newPos)
        })
        self.game.soundManager.playSound(soundType: .pickupHealth)
        self.pos = newPos
        if(self.game.gameCenterHelper.isMultiplayerGameRunning){
            self.game.gameCenterHelper.matchMakerHelper.sendPickedUpMsg(itemType: .medKit, value: CGFloat(self.catchScore), newPos: newPos, itemId: self.id)
        }
    }
    
    func reposMedKitAfterCatch(newPos:SCNVector3){
        self.showParticles(completion: {
            self.setParticlePos(newPos: newPos)
        })
        self.pos = newPos
//        self.goodyComponent.initPosRandom(newPos: newPos)
//        self.healthComponent.resetHealth()
//        self.healthComponent.died = false
//
//        self.particlesComponent.node.isHidden = false
//        self.particlesComponent.node.opacity = 1.0
//        self.particlesComponent.node.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.3), SCNAction.fadeOut(duration: 0.7)]), completionHandler: {
//            self.particlesComponent.node.position = self.goodyComponent.node.position
//        })
    }
    
    func setParticlePos(newPos:SCNVector3){
        self.particlesComponent.node.position = SCNVector3(newPos.x * SuakeVars.fieldSize, 0, newPos.z * SuakeVars.fieldSize)
    }
    
    func showParticles(completion: @escaping () -> Void?){
        self.particlesComponent.node.isHidden = false
        self.particlesComponent.node.opacity = 1.0
        self.particlesComponent.node.runAction(SCNAction.sequence([ SCNAction.fadeIn(duration: 0.1), SCNAction.wait(duration: 0.3), SCNAction.fadeOut(duration: 0.7)]), completionHandler: {
            completion()
        })
    }
////        if(!bullet.isTargetHit){
////            bullet.isTargetHit = true
//        
//        // TODO clean up shotgun hit by one pellet
//        if(bullet is ShotgunPellet){
//            if((bullet as! ShotgunPellet).pelletGrp.isTargetHit){
//                return
//            }else{
//                if(!bullet.hitTarget(targetCat: .medKit, targetNode: self.medKitComponent.node)){
//                    return
//                }else{
//                    print("medKit Hit by bullet")
//                    self.game.physicsHelper.qeueNode2Remove(node: bullet)
//                    self.game.showDbgMsg(dbgMsg: "MedKit No: " + self.id.description + " hit by bullet", dbgLevel: .Verbose)
//                    self.medKitCollected(playerType: bullet.weapon.weaponArsenalManager.playerEntity.playerType)
//                }
//            }
//        }else if(!bullet.hitTarget(targetCat: .medKit, targetNode: self.medKitComponent.node)){
//            return
//        }else{
//            print("medKit Hit by bullet")
//            if(!(bullet is RailgunBeam)){
//                self.game.physicsHelper.qeueNode2Remove(node: bullet)
//            }
//            self.game.showDbgMsg(dbgMsg: "MedKit No: " + self.id.description + " hit by bullet", dbgLevel: .Verbose)
//            self.medKitCollected(playerType: bullet.weapon.weaponArsenalManager.playerEntity.playerType)
//        }
//    }
//    
//    func medKitCollected(playerType:SuakePlayerType = .OwnSuake){
//        self.game.showDbgMsg(dbgMsg: "MedKit No: " + self.id.description + " collected", dbgLevel: .Verbose)
//        if(playerType == .OwnSuake){
//            self.game.playerEntityManager.getOwnPlayerEntity().statsHelper.addStatsValue2Score(statsType: .medKitCollectd, value: 50)
//        }else if(playerType == .OppSuake){
//            self.game.playerEntityManager.getOppPlayerEntity()!.statsHelper.addStatsValue2Score(statsType: .medKitCollectd, value: 50)
//        }
//        
//        //self.game.overlayManager.hud.hudEntity.setScore(score: self.game.playerEntityManager.getOwnPlayerEntity().stats.score)
//        if(playerType == .OwnSuake){
//            _ = self.game.playerEntityManager.getOwnPlayerEntity().healthComponent.addHealth(addVal: self.healthScore)
//            self.game.overlayManager.hud.hudEntity.healthBarOwnComponent.drawHealthBar()
//            self.game.overlayManager.hud.hudEntity.healthBarComponent.drawHealthBar()
//        }else if(playerType == .OppSuake){
//            _ = self.game.playerEntityManager.getOppPlayerEntity()!.healthComponent.addHealth(addVal: self.healthScore)
//            self.game.overlayManager.hud.hudEntity.healthBarOppComponent.drawHealthBar()
//        }
//        
//        self.particlesComponent.node.position = self.medKitComponent.node.position
//
//        self.game.audioManager.playSound(soundType: .health)
//        self.particlesComponent.node.isHidden = false
//        self.particlesComponent.node.runAction(SCNAction.sequence([SCNAction.fadeIn(duration: 0.0), SCNAction.wait(duration: 0.3), SCNAction.fadeOut(duration: 0.7)]))
//        
//        self.game.levelManager.gameBoard.setGameBoardField(pos: self.pos, suakeField: .empty)
//        self.game.levelManager.gameBoard.setGameBoardFieldEntity(pos: self.pos, entity: nil)
//        let newPos:SCNVector3 = self.game.levelManager.gameBoard.getRandomFreePos()
//        self.pos = newPos
//        self.game.overlayManager.hud.map.reposNode(nodeType: .medKit, id: self.id)
//        if(playerType == .OppSuake){
//            if(!(self.game.playerEntityManager.oppPlayerEntity.intelligenceComponent.stateMachine.currentState is OpponentSeekGoodyState)){
//                _  = self.game.playerEntityManager.oppPlayerEntity.intelligenceComponent.checkMode(reloadCurrentState: true)
//            }
//        }
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
