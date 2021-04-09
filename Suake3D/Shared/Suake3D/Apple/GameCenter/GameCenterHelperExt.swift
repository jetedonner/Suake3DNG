//
//  GameCenterHelperExt.swift
//  Suake3D
//
//  Created by Kim David Hauser on 06.04.21.
//

import Foundation
import GameKit
import NetTestFW

extension GameCenterHelper: GKLocalPlayerListener, GKMatchmakerViewControllerDelegate {
    
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        print("player(_ player: GKPlayer, didAccept invite: GKInvite)")
        let mmc:GKMatchmakerViewController = GKMatchmakerViewController(invite: invite)!
        mmc.matchmakerDelegate = self
        self.viewController?.presentAsSheet(mmc)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        print(SuakeMsgs.gameConterMsg + "matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) ")
        
        viewController.dismiss(true)
        self.delegate?.startMatch(match: match)
        
        while match.expectedPlayerCount != 0 {
            print("Current player count: \(match.players.count)")
        }

        
        print("Local-Player:\n- PlayerId: \(GKLocalPlayer.local.playerID)\n- PlayerName: \(GKLocalPlayer.local.displayName)\n- Team: \(GKLocalPlayer.local.teamPlayerID)\n- GamePlayerID: \(GKLocalPlayer.local.gamePlayerID)")
        self.players.append(GKLocalPlayer.local)
        
        for player in match.players{
            print("Match-Player:\n- PlayerId: \(player.playerID)\n- PlayerName: \(player.displayName)\n- Team: \(player.teamPlayerID)\n- GamePlayerID: \(player.gamePlayerID)")
            self.players.append(player)
        }
        
        if(GKLocalPlayer.local.playerID == self.matchMakerHelper!.dbgServerPlayerId){
            self.matchMakerHelper!.sendData(match: match, msgTyp: .setupClientServerMsg, data: self.players)
        }
        
// ====  CHOOSE BEST HOSTING PLAYER ====
// ##
// ##     match.chooseBestHostingPlayer(completionHandler: { player in
//            print("BEST HOSTING PLAYER =>\n- PlayerId: \(player?.playerID)\n- PlayerName: \(player?.displayName)\n- Team: \(player?.teamPlayerID)\n- GamePlayerID: \(player?.gamePlayerID)")
//
        
//            DispatchQueue.main.async {
//                self.game.overlayManager.gameCenterOverlay.stopProgressInfinite()
//                self.game.overlayManager.gameCenterOverlay.setProgress(curPrecent: 25, msg: "Loading level for match ...")
//            }
//
//        })
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFindHostedPlayers players: [GKPlayer]){
        print(SuakeMsgs.gameConterMsg + "matchmakerViewController(_ viewController: GKMatchmakerViewController, didFindHostedPlayers players: [GKPlayer])")
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        print(SuakeMsgs.gameConterMsg + "matchmakerViewControllerWasCancelled()")
        viewController.dismiss(true)
    }

    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print(SuakeMsgs.gameConterMsg + "matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error)")
        print("> Matchmaker vc did fail with error: \(error.localizedDescription).")
    }
    
    func presentMatchmaker() {
      guard GKLocalPlayer.local.isAuthenticated else {
        return
      }
      
      let request = GKMatchRequest()
      
      request.minPlayers = 2
      request.maxPlayers = 2
      request.defaultNumberOfPlayers = 2
      request.inviteMessage = "Would you like to play Suake3D?"
      let vc = GKMatchmakerViewController(matchRequest: request)
      vc?.matchmakerDelegate = self
      self.viewController?.presentAsSheet(vc!)
    }
    
//    private func sendDataNG(match:GKMatch, msgTyp:MsgType, data:Any? = nil) {
//        do {
//            if(msgTyp == .setupClientServerMsg){
//                let netData:SetupClientServerNetworkData = SetupClientServerNetworkData(id: 1)
//                netData.addHost(playerId: self.dbgServerPlayerId /*(data as! [GKPlayer])[0].playerID*/, hostType: .server)
//                netData.addHost(playerId: self.dbgClientPlayerId /*(data as! [GKPlayer])[0].playerID*/, hostType: .client)
//                guard let dataLoadLevel = NetworkHelper.encodeAndSend(netData: netData) else {
//                    return
//                }
//                print(dataLoadLevel.prettyPrintedJSONString!)
//                try match.sendData(toAllPlayers: dataLoadLevel, with: .reliable)
//                
//            }else if(msgTyp == .initLevelMsg){
//                guard let dataLoadLevel = NetworkHelper.encodeAndSend(netData: LoadLevelNetworkData(id: 2)) else {
//                    return
//                }
//                print(dataLoadLevel.prettyPrintedJSONString!)
//                try match.sendData(toAllPlayers: dataLoadLevel, with: .reliable)
//            }
//        } catch {
//            print("Send data failed")
//        }
//    }
}
