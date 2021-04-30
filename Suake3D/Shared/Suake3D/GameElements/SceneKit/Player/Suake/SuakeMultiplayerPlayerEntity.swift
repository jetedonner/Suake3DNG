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
import NetTestFW

class SuakeMultiplayerPlayerEntity: SuakePlayerEntity {
        
    var fadeHelper:FadeViewAfterDeath!
    
    init(game: GameController) {
        super.init(game: game, playerType: .OwnSuake, id: 0)
    }
    
    override func setupPlayerEntity() {
        super.setupPlayerEntity()
        self.fadeHelper = FadeViewAfterDeath(game: game)
    }
    
    func resetPlayerEntity(){
        self.dir = .UP
        self.dirOld = .UP
        self.pos = SuakeVars.ownPos
        self.moveComponent.resetMoveComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
