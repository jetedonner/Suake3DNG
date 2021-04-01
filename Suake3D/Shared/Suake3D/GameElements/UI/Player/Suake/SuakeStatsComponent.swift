//
//  SuakeStatsComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 20.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeStatsComponent: SuakeBaseComponent {
    
    let playerEntity:SuakeBasePlayerEntity
    let suakeStats:SuakeStats
    
    init(game: GameController, playerEntity:SuakeBasePlayerEntity) {
        self.playerEntity = playerEntity
        self.suakeStats = SuakeStats(playerEntity: playerEntity)
        super.init(game: game)
    }
    
    func getStatsValue(suakeStatsType:SuakeStatsType)->Int{
        return self.suakeStats.getStatsValue(suakeStatsType: suakeStatsType)
    }
    
    func add2StatsValue(suakeStatsType:SuakeStatsType, value:Int = 1){
        self.suakeStats.add2StatsValue(suakeStatsType: suakeStatsType, value: value)
    }
    
    func addNewStats(statsType:SuakeStatsType, score:Int = 0, count:Int = 1){
        self.add2StatsValue(suakeStatsType: .score, value: score)
        self.add2StatsValue(suakeStatsType: statsType, value: count)
        if(self.playerEntity.playerType == .OwnSuake){
            self.game.overlayManager.hud.setScore(score: self.getStatsValue(suakeStatsType: .score))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
