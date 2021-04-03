//
//  MatchmakerHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 16.03.21.
//

import Foundation
import GameKit
import NetTestFW

protocol GameCenterHelperDelegate: class {
    func didChangeAuthStatus(isAuthenticated: Bool)
    func presentGameCenterAuth(viewController: NSViewController?)
    func presentMatchmaking(viewController: NSViewController?)
    func presentGame(match: GKMatch)
    
    // func startGame
    // - func initLevel
    // - func initMatch
    
    // func turnDirChanged
    
    // func endGame
}

extension GameCenterHelper:GKMatchmakerViewControllerDelegate, GKMatchDelegate {
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        print(SuakeMsgs.gameConterMsg + "matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) ")
        viewController.dismiss(true)
        self.match = match
        delegate?.presentGame(match: match)
        self.sendData()
    }
    
    func match(theMatch: GKMatch!, didReceiveData data: NSData!, fromPlayer playerID: String!) {
        if (match != theMatch) {
            return
        }
//        delegate.match(theMatch, didReceiveData: data, fromPlayer: playerID)
    }
    
    
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        
        let mmc:GKMatchmakerViewController = GKMatchmakerViewController(invite: invite)!
        mmc.matchmakerDelegate = self
        self.viewController?.presentAsSheet(mmc)
//        currentVC?.dismiss(true/*, completion: {
//            self.presentMatchmaker(withInvite: invite)
//        }*/)
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
    
    func presentMatchmaker(withInvite invite: GKInvite? = nil) {
        guard GKLocalPlayer.local.isAuthenticated,
              let vc = createMatchmaker(withInvite: invite) else {
            return
        }
        
        currentVC = vc
        vc.matchmakerDelegate = self
        delegate?.presentMatchmaking(viewController: vc)
    }
    
    private func createMatchmaker(withInvite invite: GKInvite? = nil) -> GKMatchmakerViewController? {
        
        //If there is an invite, create the matchmaker vc with it
        if let invite = invite {
            return GKMatchmakerViewController(invite: invite)
        }
        
        return GKMatchmakerViewController(matchRequest: createRequest())
    }
    
    private func createRequest() -> GKMatchRequest {
        let request = GKMatchRequest()
        request.defaultNumberOfPlayers = self.minPlayers
        request.minPlayers = self.minPlayers
        request.maxPlayers = self.maxPlayers
        request.inviteMessage = self.inviteMessage
        
        return request
    }
    
    private func sendData() {
        guard let match = match else { return }
        
        do {
            guard let data = gameModel.encode() else { return }
            try match.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("Send data failed")
        }
    }
}

class SuakeNetworkData: Codable {
    var playerId:Int = 0
}

class PlayerMoveData: SuakeNetworkData {
//    var players: [Player] = []
//    var time: Int = 60
//    var playerId:Int = 0
    var nextPos:SIMD3<Float> = SIMD3<Float>(0, 0, 0)
    var nextTurnDir:TurnDir = .Straight
    var nextDir:SuakeDir = .UP
}

extension PlayerMoveData {
    func encode() -> Data? {
        let retData:Data = try! JSONEncoder().encode(self)
        return retData
    }
    
    static func decode(data: Data) -> PlayerMoveData? {
        return try? JSONDecoder().decode(PlayerMoveData.self, from: data)
    }
}

//extension SuakeNetworkData {
//    func encode() -> Data? {
//        return try? JSONEncoder().encode(self)
//    }
//
//    static func decode(data: Data) -> SuakeNetworkData? {
//        return try? JSONDecoder().decode(SuakeNetworkData.self, from: data)
//    }
//}


struct GameModel: Codable {
//    var players: [Player] = []
    var time: Int = 60
}

extension GameModel {
    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static func decode(data: Data) -> GameModel? {
        return try? JSONDecoder().decode(GameModel.self, from: data)
    }
}
