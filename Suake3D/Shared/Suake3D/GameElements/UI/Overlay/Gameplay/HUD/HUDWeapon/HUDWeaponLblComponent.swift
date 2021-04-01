//
//  HUDWeaponLblComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.03.21.
//

import Foundation
import SceneKit
import SpriteKit
import GameplayKit

class HUDWeaponLblComponent: BaseExtHUDComponent {
    
    let lblAmmoCount:SKLabelNode = SKLabelNode(text: "0")
    
    override init(game: GameController) {
        self.lblAmmoCount.fontName = SuakeVars.defaultFontName
        self.lblAmmoCount.fontSize = 32.0
        
        super.init(game: game)
        
        self.nodeContainer.addChild(self.lblAmmoCount)
    }
    
    func setAmmoCount(ammoCount:Int, clipSize:Int, color:NSColor = .white){
        self.game.showDbgMsg(dbgMsg: ".setAmmoCount(" + ammoCount.description + ")", dbgLevel: .Verbose)
        
        var displayAmmoInWeapon:Int = ammoCount
        var displayAmmoInWClips:Int = 0
        let clips:Int = ammoCount / clipSize //self.clipAmmoCount
        if(clips > 0){
            displayAmmoInWClips = (clips - (ammoCount % clipSize == 0 ? 1 : 0)) * clipSize
            displayAmmoInWeapon = displayAmmoInWeapon - displayAmmoInWClips
        }
        self.game.showDbgMsg(dbgMsg: "displayAmmoInWeapon: " + displayAmmoInWeapon.description + ", displayAmmoInWClips: " + displayAmmoInWClips.description + ", clips: " + clips.description + ")", dbgLevel: .Verbose)
        
        self.lblAmmoCount.attributedText = String(displayAmmoInWeapon.description + " / " + displayAmmoInWClips.description).asStylizedPrice(using: NSFont(name: "DpQuake", size: 32.0)!, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
