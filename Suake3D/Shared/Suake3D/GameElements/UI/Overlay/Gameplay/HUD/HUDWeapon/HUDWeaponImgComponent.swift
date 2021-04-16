//
//  HUDWeaponImgComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.03.21.
//

import Foundation
import SceneKit
import SpriteKit
import GameplayKit

class HUDWeaponImgComponent: BaseExtHUDComponent {
    
    var imgWeapon:SKSpriteNode!
    var weaponsImages:[WeaponType: SKSpriteNode] = [:]
        
    override init(game: GameController) {
        super.init(game: game)
        self.loadImageFiles()
        self.setWeapon()
        self.imgWeapon.setScale(0.2)
        
        self.reposWeaponImg()
        self.nodeContainer.addChild(self.imgWeapon)
    }
    
    func reposWeaponImg(){
        let windowFrame:NSRect = self.game.scnView.window!.frame
        let mapHeight = windowFrame.height
        let newPos:CGPoint = CGPoint(x: (windowFrame.width / 2) + 180 + (self.imgWeapon.frame.width / 2), y: mapHeight - 20 - self.imgWeapon.frame.height /* ((self.lblAmmoCount.frame.height) + 20)*/)
        
        self.nodeContainer.position = newPos
    }
    
    func loadImageFiles(){
        self.weaponsImages[.mg] = SKSpriteNode(imageNamed: SuakeFiles.hudMGImageFile)
        self.weaponsImages[.rpg] = SKSpriteNode(imageNamed: SuakeFiles.hudRPGImageFile)
    }
    
    func setWeapon(weaponType:WeaponType = .mg){
//        switch weapon {
//        case .mg:
            self.imgWeapon = self.weaponsImages[weaponType]
//        default:
//            break
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
