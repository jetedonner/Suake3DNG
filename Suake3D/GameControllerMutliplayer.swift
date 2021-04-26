//
//  GameControllerMutliplayer.swift
//  Suake3D
//
//  Created by Kim David Hauser on 26.04.21.
//

import Foundation
import SceneKit
import NetTestFW

extension GameController{
    
    func multiplayerLoad(levelConfigNet:LoadLevelNetworkData){
        self.overlayManager.gameCenterOverlay.setProgress(curPrecent: 25, msg: "Loading level for match ...")
        self.levelManager.loadNetworkMatch(levelConfigNet: levelConfigNet)
        self.levelLoaded = true
        
        if(self.levelLoaded && self.serverLoaded && self.gameCenterHelper.matchMakerHelper.ownPlayerNetObj.playerType == .client){
            self.gameCenterHelper.matchMakerHelper.sendReady4MatchMsg()
        }
    }
    
    func multiplayerSet(setupNet:SetupClientServerNetworkData){
        for host in setupNet.clientServerData {
            print("playerId: " + host.playerId + ", playerType: \(host.playerType), playerNum: \(host.playerNum)")
        }
        self.serverLoaded = true
        if(self.levelLoaded && self.serverLoaded && self.gameCenterHelper.matchMakerHelper.ownPlayerNetObj.playerType == .client){
            self.playerEntityManager.userPlayerSuake = self.playerEntityManager.oppPlayerEntity
            self.gameCenterHelper.matchMakerHelper.sendReady4MatchMsg()
        }
    }
    
    func multiplayer(startMatch:StartMatchNetworkData){
        self.stateMachine.enter(SuakeStateMultiplayerPlaying.self)
    }
    
    func pickedUpNetworkMatch(pickedUpData:PickedUpNetworkData){
//        self.playerEntityManager.ownPlayerEntity.shoot()
        if(pickedUpData.itemType == .goody){
//            self.playerEntityManager.goodyEntity.pos = pickedUpData.newPos
            self.playerEntityManager.goodyEntity.reposGoodyAfterCatch(newPos: pickedUpData.newPos)
        }else if(pickedUpData.itemType == .medKit){
//            ((self.locationEntityManager.entityGroups[.MedKit]? as? Set<SuakeNodeGroupBase>)?.first ?.groupItems[pickedUpData.id] as! MedKitEntity).reposMedKitAfterCatch(newPos: pickedUpData.newPos)
            //Kim
        }
    }
    
    func hitByBulletNetworkMatch(hitByBulletData:HitByBulletNetworkData){
//        self.playerEntityManager.ownPlayerEntity.shoot()
        if(hitByBulletData.itemType == .goody){
//            self.playerEntityManager.goodyEntity.pos = pickedUpData.newPos
            self.playerEntityManager.goodyEntity.goodyHitNet(hitByBulletMsg: hitByBulletData)
        }
    }
    
    func shootWeaponNetworkMatch(shootData:ShootWeaponNetworkData){
//        shootData.playerId
        self.playerEntityManager.ownPlayerEntity.weapons.setCurrentWeaponType(weaponType: shootData.weaponType, playAudio: false)
        self.playerEntityManager.ownPlayerEntity.shoot(at: shootData.velocity, velocity: true)
    }
    
    func droidPathNetworkMatch(droidDirData:DroidPathNetworkData){
        self.playerEntityManager.droidEntities[0].droidAIComponent.newPath = droidDirData.path
    }
    
    func turnDirNetworkMatch(turnData:TurnNetworkData){
//        if(turnData.playerId.starts(with: "Droid-")){
//            var droidIdParts:[String.SubSequence] = turnData.playerId.split(separator: "-")
//            let droidId:Int = Int(droidIdParts[1])!
////            self.playerEntityManager.droidEntities[droidId].droidComponent.nextMove(newDir: T##SuakeDir)
//        }else{
            self.playerEntityManager.ownPlayerEntity.moveComponent.posAfterNetSend = turnData.position
            self.playerEntityManager.ownPlayerEntity.appendTurn(turnDir: turnData.turnDir)
//        }
    }
    
    func droidDirNetworkMatch(droidData:DroidDirNetworkData){
        if(droidData.playerId.starts(with: "Droid-")){
            let droidIdParts:[String.SubSequence] = droidData.playerId.split(separator: "-")
            let droidId:Int = Int(droidIdParts[1])!
            self.playerEntityManager.droidEntities[droidId].droidComponent.nextMove(newDir: droidData.nextDir)
        }//else{
//            self.playerEntityManager.ownPlayerEntity.moveComponent.posAfterNetSend = turnData.position
//            self.playerEntityManager.ownPlayerEntity.appendTurn(turnDir: turnData.turnDir)
//        }
    }
}
