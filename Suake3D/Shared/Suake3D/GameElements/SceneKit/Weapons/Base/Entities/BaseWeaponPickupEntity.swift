//
//  BaseWeaponPickupEntity.swift
//  Suake3D
//
//  Created by Kim David Hauser on 26.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit
import NetTestFW

class BaseWeaponPickupEntity: SuakeBaseNodeEntity {
    
    var catchScore:Int = SuakeVars.weaponPickupCatchScore
    let weaponType:WeaponType
    let collisionCategory:CollisionCategory!
    var addAmmoCount:Int = 10
    let pickupParticleComponent:WeaponPickupRisingParticlesComponent
    let weaponPickupComponent:BaseWeaponPickupComponent
    
    override var pos:SCNVector3{
        get{ return super.pos }
        set{
            self.game.levelManager.gameBoard.clearGameBoardFieldItem(pos: self.pos)
            
            super.pos = newValue
            
            self.game.levelManager.gameBoard.setGameBoardFieldItem(pos: self.pos, suakeFieldItem: self)
            
            let scnNodeComponents:[SuakeBaseSCNNodeComponent] = self.components(conformingTo: SuakeBaseSCNNodeComponent.self)
            for i in (0..<scnNodeComponents.count){
                if(scnNodeComponents[i].isKind(of: BaseWeaponPickupComponent.self) && scnNodeComponents[i] != self.pickupParticleComponent){
                    let nextPos = SCNVector3(self._pos.x * SuakeVars.fieldSize, scnNodeComponents[i].node.position.y, self._pos.z * SuakeVars.fieldSize)
                    scnNodeComponents[i].node.position = nextPos
                    print("nextPos: \(nextPos)")
                }
            }
        }
    }
    
    func weaponType2FieldType()->SuakeFieldType{
        var fieldType:SuakeFieldType = .empty
        switch self.weaponType {
        case .mg:
            fieldType = .machinegun
            break
        case .shotgun:
            fieldType = .shotgun
            break
        case .rpg:
            fieldType = .rocketlauncher
            break
        case .railgun:
            fieldType = .railgun
            break
        case .sniperrifle:
            fieldType = .sniperrifle
            break
        case .redeemer:
            fieldType = .nuke
            break
        default:
            break
        }
        return fieldType
    }
    
    init(game: GameController, weaponType:WeaponType, weaponPickupComponent:BaseWeaponPickupComponent, id: Int = 0) {
        self.weaponType = weaponType
        switch self.weaponType {
        case .mg:
            self.collisionCategory = CollisionCategory.machinegunPickup
        case .shotgun:
            self.collisionCategory = CollisionCategory.shotgunPickup
        case .rpg:
            self.collisionCategory = CollisionCategory.rpgPickup
        case .railgun:
            self.collisionCategory = CollisionCategory.railgunPickup
        case .sniperrifle:
            self.collisionCategory = CollisionCategory.snipergunPickup
        case .redeemer:
            self.collisionCategory = CollisionCategory.nukePickup
        default:
            self.collisionCategory = CollisionCategory.machinegunPickup
        }
        self.weaponPickupComponent = weaponPickupComponent
        self.pickupParticleComponent = WeaponPickupRisingParticlesComponent(game: game)
        super.init(game: game, id: id)
        self.addComponent(self.weaponPickupComponent)
        self.game.physicsHelper.qeueNode2Add2Scene(node: self.pickupParticleComponent.node)
        self.pickupParticleComponent.node.isHidden = true
    }
    
    
    var newPos:SCNVector3 = SCNVector3(0.0, 0.0, 0.0)
    func posPickupParticles(particlePos:SCNVector3){
        newPos = particlePos
        self.pickupParticleComponent.node.position = SCNVector3(particlePos.x, particlePos.y, particlePos.z)
//        print("MGPickup Particle pos: \(self.pickupParticleComponent.node.position)")
    }
    
    func pickedUp(completion: @escaping () -> Void?){
        self.pickupParticleComponent.node.isHidden = false
        self.pickupParticleComponent.node.opacity = 1.0
        self.pickupParticleComponent.node.runAction(SCNAction.sequence([ SCNAction.fadeIn(duration: 0.1), SCNAction.wait(duration: 0.3), SCNAction.fadeOut(duration: 0.7)]), completionHandler: {
            completion()
        })
    }
    
    func pickupWeapon(player:SuakePlayerEntity, bullet:BulletBase? = nil){
        if(bullet != nil){
            if(bullet!.isTargetHit){
                return
            }else{
                bullet!.isTargetHit = true
            }
        }
        self.game.overlayManager.hud.msgOnHudComponent.setAndShowLbl(msg: String(format: SuakeMsgs.pointAddString, self.catchScore)/* "+ 200 Points"*/, pos: self.position)
        
        self.pickedUp(completion: self.weaponPickupParticlesHidden)
        if(player.weapons.currentWeapon.weaponType != self.weaponType){
            player.weapons.setCurrentWeaponType(weaponType: self.weaponType, playAudio: false)
        }
        player.weapons.getWeapon(weaponType: self.weaponType)?.addAmmo(ammoCount2Add: self.addAmmoCount)
        self.initSetupPos(addToScene: false)
    }
    
    func weaponPickupParticlesHidden(){
        self.posPickupParticles(particlePos: self.weaponPickupComponent.node.position)
    }
    
    func initSetupPos(addToScene:Bool = true){
        var pos:SCNVector3 = self.game.levelManager.gameBoard.getRandomFreePos()
        pos.y = self.position.y
        self.pos = pos
        print("New weapon pickup pos: \(self.pos)")
        
        //super.initSetupPos(addToScene: addToScene)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
