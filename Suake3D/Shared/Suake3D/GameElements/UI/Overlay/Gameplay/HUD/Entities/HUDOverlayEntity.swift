//
//  HUDEntity.swift
//  Suake3D
//
//  Created by Kim David Hauser on 13.03.21.
//

import Foundation
import SceneKit
import SpriteKit
import GameplayKit

class HUDOverlayEntity: SuakeBaseEntity {
    
    var overlayScene:HUDOverlayScene!
    let msgComponent:HUDMsgComponent
    var healthBars:[SuakeBasePlayerEntity:HUDHealthBarOnScreenComponent] = [:]
    
    var msgOnHudComponent:HUDMsgOnScreenComponent!
    
    var weaponComponent:HUDWeaponComponentOLD!
//    var hudWeaponEntity:HUDWeaponEntity!
    
    init(game: GameController) {
        
        self.msgComponent = HUDMsgComponent(game: game)
        
        self.msgOnHudComponent = HUDMsgOnScreenComponent(game: game)
        
        self.weaponComponent = HUDWeaponComponentOLD(game: game)
        
        super.init(game: game)
        
        self.overlayScene = HUDOverlayScene(game: game, hudEntity: self)
//        self.hudWeaponEntity = HUDWeaponEntity(game: game, hudEntity: self)
        
        self.addComponent(self.msgComponent)
        self.addComponent(self.msgOnHudComponent)
    }
    
    func drawHealthBar(){
        for healthBar in self.healthBars{
//            if(!healthBar.value.isHidden){
                healthBar.value.drawHealthBar()
                self.overlayScene.reposHealthBar(healthBar: healthBar.value, entity: healthBar.key)
//            }
        }
    }
    
    func setScore(score:Int){
        self.overlayScene.setScore(score: score)
    }
    
    func setGameTimer(time:TimeInterval){
        self.overlayScene.setGameTimer(time: time)
    }
    
    func setPositionTxt(pos:SCNVector3){
        self.overlayScene.setPositionTxt(pos: pos)
    }
    
    func setGoodyPositionTxt(pos:SCNVector3){
        self.overlayScene.setGoodyPositionTxt(pos: pos)
    }
    
    func showMsg(msg:String){
        self.overlayScene.sceneNode.isPaused = false
        self.msgComponent.showMsg(msg: msg)
    }
    
    func setupOverlay(){
        self.healthBars[self.game.playerEntityManager.ownPlayerEntity] = HUDHealthBarOnScreenComponent(game: game, playerType: .OwnSuake)
        
        self.healthBars[self.game.playerEntityManager.oppPlayerEntity] = HUDHealthBarOnScreenComponent(game: game, playerType: .OppSuake)
        
        self.healthBars[self.game.playerEntityManager.goodyEntity] = HUDHealthBarOnScreenComponent(game: game, playerType: .Goody)
        
        if(self.game.usrDefHlpr.loadDroids){
            self.healthBars[self.game.playerEntityManager.droidEntities[0]] = HUDHealthBarOnScreenComponent(game: game, playerType: .Droid, id: 0)
        }
        self.msgComponent.setupMsg(hud: self.overlayScene)
        
        for healthBar in self.healthBars{
            self.addComponent(healthBar.value)
            healthBar.value.setupHealthBar(hud: self.overlayScene)
        }
        
//        self.healthBarOwnComponent.initUpdateHealthBar(health: 100.0)
//        self.healthBarOwnComponent.setupHealthBar(hud: self.overlayScene)
//        self.healthBarGoodyComponent.setupHealthBar(hud: self.overlayScene)
//        self.healthBarDroidComponent.setupHealthBar(hud: self.overlayScene)
        
        self.overlayScene.sceneNode.addChild(self.weaponComponent.node)
        self.msgOnHudComponent.setupMsg(hud: self.overlayScene)
//      self.healthBarGoodyComponent.setupHealthBar(hud: self.overlayScene)  self.overlayScene.sceneNode.addChild(self.hudWeaponEntity.hudWeaponImgComponent.nodeContainer)
//        self.overlayScene.arrows.setupArrows(hud: self.overlayScene)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
