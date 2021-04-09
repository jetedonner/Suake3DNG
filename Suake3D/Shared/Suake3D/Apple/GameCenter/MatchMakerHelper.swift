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
    
    var match:GKMatch!
//    var voiceChat:GKVoiceChat!
    
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
            if(msgTyp == .setupClientServerMsg){
                let netData:SetupClientServerNetworkData = SetupClientServerNetworkData(id: 1)
                netData.addHost(playerId: self.dbgServerPlayerId /*(data as! [GKPlayer])[0].playerID*/, hostType: .server)
                netData.addHost(playerId: self.dbgClientPlayerId /*(data as! [GKPlayer])[0].playerID*/, hostType: .client)
                guard let dataLoadLevel = NetworkHelper.encodeAndSend(netData: netData) else {
                    return
                }
                print(dataLoadLevel.prettyPrintedJSONString!)
                try match.sendData(toAllPlayers: dataLoadLevel, with: .reliable)
                
            }else if(msgTyp == .initLevelMsg){
                guard let dataLoadLevel = NetworkHelper.encodeAndSend(netData: LoadLevelNetworkData(id: 2)) else {
                    return
                }
                print(dataLoadLevel.prettyPrintedJSONString!)
                try match.sendData(toAllPlayers: dataLoadLevel, with: .reliable)
            }
        } catch {
            print("Send data failed")
        }
    }
    
    func match(_ match: GKMatch, didReceive data: Data, forRecipient recipient: GKPlayer, fromRemotePlayer player: GKPlayer) {
        if(self.match != match){
            return
        }
        print(data.prettyPrintedJSONString!)
        let newObj:BaseNetworkData = NetTestFW.NetworkHelper().receiveAndDecode(data: data)
        print(newObj.msgType)
        if(newObj.msgType == .setupClientServerMsg){
//            self.game.overlayManager.gameCenterOverlay.setProgress(curPrecent: 25, msg: "Loading level for match ...")
            self.game.loadNetworkMatch2(setupNet: newObj as! SetupClientServerNetworkData)
        }else if(newObj.msgType == .initLevelMsg){
            self.game.overlayManager.gameCenterOverlay.setProgress(curPrecent: 25, msg: "Loading level for match ...")
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
        print(SuakeMsgs.gameConterMsg + "match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState)")
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
