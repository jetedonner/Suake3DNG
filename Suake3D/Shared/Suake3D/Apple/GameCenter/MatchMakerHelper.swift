//
//  MatchMakerHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 06.04.21.
//

import Foundation
import GameKit
import NetTestFW

class MatchMakerHelper: SuakeGameClass, GKMatchDelegate {
    
    let dbgServerPlayerId:String = "G:1918667927"
    let dbgClientPlayerId:String = "G:1400932886"
    let dbgServerPlayerName:String = "DaVe inc."
    let dbgClientPlayerName:String = "JeTeDonner"
    
    var dbgServerGKPlayer:GKPlayer!
    var dbgClientGKPlayers:[GKPlayer] = [GKPlayer]()
    
    var ownPlayerNetObj:SuakePlayerObjNet!
    
    let minPlayers:Int = 2
    let maxPlayers:Int = 2
    var players:[GKPlayer] = [GKPlayer]()
    
    var match:GKMatch!
    var voiceChat:GKVoiceChat!
    
    var setupClientServerData:SetupClientServerNetworkData!
    
    var msgSentCounter:Int = 0
    var msgRecvCounter:Int = 0
    
    var _isMultiplayerGameRunning:Bool = false
    var isMultiplayerGameRunning:Bool{
        get{ return self._isMultiplayerGameRunning }
        set{ self._isMultiplayerGameRunning = newValue }
    }
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func setMatch(match:GKMatch){
        self.match = match
        self.match.delegate = self
        self.isMultiplayerGameRunning = true
        self.voiceChat = self.match.voiceChat(withName: "Suake3DChat")
        self.voiceChat.start()
//        self.voiceChat.
    }
    
    func sendTurnMsg(turnDir:TurnDir, position:SCNVector3, playerId:String? = nil) {
//        do{
            let turnMsg:TurnNetworkData = TurnNetworkData(id: self.msgSentCounter, turnDir: turnDir, position: position, playerId: playerId ?? self.dbgServerPlayerId)
            guard let dataObj = NetworkHelper.encodeAndSend(netData: turnMsg) else {
                return
            }
        self.sendData(match: match, data: dataObj, with: .reliable)
        self.game.turnDirNetworkMatch(turnData: turnMsg)
//            if(NetworkHelper.dbgMode){
//                print(dataObj.prettyPrintedJSONString!)
//            }
//            try match.sendData(toAllPlayers: dataObj, with: .reliable)
//            self.game.turnDirNetworkMatch(turnData: turnMsg)
//            self.msgSentCounter += 1
//            self.game.showDbgMsg(dbgMsg: "Sent turnDir: \(turnDir.rawValue)")
//        } catch {
//            self.game.showDbgMsg(dbgMsg: "Send data failed")
//        }
    }
    
    func sendDroidDirMsg(nextDir:SuakeDir, position:SCNVector3, playerId:String? = nil) {
//        do{
            let droidMsg:DroidDirNetworkData = DroidDirNetworkData(id: self.msgSentCounter, nextDir: nextDir, position: position, playerId: playerId ?? self.dbgServerPlayerId)
            guard let dataObj = NetworkHelper.encodeAndSend(netData: droidMsg) else {
                return
            }
            self.sendData(match: match, data: dataObj, with: .reliable)
//            if(NetworkHelper.dbgMode){
//                print(dataObj.prettyPrintedJSONString!)
//            }
//            try match.sendData(toAllPlayers: dataObj, with: .reliable)
////            self.game.droidDirNetworkMatch(droidData: droidMsg)
//            self.msgSentCounter += 1
//            self.game.showDbgMsg(dbgMsg: "Sent droidDir: \(nextDir.rawValue)")
//        } catch {
//            self.game.showDbgMsg(dbgMsg: "Send data failed")
//        }
    }
    
