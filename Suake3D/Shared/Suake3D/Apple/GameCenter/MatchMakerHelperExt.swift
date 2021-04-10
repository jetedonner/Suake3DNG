//
//  MatchMakerHelperExt.swift
//  Suake3D
//
//  Created by Kim David Hauser on 10.04.21.
//

import Foundation
import GameKit
import NetTestFW

extension MatchMakerHelper{
    
    func sendReady4MatchMsg(){
        for host in self.setupClientServerData.clientServerData{
            if(host.playerId == GKLocalPlayer.local.playerID){
                self.sendData(match: self.match, msgTyp: .ready4MatchMsg)
                break
            }
        }
    }
    
    func sendStartMatchMsg(){
        for host in self.setupClientServerData.clientServerData{
            if(host.playerId == GKLocalPlayer.local.playerID){
                self.sendData(match: self.match, msgTyp: .startMatchMsg)
                break
            }
        }
    }
}
