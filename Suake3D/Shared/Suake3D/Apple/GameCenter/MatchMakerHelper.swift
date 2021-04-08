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
    
    func match(_ match: GKMatch, didReceive data: Data, forRecipient recipient: GKPlayer, fromRemotePlayer player: GKPlayer) {
        if(self.match != match){
            return
        }
        print(data.prettyPrintedJSONString!)
        let newObj:BaseNetworkData = NetTestFW.NetworkHelper().receiveAndDecode(data: data)
        print(newObj.msgType)
        if(newObj.msgType == .initLevelMsg){
            self.game.overlayManager.gameCenterOverlay.setProgress(curPrecent: 10, msg: "Loading level for match ...")
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
