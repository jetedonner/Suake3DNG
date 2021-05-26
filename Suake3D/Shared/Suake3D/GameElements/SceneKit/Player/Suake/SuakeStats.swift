//
//  SuakeStats.swift
//  Suake3D
//
//  Created by Kim David Hauser on 24.03.21.
//

import Foundation

enum SuakeStatsType:String, CaseIterable{
    case score = "Total score"
    case weaponsPickedUp = "Weapons picked up"
    case goodyCatched = "Goody catched"
    case droidKilled = "Droid killed"
    case opponetKilled = "Opponent killed"
    case ownKilled = "Own killed"
    case medKitCollectd = "MedKit collected"
    case teleportations = "Teleportations"
    case frags = "Frags"
    case hits = "Hits"
    case deaths = "Deaths"
}

class SuakeStatsClass{
    
    var statsType:SuakeStatsType = .score
    
    var _value:Int = 0
    var value:Int{
        get{ return self._value }
        set{ self._value = newValue }
    }
    
    func add2Stats(value2Add:Int){
        self.value += value2Add
    }
    
}

class SuakeStats {
    
    let playerEntity:SuakeBasePlayerEntity
    var allStats:[SuakeStatsType:SuakeStatsClass] = [:]
    
    func getStatsValue(suakeStatsType:SuakeStatsType)->Int{
        return self.allStats[suakeStatsType]!.value
    }
    
    func setStatsValue(suakeStatsType:SuakeStatsType, value:Int){
        self.allStats[suakeStatsType]!.value = value
    }
    
    func add2StatsValue(suakeStatsType:SuakeStatsType, value:Int){
        self.allStats[suakeStatsType]!.add2Stats(value2Add: value)
    }
    
    init(playerEntity:SuakeBasePlayerEntity) {
        self.playerEntity = playerEntity
        for suakeStatsType in SuakeStatsType.allCases{
            self.allStats[suakeStatsType] = SuakeStatsClass()
        }
    }
}

