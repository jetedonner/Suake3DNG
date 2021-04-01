//
//  LevelSnapshotManager.swift
//  Suake3D
//
//  Created by Kim David Hauser on 28.02.21.
//  Copyright © 2021 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class DistanceManager:SuakeGameClass{

    var entityDistancesNG = [GKEntity: [GKEntity: CGFloat]]()
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func initDistances(){
        
        entityDistancesNG.removeAll()
        
        let entityOwnSuake:SuakeOwnPlayerEntity = self.game.playerEntityManager.ownPlayerEntity
        let entityOppSuake:SuakeOppPlayerEntity = self.game.playerEntityManager.oppPlayerEntity
        let entityGoody:GoodyEntity = self.game.playerEntityManager.goodyEntity
        
        entityDistancesNG[entityOwnSuake] = [GKEntity: CGFloat]() // [:]
        entityDistancesNG[entityOppSuake] = [GKEntity: CGFloat]() //[:]
        entityDistancesNG[entityGoody] = [GKEntity: CGFloat]() //[:]

        let distOwn2Opp = entityOwnSuake.pos - entityOppSuake.pos
        let distOwn2Goody = entityOwnSuake.pos - entityGoody.pos
        let distOpp2Goody = entityOppSuake.pos - entityGoody.pos
        
        entityDistancesNG[entityOwnSuake]![entityOppSuake] = CGFloat(distOwn2Opp.length())
        entityDistancesNG[entityOwnSuake]![entityGoody] = CGFloat(distOwn2Goody.length())
        
        entityDistancesNG[entityOppSuake]![entityOwnSuake] = CGFloat(distOwn2Opp.length())
        entityDistancesNG[entityOppSuake]![entityGoody] = CGFloat(distOpp2Goody.length())
        
        entityDistancesNG[entityGoody]![entityOwnSuake] = CGFloat(distOwn2Goody.length())
        entityDistancesNG[entityGoody]![entityOppSuake] = CGFloat(distOpp2Goody.length())
        
        for droid in self.game.playerEntityManager.droidsNotDead{
            let distOwn = entityOwnSuake.pos - droid.pos
            let distOpp = entityOppSuake.pos - droid.pos
            
            entityDistancesNG[entityOwnSuake]![droid] = CGFloat(distOwn.length())
            entityDistancesNG[entityOppSuake]![droid] = CGFloat(distOpp.length())
            entityDistancesNG[droid] = [GKEntity: CGFloat]() //[:]
            entityDistancesNG[droid]![entityOwnSuake] = CGFloat(distOwn.length())
            entityDistancesNG[droid]![entityOppSuake] = CGFloat(distOpp.length())
        }
    }
    
    func updateDistances(){
        self.initDistances()
    }
    
    func getDistanceBetween(node1:GKEntity, node2:SuakeBasePlayerEntity)->CGFloat{
        return self.entityDistancesNG[node1]![node2]!
    }
}
