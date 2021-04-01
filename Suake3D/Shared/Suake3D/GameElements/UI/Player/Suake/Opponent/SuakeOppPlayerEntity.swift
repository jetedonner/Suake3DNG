//
//  SuakeOwnPlayerEntity.swift
//  Suake3D
//
//  Created by Kim David Hauser on 29.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit
import SpriteKit
import GameKit

class SuakeOppPlayerEntity: SuakePlayerEntity {
        
    var fadeHelper:FadeViewAfterDeath!
    
    var _turnQueue:[TurnDir] = []
    var turnQueue:[TurnDir]{
        get{ return self._turnQueue }
        set{ self._turnQueue = newValue }
    }
    
    //TMP
    var opponentAIComponent:SuakeOpponentAIComponent!
    let enemyName:EnemyNames
    
    init(game: GameController) {
        
        self.enemyName = EnemyNames.random()
        
        super.init(game: game, playerType: .OppSuake, id: 0)
//        self.moveComponent = SuakeMove
        self.opponentAIComponent = SuakeOpponentAIComponent(game: game)
        self.addComponent(self.opponentAIComponent)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        self.moveComponent.update(deltaTime: seconds)
    }
    
    func loadGridGraph(){
        self.opponentAIComponent.loadGridGraph()
        self.opponentAIComponent.findPath2Entity(entity: self.game.playerEntityManager.goodyEntity)
        self.opponentAIComponent.followPathNG()
    }
    
    override func setupPlayerEntity() {
        super.setupPlayerEntity()
        self.resetPlayerEntity()
        self.fadeHelper = FadeViewAfterDeath(game: game)
    }
    
    func resetPlayerEntity(){
        self.dir = .UP
        self.dirOld = .UP
        self.pos = SuakeVars.oppPos
        self.moveComponent.resetMoveComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
