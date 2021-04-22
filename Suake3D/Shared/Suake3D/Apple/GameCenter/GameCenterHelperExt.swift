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
        print(SuakeMsgs.gameCenterMsg + "matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) ")
        
        viewController.dismiss(true)
        self.delegate?.startMatch(match: match)
        
        while match.expectedPlayerCount != 0 {
            print("Current player count: \(match.players.count)")
        }
        
        print("Local-Player:\n- PlayerId: \(GKLocalPlayer.local.playerIDNG)\n- PlayerName: \(GKLocalPlayer.local.displayName)\n- Team: \(GKLocalPlayer.local.teamPlayerID)\n- GamePlayerID: \(GKLocalPlayer.local.gamePlayerID)")
        self.matchMakerHelper.players.append(GKLocalPlayer.local)
        
        for player in match.players{
            print("Match-Player:\n- PlayerId: \(player.playerIDNG)\n- PlayerName: \(player.displayName)\n- Team: \(player.teamPlayerID)\n- GamePlayerID: \(player.gamePlayerID)")
            self.matchMakerHelper.players.append(player)
        }
        
        if(GKLocalPlayer.local.playerIDNG == self.matchMakerHelper.dbgServerPlayerId){
            self.matchMakerHelper.sendData(match: match, msgTyp: .setupClientServerMsg, data: self.matchMakerHelper.players)
            self.matchMakerHelper.sendData(match: match, msgTyp: .initLevelMsg)
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
        print(SuakeMsgs.gameCenterMsg + "matchmakerViewController(_ viewController: GKMatchmakerViewController, didFindHostedPlayers players: [GKPlayer])")
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        print(SuakeMsgs.gameCenterMsg + "matchmakerViewControllerWasCancelled()")
        viewController.dismiss(true)
    }

    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print(SuakeMsgs.gameCenterMsg + "matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error)")
        print("> Matchmaker vc did fail with error: \(error.localizedDescription).")
    }
    
    func presentMatchmaker() {
        guard GKLocalPlayer.local.isAuthenticated else {
            return
        }
        self.matchMakerHelper.dbgClientGKPlayers.removeAll()
        let request = GKMatchRequest()

        request.minPlayers = self.matchMakerHelper.minPlayers
        request.maxPlayers = self.matchMakerHelper.maxPlayers
        request.defaultNumberOfPlayers = self.matchMakerHelper.minPlayers
        request.inviteMessage = "Would you like to play Suake3D?"
        let vc = GKMatchmakerViewController(matchRequest: request)
        vc?.matchmakerDelegate = self
        self.viewController?.presentAsSheet(vc!)
    }
}