    func sendDroidPathMsg(path:[SuakeBaseGridGraphNode], position:SCNVector3, playerId:String? = nil) {
//        do{
            let droidMsg:DroidPathNetworkData = DroidPathNetworkData(id: self.msgSentCounter, path: path, position: position, playerId: playerId ?? self.dbgServerPlayerId)
            guard let dataObj = NetworkHelper.encodeAndSend(netData: droidMsg) else {
                return
            }
            self.sendData(match: match, data: dataObj, with: .reliable)
//            if(NetworkHelper.dbgMode){
//                print(dataObj.prettyPrintedJSONString!)
//            }
//            try match.sendData(toAllPlayers: dataObj, with: .reliable)
////            self.game.droidDirNetworkMatch(droidData: droidMsg)
//            self.msgSentCounter += 1
//            self.game.showDbgMsg(dbgMsg: "Sent droidDir: \(path)")
//        } catch {
//            self.game.showDbgMsg(dbgMsg: "Send data failed")
//        }
    }
    
    func sendPickedUpMsg(itemType:SuakeFieldType, value:CGFloat, newPos:SCNVector3, itemId:Int = 0) {
//        do{
            let pickedUpMsg:PickedUpNetworkData = PickedUpNetworkData(id: self.msgSentCounter, itemType: itemType, value: value, newPos: newPos, itemId: itemId)
//            let turnMsg:TurnNetworkData = TurnNetworkData(id: self.msgSentCounter, turnDir: turnDir, position: position, playerId: self.dbgServerPlayerId)
            guard let dataObj = NetworkHelper.encodeAndSend(netData: pickedUpMsg) else {
                return
            }
            self.sendData(match: match, data: dataObj, with: .reliable)
//            if(NetworkHelper.dbgMode){
//                print(dataObj.prettyPrintedJSONString!)
//            }
//            try match.sendData(toAllPlayers: dataObj, with: .reliable)
////            self.game.turnDirNetworkMatch(turnData: pickedUpMsg)
//            self.msgSentCounter += 1
////            self.game.showDbgMsg(dbgMsg: "Sent turnDir: \(turnDir.rawValue)")
//        } catch {
//            self.game.showDbgMsg(dbgMsg: "Send data failed")
//        }
    }
    
    func sendHitByBulletMsg(itemType:SuakeFieldType, weaponType:WeaponType, value:CGFloat, pos:SCNVector3) {
//        do{
            let hitByBulletMsg:HitByBulletNetworkData = HitByBulletNetworkData(id: self.msgSentCounter, itemType: itemType, weaponType: weaponType, value: value, pos: pos)
            guard let dataObj = NetworkHelper.encodeAndSend(netData: hitByBulletMsg) else {
                return
            }
            self.sendData(match: match, data: dataObj, with: .reliable)
//            if(NetworkHelper.dbgMode){
//                print(dataObj.prettyPrintedJSONString!)
//            }
//            try match.sendData(toAllPlayers: dataObj, with: .reliable)
//            self.msgSentCounter += 1
//            self.game.showDbgMsg(dbgMsg: "Sent turnDir: \(turnDir.rawValue)")
//        } catch {
//            self.game.showDbgMsg(dbgMsg: "Send data failed")
//        }
    }
    
    func sendData(msgTyp:MsgType, data:Any? = nil) {
        self.sendData(match: self.match, msgTyp: msgTyp, data: data)
    }
    
