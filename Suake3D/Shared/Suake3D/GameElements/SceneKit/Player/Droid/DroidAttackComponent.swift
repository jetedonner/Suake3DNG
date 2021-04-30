//
//  DroidAttackComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class DroidAttackComponent: SuakeBaseComponent {
    
    let weaponArsenalManager:WeaponArsenalManager
    
    init(game: GameController, playerEnity:SuakeBasePlayerEntity) {
        self.weaponArsenalManager = WeaponArsenalManager(game: game, playerEntity: playerEnity)
        super.init(game: game)
    }
    
    func shootLaser(suake:SuakePlayerEntity, deltaTime:TimeInterval = 0.0){
        let shootDif:Int = Int.random(range: -Int(SuakeVars.droidInitRandomAimVar)..<Int(SuakeVars.droidInitRandomAimVar))
        let from:SCNVector3 = (self.entity as! DroidEntity).position
        
        var to:SCNVector3 = suake.position
        
        if(suake.dir == .UP){
            to.z += SuakeVars.fieldSize * CGFloat(deltaTime) + CGFloat(shootDif)
        }else if(suake.dir == .DOWN){
            to.z -= SuakeVars.fieldSize * CGFloat(deltaTime) + CGFloat(shootDif)
        }else if(suake.dir == .LEFT){
            to.x += SuakeVars.fieldSize * CGFloat(deltaTime) + CGFloat(shootDif)
        }else if(suake.dir == .RIGHT){
            to.x -= SuakeVars.fieldSize * CGFloat(deltaTime) + CGFloat(shootDif)
        }
        
        let shootingVect:SCNVector3 = to - from
        if(shootingVect.x == 0 || shootingVect.z == 0){
            return
        }else{
            DispatchQueue.main.async {
                self.game.soundManager.playSound(soundType: .laser)
                let shot:LaserBeamNode = LaserBeamNode(game: self.game, droidEntity: (self.entity as! DroidEntity), to: to, weaponArsenalManager: self.weaponArsenalManager)
                if(self.game.usrDefHlpr.devMode){
                    shot.damage = SuakeVars.initDroidDamage
                }
                self.game.physicsHelper.qeueNode2Add2Scene(node: shot)
//                self.game.audioManager.playSoundPositional(soundType: .laser, node: (self.entity as! DroidEntity).droidComponent.node)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
