//
//  WeaponArsenalManager.swift
//  Suake3D
//
//  Created by Kim David Hauser on 16.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class WeaponArsenalManager: SuakeGameClass {
    
    let playerEntity:SuakeBasePlayerEntity
    var allWeapons:[BaseWeaponComponent] = [BaseWeaponComponent]()
    var allWeaponTypes:WeaponType = WeaponType.none
    
//    var _currentWeaponType:WeaponType = .none
//    var currentWeaponType:WeaponType{
//        get{ return self._currentWeaponType }
//        set{
//            self._currentWeaponType = newValue
//        }
//    }
    
    var _currentWeapon:BaseWeaponComponent!
    var currentWeapon:BaseWeaponComponent!{
        get{ return self._currentWeapon }
        set{
            self._currentWeapon = newValue
            self.game.overlayManager.hud.weaponComponent.setAmmoCount(ammoCount: newValue.ammoCount, clipSize: newValue.clipSize)
            self.game.overlayManager.hud.weaponComponent.setCurrentWeaponType(weaponType: newValue.weaponType)
            self.game.overlayManager.hud.overlayScene.crosshairEntity.setCurrentWeaponType(weaponType: newValue.weaponType)
        }
    }
    
    init(game: GameController, playerEntity:SuakeBasePlayerEntity) {
        self.playerEntity = playerEntity
        super.init(game: game)
    }
    
    func initWeaponArsenal(with weaponTypes:WeaponType){
        allWeaponTypes = weaponTypes
//        if(weaponTypes | WeaponType.mg.rawValue == weaponTypes){
//            self.allWeapons.append(MachinegunComponent(game: self.game))
//        }
        if(weaponTypes.contains(.mg)){
            self.allWeapons.append(MachinegunComponent(game: self.game, weaponArsenalManager: self))
        }
        
        if(weaponTypes.contains(.shotgun)){
            self.allWeapons.append(ShotgunComponent(game: self.game, weaponArsenalManager: self))
        }
        
        if(weaponTypes.contains(.rpg)){
            self.allWeapons.append(RPGComponent(game: self.game, weaponArsenalManager: self))
        }
//        if(weaponTypes.contains(.shotgun)){
//            self.allWeapons.append(ShotgunComponent(game: self.game, weaponArsenalManager: self))
////            (self.allWeapons[self.allWeapons.count - 1] as! ShotgunComponent).prepareBullets()
//        }
//        if(weaponTypes.contains(.rpg)){
//            self.allWeapons.append(RPGComponent(game: self.game, weaponArsenalManager: self))
//            (self.allWeapons[self.allWeapons.count - 1] as! RPGComponent).prepareBullets()
//        }
        if(weaponTypes.contains(.railgun)){
            self.allWeapons.append(RailgunComponent(game: self.game, weaponArsenalManager: self))
        }
        if(weaponTypes.contains(.sniperrifle)){
            self.allWeapons.append(SniperrifleComponent(game: self.game, weaponArsenalManager: self))
        }
        if(weaponTypes.contains(.redeemer)){
            self.allWeapons.append(RedeemerComponent(game: self.game, weaponArsenalManager: self))
        }
        
        if(self.allWeapons.count > 0){
//            self.currentWeapon = self.allWeapons.first!
            self.setCurrentWeaponType(weaponType: self.allWeapons.first!.weaponType, playAudio: false)
//            self.game.overlayManager.hud.hudEntity.crosshairEntity.setCurrentWeaponType(weaponType: self.currentWeapon.weaponType)
        }
    }
    
    func setCurrentWeaponType(weaponType:WeaponType, playAudio:Bool = true){
        if(self.currentWeapon == nil || self.currentWeapon.weaponType != weaponType){
            
//            self.game.cameraHelper.panCameraHelper.animateCrosshair(animationIn: false, override: true)
            //self.game.overlayManager.hud.hudEntity.crosshairEntity.currentCrosshairComponent.animateCrosshair(animated: false)
            
//            self.currentWeaponType = weaponType
            self.currentWeapon = self.getWeapon(weaponType: weaponType)!
//            self.game.overlayManager.hud.hudEntity.weaponComponent.setCurrentWeaponType(weaponType: weaponType)
//            self.game.overlayManager.hud.weaponComponent.setCurrentWeaponType(weaponType: weaponType)
//            self.game.overlayManager.hud.overlayScene.crosshairEntity.setCurrentWeaponType(weaponType: weaponType)
//            self.game.overlayManager.hud.overrideCheckIsAimedClass = true
//            self.game.cameraHelper.panCameraHelper.isAimedAt = false
//            _ = self.game.cameraHelper.panCameraHelper.checkAimedAtAll()
            //self.game.overlayManager.hud.checkAndAnimateCrosshairAimedAt(overrideCheckIsAimed: true)
            if(playAudio){
//                self.game.soundManager.
                self.game.soundManager.playSound(soundType: .wp_change)
            }
        }
    }
    
    func hasWeapon(weaponType:WeaponType) -> Bool {
        if(self.allWeaponTypes.contains(weaponType)){
            return true
        }
        return false
    }
    
    func getWeapon(weaponType:WeaponType)->BaseWeaponComponent?{
        for weapon in allWeapons {
            if(weapon.weaponType == weaponType){
                return weapon
            }
        }
        return nil
    }
    
    func shoot(at:SCNVector3? = nil, velocity:Bool = false){
        self.currentWeapon.shoot(at: at, velocity: velocity)
    }
}