    func sendData(match:GKMatch, msgTyp:MsgType, data:Any? = nil) {
//        do {
            self.game.showDbgMsg(dbgMsg: "SENDING Suake3D-MSG: Type: \(msgTyp)")
            if(msgTyp == .setupClientServerMsg){
                self.setupClientServerData = SetupClientServerNetworkData(id: self.msgSentCounter)
                self.setupClientServerData.addHost(playerId: self.dbgServerPlayerId, playerName: "DaVe inc.", hostType: .server)
                self.ownPlayerNetObj = self.setupClientServerData.clientServerData.first
                self.setupClientServerData.addHost(playerId: self.dbgClientPlayerId, playerName: "JeTeDonner", hostType: .client)
                guard let dataLoadLevel = NetworkHelper.encodeAndSend(netData: self.setupClientServerData) else {
                    return
                }
//                if(NetworkHelper.dbgMode){
//                    print(dataLoadLevel.prettyPrintedJSONString!)
//                }
//                try match.sendData(toAllPlayers: dataLoadLevel, with: .reliable)
                self.sendData(match: match, data: dataLoadLevel, with: .reliable)
            }else if(msgTyp == .ready4MatchMsg){
                let sendData = Ready4MatchNetworkData(id: self.msgSentCounter)
                guard let dataReady4Match = NetworkHelper.encodeAndSend(netData: sendData) else {
                    return
                }
//                if(NetworkHelper.dbgMode){
//                    print(dataReady4Match.prettyPrintedJSONString!)
//                }
//                try match.send(dataReady4Match, to: [self.dbgServerGKPlayer], dataMode: .reliable)
                self.sendData(match: match, data: dataReady4Match, with: .reliable)
            }else if(msgTyp == .startMatchMsg){
                let sendData = StartMatchNetworkData(id: self.msgSentCounter)
                guard let dataStartMatch = NetworkHelper.encodeAndSend(netData: sendData) else {
                    return
                }
//                if(NetworkHelper.dbgMode){
//                    print(dataStartMatch.prettyPrintedJSONString!)
//                }
//                try match.sendData(toAllPlayers: dataStartMatch, with: .reliable)
                self.sendData(match: match, data: dataStartMatch, with: .reliable)
                self.game.multiplayer(startMatch: sendData)
            }else if(msgTyp == .initLevelMsg){
                let sendData:LoadLevelNetworkData = LoadLevelNetworkData(id: self.msgSentCounter)
                
                sendData.levelConfig.levelEnv = LevelEnvironment(levelSize: self.game.usrDefHlpr.levelSize, floorType: .Debug, skyBoxType: .RedGalaxy, matchDuration: self.game.usrDefHlpr.matchDuration, levelDifficulty: self.game.usrDefHlpr.difficulty, lightIntensity: self.game.usrDefHlpr.lightIntensity)
                
                sendData.addHost(playerId: self.dbgServerPlayerId, playerName: "DaVe inc.", hostType: .server)
                self.ownPlayerNetObj = sendData.levelClientServer.first
                sendData.addHost(playerId: self.dbgClientPlayerId, playerName: "JeTeDonner", hostType: .client)
                
                sendData.players.humanPlayers[self.dbgServerPlayerId] = self.dbgServerPlayerName
                sendData.players.humanPlayers[self.dbgClientPlayerId] = self.dbgClientPlayerName
                sendData.players.droidPlayerCount = self.game.usrDefHlpr.droidCount
                sendData.levelConfig.levelSetup.droidPosDir = [SuakePosDir(pos:SCNVector3(3, 0, 3), dir: .DOWN)]
                sendData.levelConfig.levelPlayers.droidPlayerCount = self.game.usrDefHlpr.droidCount
//                sendData.levelConfig.levelPlayers.loadDroids = true
                
                guard let dataLoadLevel = NetworkHelper.encodeAndSend(netData: sendData) else {
                    return
                }
//                if(NetworkHelper.dbgMode){
//                    print(dataLoadLevel.prettyPrintedJSONString!)
//                }
//                try match.sendData(toAllPlayers: dataLoadLevel, with: .reliable)
                self.sendData(match: match, data: dataLoadLevel, with: .reliable)
                self.game.multiplayerLoad(levelConfigNet: sendData)
            }else if(msgTyp == .shootWeaponMsg){
                let shootData:ShootWeaponNetworkData = ShootWeaponNetworkData(id: self.msgSentCounter)
                shootData.origin = self.game.playerEntityManager.oppPlayerEntity.cameraComponent.cameraNodeFP.position
                shootData.velocity = self.game.playerEntityManager.ownPlayerEntity.cameraComponent.cameraNodeFP.worldFront
                guard let dataShootWeapon = NetworkHelper.encodeAndSend(netData: shootData) else {
                    return
                }
//                if(NetworkHelper.dbgMode){
//                    print(dataShootWeapon.prettyPrintedJSONString!)
//                }
//                try match.sendData(toAllPlayers: dataShootWeapon, with: .unreliable)
                self.sendData(match: match, data: dataShootWeapon, with: .unreliable)
                self.game.shootWeaponNetworkMatch(shootData: shootData)
            }
//            self.msgSentCounter += 1
//        } catch {
//            print("Send data failed")
//        }
    }
    
    func sendData(match:GKMatch, data:Data, with mode: GKMatch.SendDataMode = .reliable) {
        do {
            if(NetworkHelper.dbgMode){
                print(data.prettyPrintedJSONString!)
            }
            try match.sendData(toAllPlayers: data, with: mode)
            self.msgSentCounter += 1
        } catch {
            print("Send data failed")
        }
    }
    
