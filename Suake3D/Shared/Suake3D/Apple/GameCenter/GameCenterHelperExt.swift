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

        print("Local-Player:\n- PlayerId: \(GKLocalPlayer.local.playerID)\n-  PlayerName: \(GKLocalPlayer.local.displayName)\n- Team: \(GKLocalPlayer.local.teamPlayerID)\n-  GamePlayerID: \(GKLocalPlayer.local.gamePlayerID)")
        
        for player in match.players{
            print("Match-Player:\n- PlayerId: \(player.playerID)\n-  PlayerName: \(GKLocalPlayer.local.displayName)\n-  Team: \(player.teamPlayerID)\n-  GamePlayerID: \(player.gamePlayerID)")
        }
        
        match.chooseBestHostingPlayer(completionHandler: { player in
            
            print("BEST HOSTING PLAYER =>\n- PlayerId: \(player?.playerID)\n- PlayerName: \(player?.displayName)\n- Team: \(player?.teamPlayerID)\n- GamePlayerID: \(player?.gamePlayerID)")

//            self.sendDataNG(match: match)
        })
//        if(match.players[0].gamePlayerID == GKLocalPlayer.local.gamePlayerID){
//            match.chooseBestHostingPlayer(completionHandler: {player in
//                print("PlayerName: \(player?.displayName), PlayerID: \(player?.gamePlayerID)")
////                self.delegate?.startMatch(match: match)
////                self.sendDataNG(match: match)
//            })
//        }
//        self.delegate?.startMatch(match: match)
//        self.sendDataNG(match: match)
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
    
//      currentMatchmakerVC2 = vc
      self.viewController?.presentAsSheet(vc!)
    }
    
    private func sendDataNG(match:GKMatch) {
//        guard let match = match else { return }
        
        do {
            guard let dataLoadLevel = NetTestFW.NetworkHelper.encodeAndSend(netData: NetTestFW.LoadLevelNetworkData(id: 1)) else {
                return
            }
            print(dataLoadLevel.prettyPrintedJSONString!)
//            guard let data = gameModel.encode() else { return }
            try match.sendData(toAllPlayers: dataLoadLevel, with: .reliable)
        } catch {
            print("Send data failed")
        }
    }
//    func presentMatchmaker(withInvite invite: GKInvite? = nil) {
//        guard GKLocalPlayer.local.isAuthenticated,
//              let vc = createMatchmaker(withInvite: invite) else {
//            return
//        }
//        
//        currentVC = vc
//        vc.matchmakerDelegate = self
////        delegate?.presentMatchmaking(viewController: vc)
//    }
//    
//    private func createMatchmaker(withInvite invite: GKInvite? = nil) -> GKMatchmakerViewController? {
//        
//        //If there is an invite, create the matchmaker vc with it
//        if let invite = invite {
//            return GKMatchmakerViewController(invite: invite)
//        }
//        
//        return GKMatchmakerViewController(matchRequest: createRequest())
//    }
//    
//    private func createRequest() -> GKMatchRequest {
//        let request = GKMatchRequest()
//        request.defaultNumberOfPlayers = self.minPlayers
//        request.minPlayers = self.minPlayers
//        request.maxPlayers = self.maxPlayers
//        request.inviteMessage = self.inviteMessage
//        
//        return request
//    }
    
}
