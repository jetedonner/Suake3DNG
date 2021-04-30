//
//  HUDWeaponComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 28.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit
import NetTestFW

class HUDWeaponComponentOLD: BaseExtHUDComponent {
    
    let imgMG:SKSpriteNode = SKSpriteNode(imageNamed: "art.scnassets/overlays/gameplay/images/mg.png")
    let imgShotgun:SKSpriteNode = SKSpriteNode(imageNamed: "art.scnassets/overlays/gameplay/images/shotgun.png")
    let imgRPG:SKSpriteNode = SKSpriteNode(imageNamed: "art.scnassets/overlays/gameplay/images/rpg.png")
    let imgRailgun:SKSpriteNode = SKSpriteNode(imageNamed: "art.scnassets/overlays/gameplay/images/railgun.png")
    let imgSniperrifle:SKSpriteNode = SKSpriteNode(imageNamed: "art.scnassets/overlays/gameplay/images/sniperrifle.png")
    let imgRedeemer:SKSpriteNode = SKSpriteNode(imageNamed: "art.scnassets/overlays/gameplay/images/redeemer.png")
    
    let lblAmmoCount:SKLabelNode
    var imgWeapon:SKSpriteNode!
    var weaponType:WeaponType = .mg
    
    override init(game:GameController) {
        self.lblAmmoCount = SKLabelNode(text: "0")
        self.lblAmmoCount.fontName = SuakeVars.defaultFontName
        self.lblAmmoCount.fontSize = 32.0
        
        super.init(game: game)
        self.imgWeapon = SKSpriteNode(texture: self.imgMG.texture)
        self.imgWeapon.alpha = 1.0
        self.imgWeapon.setScale(0.2)
        self.imgWeapon.position.y -= self.imgWeapon.frame.height / 2
        self.nodeContainer.addChild(self.lblAmmoCount)
        self.nodeContainer.addChild(self.imgWeapon)
        let windowFrame:NSRect = self.game.scnView.window!.frame
        let mapHeight = windowFrame.height
        let newPos:CGPoint = CGPoint(x: (windowFrame.width / 2) + 180 + (self.imgWeapon.frame.width / 2), y: mapHeight - ((self.lblAmmoCount.frame.height) + 20))
        
        self.node.position = newPos
    }
    
    func setCurrentWeaponType(weaponType:WeaponType){
//        DispatchQueue.main.async {
//            print("HUDWeaponComponent->setCurrentWeaponType(weaponType:WeaponType)")
//            var newTexture:SKTexture!
            switch weaponType {
            case .mg:
                self.imgWeapon.texture = self.imgMG.texture
            case .shotgun:
                self.imgWeapon.texture = self.imgShotgun.texture
            case .rpg:
                self.imgWeapon.texture = self.imgRPG.texture
            case .railgun:
                self.imgWeapon.texture = self.imgRailgun.texture
            case .sniperrifle:
                self.imgWeapon.texture = self.imgSniperrifle.texture
            case .redeemer:
                self.imgWeapon.texture = self.imgRedeemer.texture
            default:
                break
            }
//            if let newTexture = newTexture{
//                self.imgWeapon.run(SKAction.setTexture(newTexture))
////                SKAction.setNormalTexture(<#T##texture: SKTexture##SKTexture#>)
//            }
            
            
//            print("HUDWeaponComponent->setCurrentWeaponType(weaponType:WeaponType) .... ENDED")
//        }
    }
    
//    func setLblColor(color:NSColor = .white){
//        self.lblAmmoCount.attributedText = color
//    }
    
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
//        self.lblAmmoCount.fontColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