    func match(_ match: GKMatch, didReceive data: Data, forRecipient recipient: GKPlayer, fromRemotePlayer player: GKPlayer) {
        self.game.showDbgMsg(dbgMsg: "RECEIVING Suake3D-MSG (No: \(self.msgRecvCounter)) ...")
        self.msgRecvCounter += 1
        if(self.match != match){
            self.game.showDbgMsg(dbgMsg: "self.match != match")
            return
        }
        self.game.showDbgMsg(dbgMsg: data.prettyPrintedJSONString! as String)
        let newObj:BaseNetworkData = NetworkHelper().receiveAndDecode(data: data)
        self.game.showDbgMsg(dbgMsg: "Suake3D-MSG: Type: \(newObj.msgType  )")
        if(newObj.msgType == .initLevelMsg){
            self.game.multiplayerLoad(levelConfigNet: newObj as! LoadLevelNetworkData)
        }else if(newObj.msgType == .setupClientServerMsg){
//            self.game.overlayManager.gameCenterOverlay.setProgress(curPrecent: 25, msg: "Loading level for match ...")
            self.dbgServerGKPlayer = player
            self.setupClientServerData = newObj as? SetupClientServerNetworkData
            self.ownPlayerNetObj = self.setupClientServerData.clientServerData.last
            self.game.multiplayerSet(setupNet: self.setupClientServerData)
        }else if(newObj.msgType == .ready4MatchMsg){
            self.game.showDbgMsg(dbgMsg: "CLIENT's ready 4 Match .... ")
            self.sendStartMatchMsg()
        }else if(newObj.msgType == .startMatchMsg){
            self.game.multiplayer(startMatch: newObj as! StartMatchNetworkData)
        }else if(newObj.msgType == .pickedUpMsg){
            self.game.showDbgMsg(dbgMsg: "Goody PICKED-UP .... ")
            self.game.pickedUpNetworkMatch(pickedUpData: newObj as! PickedUpNetworkData)
        }else if(newObj.msgType == .hitByBulletMsg){
            self.game.showDbgMsg(dbgMsg: "Goody Hit By Bullet .... ")
            self.game.hitByBulletNetworkMatch(hitByBulletData: newObj as! HitByBulletNetworkData)
        }else if(newObj.msgType == .turnMsg){
            self.game.turnDirNetworkMatch(turnData: newObj as! TurnNetworkData)
        }else if(newObj.msgType == .droidPathMsg){
            self.game.droidPathNetworkMatch(droidDirData: newObj as! DroidPathNetworkData)
        }else if(newObj.msgType == .shootWeaponMsg){
            self.game.shootWeaponNetworkMatch(shootData: newObj as! ShootWeaponNetworkData)
        }
    }
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if(self.match != match){
            return
        }
        self.game.showDbgMsg(dbgMsg: data.prettyPrintedJSONString! as String)
        let newObj:BaseNetworkData = NetTestFW.NetworkHelper().receiveAndDecode(data: data)
        self.game.showDbgMsg(dbgMsg: "\(newObj.msgType)")
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        self.game.showDbgMsg(dbgMsg: SuakeMsgs.gameCenterMsg + "match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState)")
        if(state == .disconnected){
            for i in 0..<self.setupClientServerData.clientServerData.count{
                if( self.setupClientServerData.clientServerData[i].playerId == player.playerIDNG){
                    self.game.overlayManager.hud.showMsg(msg: "Player \(i + 1) disconnected!")
                    self.game.playerEntityManager.oppPlayerEntity.playerDied(removeFromScene: true)
                    self.game.showDbgMsg(dbgMsg: SuakeMsgs.gameCenterMsg + "DISCONNETING: PlayerID: \(player.playerIDNG)")
                    self.setupClientServerData.clientServerData.remove(at: i)
                    break
                }
            }
        }
//        if(state == .connected){
//            if(match.expectedPlayerCount == 0){
//                if(match.players[0].gamePlayerID == GKLocalPlayer.local.gamePlayerID){
//                    match.chooseBestHostingPlayer(completionHandler: {player in
//                        print("PlayerName: \(player?.displayName), PlayerID: \(player?.gamePlayerID)")
//        //                self.delegate?.startMatch(match: match)
//        //                self.sendDataNG(match: match)
//                    })
//                }
//            }
//        }
    }
}
