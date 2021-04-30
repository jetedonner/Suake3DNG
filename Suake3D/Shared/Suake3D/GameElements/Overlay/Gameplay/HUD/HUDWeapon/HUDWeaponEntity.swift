//
//  HUDWeaponEntity.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.03.21.
//

import Foundation
import SceneKit
import SpriteKit
import GameplayKit

class HUDWeaponEntity: SuakeBaseEntity {
    
    let hudEntity:HUDOverlayEntity
    let hudWeaponImgComponent:HUDWeaponImgComponent
    let hudWeaponLblComponent:HUDWeaponLblComponent
    
    init(game: GameController, hudEntity:HUDOverlayEntity) {
        self.hudEntity = hudEntity
        self.hudWeaponImgComponent = HUDWeaponImgComponent(game: game)
        self.hudWeaponLblComponent = HUDWeaponLblComponent(game: game)
        
        super.init(game: game)
        
        self.addComponent(self.hudWeaponImgComponent)
        self.addComponent(self.hudWeaponLblComponent)
    }
    
    func setAmmoCount(ammoCount:Int, clipSize:Int, color:NSColor = .white){
        self.hudWeaponLblComponent.setAmmoCount(ammoCount: ammoCount, clipSize: clipSize, color: color)
//        self.game.showDbgMsg(dbgMsg: ".setAmmoCount(" + ammoCount.description + ")", dbgLevel: .Verbose)
//
//        var displayAmmoInWeapon:Int = ammoCount
//        var displayAmmoInWClips:Int = 0
//        let clips:Int = ammoCount / clipSize //self.clipAmmoCount
//        if(clips > 0){
//            displayAmmoInWClips = (clips - (ammoCount % clipSize == 0 ? 1 : 0)) * clipSize
//            displayAmmoInWeapon = displayAmmoInWeapon - displayAmmoInWClips
//        }
//        self.game.showDbgMsg(dbgMsg: "displayAmmoInWeapon: " + displayAmmoInWeapon.description + ", displayAmmoInWClips: " + displayAmmoInWClips.description + ", clips: " + clips.description + ")", dbgLevel: .Verbose)
        
//        self.lblAmmoCount.attributedText = String(displayAmmoInWeapon.description + " / " + displayAmmoInWClips.description).asStylizedPrice(using: NSFont(name: "DpQuake", size: 32.0)!, color: color)
//        self.lblAmmoCount.fontColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
