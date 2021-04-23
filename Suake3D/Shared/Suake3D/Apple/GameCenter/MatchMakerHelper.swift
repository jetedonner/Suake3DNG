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
//    var voiceChat:GKVoiceChat!
    
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
//        self.voiceChat = self.match.voiceChat(withName: "Suake3DChat")
//        self.voiceChat.start()
    }
    
    func sendTurnMsg(turnDir:TurnDir, position:SCNVector3) {
        do{
            let turnMsg:TurnNetworkData = TurnNetworkData(id: self.msgSentCounter, turnDir: turnDir, position: position, playerId: self.dbgServerPlayerId)
            guard let dataObj = NetworkHelper.encodeAndSend(netData: turnMsg) else {
                return
            }
            if(NetworkHelper.dbgMode){
                print(dataObj.prettyPrintedJSONString!)
            }
            try match.sendData(toAllPlayers: dataObj, with: .reliable)
            self.game.turnDirNetworkMatch(turnData: turnMsg)
            self.msgSentCounter += 1
            self.game.showDbgMsg(dbgMsg: "Sent turnDir: \(turnDir.rawValue)")
        } catch {
            print("Send data failed")
        }
    }
    
    func sendData(msgTyp:MsgType, data:Any? = nil) {
        self.sendData(match: self.match, msgTyp: msgTyp, data: data)
    }
    
    func sendData(match:GKMatch, msgTyp:MsgType, data:Any? = nil) {
        do {
            print("SENDING Suake3D-MSG: Type: \(msgTyp)")
            if(msgTyp == .setupClientServerMsg){
                self.setupClientServerData = SetupClientServerNetworkData(id: self.msgSentCounter)
                self.setupClientServerData.addHost(playerId: self.dbgServerPlayerId, playerName: "DaVe inc.", hostType: .server)
                self.ownPlayerNetObj = self.setupClientServerData.clientServerData.first
                self.setupClientServerData.addHost(playerId: self.dbgClientPlayerId, playerName: "JeTeDonner", hostType: .client)
                guard let dataLoadLevel = NetworkHelper.encodeAndSend(netData: self.setupClientServerData) else {
                    return
                }
                if(NetworkHelper.dbgMode){
                    print(dataLoadLevel.prettyPrintedJSONString!)
                }
                try match.sendData(toAllPlayers: dataLoadLevel, with: .reliable)
            }else if(msgTyp == .ready4MatchMsg){
                let sendData = Ready4MatchNetworkData(id: self.msgSentCounter)
                guard let dataReady4Match = NetworkHelper.encodeAndSend(netData: sendData) else {
                    return
                }
                if(NetworkHelper.dbgMode){
                    print(dataReady4Match.prettyPrintedJSONString!)
                }
                try match.send(dataReady4Match, to: [self.dbgServerGKPlayer], dataMode: .reliable)
            }else if(msgTyp == .startMatchMsg){
                let sendData = StartMatchNetworkData(id: self.msgSentCounter)
                guard let dataStartMatch = NetworkHelper.encodeAndSend(netData: sendData) else {
                    return
                }
                if(NetworkHelper.dbgMode){
                    print(dataStartMatch.prettyPrintedJSONString!)
                }
                try match.sendData(toAllPlayers: dataStartMatch, with: .reliable)
                self.game.loadNetworkMatch3(startMatch: sendData)
            }else if(msgTyp == .initLevelMsg){
                let sendData:LoadLevelNetworkData = LoadLevelNetworkData(id: self.msgSentCounter)
                
                sendData.addHost(playerId: self.dbgServerPlayerId, playerName: "DaVe inc.", hostType: .server)
                self.ownPlayerNetObj = sendData.levelClientServer.first
                sendData.addHost(playerId: self.dbgClientPlayerId, playerName: "JeTeDonner", hostType: .client)
                
                sendData.players.humanPlayers[self.dbgServerPlayerId] = self.dbgServerPlayerName
                sendData.players.humanPlayers[self.dbgClientPlayerId] = self.dbgClientPlayerName
                
                sendData.levelConfig.levelPlayers.droidPlayerCount = self.game.usrDefHlpr.droidCount
                
                guard let dataLoadLevel = NetworkHelper.encodeAndSend(netData: sendData) else {
                    return
                }
                if(NetworkHelper.dbgMode){
                    print(dataLoadLevel.prettyPrintedJSONString!)
                }
                try match.sendData(toAllPlayers: dataLoadLevel, with: .reliable)
                self.game.loadNetworkMatch(levelConfigNet: sendData)
            }else if(msgTyp == .shootWeaponMsg){
                let shootData:ShootWeaponNetworkData = ShootWeaponNetworkData(id: self.msgSentCounter)
                shootData.origin = self.game.playerEntityManager.oppPlayerEntity.cameraComponent.cameraNodeFP.position
                guard let dataShootWeapon = NetworkHelper.encodeAndSend(netData: shootData) else {
                    return
                }
                if(NetworkHelper.dbgMode){
                    print(dataShootWeapon.prettyPrintedJSONString!)
                }
                try match.sendData(toAllPlayers: dataShootWeapon, with: .unreliable)
                self.game.shootWeaponNetworkMatch(shootData: shootData)
            }else if(msgTyp == .shootWeaponMsg){
                
            }
            self.msgSentCounter += 1
        } catch {
            print("Send data failed")
        }
    }
    
    func match(_ match: GKMatch, didReceive data: Data, forRecipient recipient: GKPlayer, fromRemotePlayer player: GKPlayer) {
        print("RECEIVING Suake3D-MSG (No: \(self.msgRecvCounter)) ...")
        self.msgRecvCounter += 1
        if(self.match != match){
            print("self.match != match")
            return
        }
        print(data.prettyPrintedJSONString!)
        let newObj:BaseNetworkData = NetworkHelper().receiveAndDecode(data: data)
        print("Suake3D-MSG: Type: \(newObj.msgType  )")
        if(newObj.msgType == .initLevelMsg){
            self.game.loadNetworkMatch(levelConfigNet: newObj as! LoadLevelNetworkData)
        }else if(newObj.msgType == .setupClientServerMsg){
//            self.game.overlayManager.gameCenterOverlay.setProgress(curPrecent: 25, msg: "Loading level for match ...")
            self.dbgServerGKPlayer = player
            self.setupClientServerData = newObj as? SetupClientServerNetworkData
            self.ownPlayerNetObj = self.setupClientServerData.clientServerData.last
            self.game.loadNetworkMatch2(setupNet: self.setupClientServerData)
        }else if(newObj.msgType == .ready4MatchMsg){
            print("CLIENT's ready 4 Match .... ")
            self.sendStartMatchMsg()
        }else if(newObj.msgType == .startMatchMsg){
            self.game.loadNetworkMatch3(startMatch: newObj as! StartMatchNetworkData)
        }else if(newObj.msgType == .turnMsg){
            self.game.turnDirNetworkMatch(turnData: newObj as! TurnNetworkData)
        }else if(newObj.msgType == .shootWeaponMsg){
            self.game.shootWeaponNetworkMatch(shootData: newObj as! ShootWeaponNetworkData)
        }
    }
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if(self.match != match){
            return
        }
        print(data.prettyPrintedJSONString!)
        let newObj:BaseNetworkData = NetTestFW.NetworkHelper().receiveAndDecode(data: data)
        print(newObj.msgType)
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        print(SuakeMsgs.gameCenterMsg + "match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState)")
        if(state == .disconnected){
            for i in 0..<self.setupClientServerData.clientServerData.count{
                if( self.setupClientServerData.clientServerData[i].playerId == player.playerIDNG){
                    self.game.overlayManager.hud.showMsg(msg: "Player \(i) disconnected!")
                    self.game.playerEntityManager.oppPlayerEntity.playerDied()
                    print(SuakeMsgs.gameCenterMsg + "DISCONNETING: PlayerID: \(player.playerIDNG)")
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
