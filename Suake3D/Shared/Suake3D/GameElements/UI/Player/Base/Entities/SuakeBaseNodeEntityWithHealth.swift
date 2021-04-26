//
//  SuakeBaseNodeEntityWithHealth.swift
//  Suake3D
//
//  Created by Kim David Hauser on 29.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeBaseNodeEntityWithHealth: SuakeBaseNodeEntity, SuakeHealthComponentDelegate {
    
    let healthComponent:SuakeHealthComponent
//    var died:Bool = false
    var died:Bool{
        get{ return self.healthComponent.died }
        set{ self.healthComponent.died = newValue }
    }
    var killScore:Int = SuakeVars.suakePlayerKillScore
    
    override init(game: GameController, id:Int = 0) {
        self.healthComponent = SuakeHealthComponent(game: game)
        
        super.init(game: game, id: id)
        
        self.healthComponent.delegate = self
        self.addComponent(self.healthComponent)
    }
    
    func playerDied(){
//        self.died = true
        if(!self.died){
            self.died = true
            self.game.stateMachine.enter(SuakeStateDied.self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
