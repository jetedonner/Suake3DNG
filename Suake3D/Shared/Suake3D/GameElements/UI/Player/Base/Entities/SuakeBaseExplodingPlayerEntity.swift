//
//  SuakeBasePlayerEntity.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeBaseExplodingPlayerEntity: SuakeBasePlayerEntity {
    
    let explodingComponent:DroidExplodingComponent
    
    override init(game:GameController, playerType:SuakePlayerType = .OwnSuake, id:Int = 0){
        self.explodingComponent = DroidExplodingComponent(game: game)
        
        super.init(game: game, playerType: playerType, id: id)
        
        self.addComponent(self.explodingComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
