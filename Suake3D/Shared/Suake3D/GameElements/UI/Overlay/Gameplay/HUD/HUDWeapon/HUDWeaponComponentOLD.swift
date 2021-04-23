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

class HUDWeaponComponentOLD: BaseExtHUDComponent {
    
    let imgMG:SKSpriteNode = SKSpriteNode(imageNamed: "art.scnassets/overlays/gameplay/images/mg.png")
    let imgShotgun:SKSpriteNode = SKSpriteNode(imageNamed: "art.scnassets/overlays/gameplay/images/shotgun.png")
    let imgRPG:SKSpriteNode = SKSpriteNode(imageNamed: "art.scnassets/overlays/gameplay/images/rpg.png")
//    let mgImgFile:String            = "art.scnassets/overlays/gameplay/images/mg.png"
//    let textMg:SKTexture
//    let shotgunImgFile:String       = "art.scnassets/overlays/gameplay/images/shotgun.png"
//    let textShotgun:SKTexture
//    let rpgImgFile:String           = "art.scnassets/overlays/gameplay/images/rpg.png"
//    let textRPG:SKTexture
//    let railgunImgFile:String       = "art.scnassets/overlays/gameplay/images/railgun.png"
//    let textRailgun:SKTexture
//    let sniperrifleImgFile:String   = "art.scnassets/overlays/gameplay/images/sniperrifle.png"
//    let textSniperrifle:SKTexture
//    let redeemerImgFile:String      = "art.scnassets/overlays/gameplay/images/redeemer.png"
//    let textRedeemer:SKTexture
    
//    let reloadComponent:ReloadIndicatorComponent
    
    let lblAmmoCount:SKLabelNode
    var imgWeapon:SKSpriteNode!
    
//    var clipAmmoCount:Int = 5 //30
    var weaponType:WeaponType = .mg
    
    override init(game:GameController) {
        self.lblAmmoCount = SKLabelNode(text: "0")
        self.lblAmmoCount.fontName = SuakeVars.defaultFontName
        self.lblAmmoCount.fontSize = 32.0
        
//        self.textMg = SKTexture(imageNamed: self.mgImgFile)
//        self.textShotgun = SKTexture(imageNamed: self.shotgunImgFile)
//        self.textRPG = SKTexture(imageNamed: self.rpgImgFile)
//        self.textRailgun = SKTexture(imageNamed: self.railgunImgFile)
//        self.textSniperrifle = SKTexture(imageNamed: self.sniperrifleImgFile)
//        self.textRedeemer = SKTexture(imageNamed: self.redeemerImgFile)
//        self.reloadComponent = ReloadIndicatorComponent(game: game, onHud: true)
        
        super.init(game: game)
        self.imgWeapon = SKSpriteNode(texture: self.imgMG.texture)// self.imgMG// SKSpriteNode(imageNamed: self.mgImgFile)
//        self.imgWeapon.texture = self.imgMG.texture
        self.imgWeapon.alpha = 1.0
        self.imgWeapon.setScale(0.2) //.frame.size.width = 300// = CGSize(width: 300, height: 100)
        self.imgWeapon.position.y -= self.imgWeapon.frame.height / 2
        self.nodeContainer.addChild(self.lblAmmoCount)
        self.nodeContainer.addChild(self.imgWeapon)
//        self.reloadComponent.nodeContainer.position.y += 70.0
//        self.reloadComponent.nodeContainer.position.x += 130.0
//        self.nodeContainer.addChild(self.reloadComponent.nodeContainer)
//        self.reloadComponent.nodeReloadIndicator.alpha = 1.0
        
        
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
//            case .shotgun:
//                self.imgWeapon.texture = self.textShotgun // SKTexture(imageNamed: self.shotgunImgFile)
//                newTexture = self.textShotgun
//                break
//            case .rpg:
//                self.imgWeapon.texture = self.textRPG // SKTexture(imageNamed: self.rpgImgFile)
//                newTexture = self.textRPG
//                break
//            case .railgun:
//                self.imgWeapon.texture = self.textRailgun // SKTexture(imageNamed: self.railgunImgFile)
//                newTexture = self.textRailgun
//                break
//            case .sniperrifle:
//                self.imgWeapon.texture = self.textSniperrifle // SKTexture(imageNamed: self.sniperrifleImgFile)
//                newTexture = self.textSniperrifle
//                break
//            case .redeemer:
//                self.imgWeapon.texture = self.textRedeemer // SKTexture(imageNamed: self.redeemerImgFile)
//                newTexture = self.textRedeemer
//                break
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
