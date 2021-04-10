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
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func setMatch(match:GKMatch){
        self.match = match
        self.match.delegate = self
//        self.voiceChat = self.match.voiceChat(withName: "Suake3DChat")
//        self.voiceChat.start()
    }
    
    func sendData(match:GKMatch, msgTyp:MsgType, data:Any? = nil) {
        do {
            print("SENDING Suake3D-MSG: Type: \(msgTyp)")
            if(msgTyp == .setupClientServerMsg){
                self.setupClientServerData = SetupClientServerNetworkData(id: self.msgSentCounter)
                self.setupClientServerData.addHost(playerId: self.dbgServerPlayerId /*(data as! [GKPlayer])[0].playerID*/, hostType: .server)
                self.ownPlayerNetObj = self.setupClientServerData.clientServerData.first
                self.setupClientServerData.addHost(playerId: self.dbgClientPlayerId /*(data as! [GKPlayer])[0].playerID*/, hostType: .client)
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
//                try match.sendData(toAllPlayers: dataLoadLevel, with: .reliable)
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
                let sendData = LoadLevelNetworkData(id: self.msgSentCounter)
                guard let dataLoadLevel = NetworkHelper.encodeAndSend(netData: sendData) else {
                    return
                }
                if(NetworkHelper.dbgMode){
                    print(dataLoadLevel.prettyPrintedJSONString!)
                }
                try match.sendData(toAllPlayers: dataLoadLevel, with: .reliable)
                self.game.loadNetworkMatch(levelConfigNet: sendData)
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
        let newObj:BaseNetworkData = NetTestFW.NetworkHelper().receiveAndDecode(data: data)
        print("Suake3D-MSG: Type: \(newObj.msgType  )")
        if(newObj.msgType == .setupClientServerMsg){
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
        }else if(newObj.msgType == .initLevelMsg){
            self.game.loadNetworkMatch(levelConfigNet: newObj as! LoadLevelNetworkData)
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
                if( self.setupClientServerData.clientServerData[i].playerId == player.playerID){
                    print(SuakeMsgs.gameCenterMsg + "DISCONNETING: PlayerID: \(player.playerID)")
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
