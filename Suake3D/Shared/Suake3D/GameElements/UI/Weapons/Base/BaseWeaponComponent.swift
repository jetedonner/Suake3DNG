//
//  BaseWeaponComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 27.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit
import NetTestFW

class BaseWeaponComponent: GKComponent {
    
    let game:GameController
    let weaponArsenalManager:WeaponArsenalManager
    var weaponType:WeaponType = .none
    var shotSoundType:SoundType = .rifle
    var lastShot:TimeInterval!
    
    var _ammoCount:Int = 0
    public var ammoCount:Int{
        set{ _ammoCount = newValue }
        get{ return _ammoCount }
    }
    
    var _clipSize:Int = 30
    public var clipSize:Int{
        set{ _clipSize = newValue }
        get{ return _clipSize }
    }
    
    var _cadence:TimeInterval = 1.0
    public var cadence:TimeInterval{
        set{ _cadence = newValue }
        get{ return _cadence }
    }
    
    var _reloading:Bool = false
    var reloading:Bool{
        get{ return self._reloading }
        set{ self._reloading = newValue }
    }
    
    func addAmmo(ammoCount2Add:Int){
        self.ammoCount += ammoCount2Add
        self.game.soundManager.playSound(soundType: .pick_weapon)
        if(self.ammoCount > 0){
            self.game.overlayManager.hud.weaponComponent.setAmmoCount(ammoCount: self.ammoCount, clipSize: self.clipSize)
            self.game.overlayManager.hud.overlayScene.crosshairEntity.currentCrosshairComponent.unavailable = false
        }
    }
    
    func setWeaponSoundType(weapontype:WeaponType){
        switch weaponType {
        case .mg:
            self.shotSoundType = .rifle
        case .shotgun:
            self.shotSoundType = .shotgun
        case .rpg:
            self.shotSoundType = .rpg
        case .railgun:
            self.shotSoundType = .railgun
        case .sniperrifle:
            self.shotSoundType = .sinperrifle
        case .redeemer:
            self.shotSoundType = .nukeLaunch
        default:
            self.shotSoundType = .rifle
        }
    }
    
    init(game:GameController, weaponType:WeaponType, weaponArsenalManager:WeaponArsenalManager, initialAmmoCount:Int = 0) {
        self.game = game
        self.weaponArsenalManager = weaponArsenalManager
        super.init()
        self.weaponType = weaponType
        self.ammoCount = initialAmmoCount
        self.setWeaponSoundType(weapontype: weaponType)
    }
    
    func fireShot(at:SCNVector3? = nil){
        self.game.scene.isPaused = false
        self.lastShot = CACurrentMediaTime()
        self.game.overlayManager.hud.overlayScene.crosshairEntity.reloadIndicatorComponent.startReloadBar(duration: self.cadence)
    }
    
    func shoot(at:SCNVector3? = nil){
        if(self.checkCadenceDelay() && !self.reloading){
            if(self.ammoCount > 0){
                self.fireShot(at: at)
                self.ammoCount -= 1
                if(self.ammoCount % self.clipSize == 0){
                    self.game.overlayManager.hud.weaponComponent.setAmmoCount(ammoCount: self.ammoCount, clipSize: self.clipSize, color: .suake3DRed)
                    self.game.overlayManager.hud.overlayScene.crosshairEntity.currentCrosshairComponent.unavailable = true
                    if(self.ammoCount > 0){
                        self.reloading = true
                        self.game.overlayManager.hud.overlayScene.crosshairEntity.reloadIndicatorComponent.startReloadBar(duration: SuakeVars.reloadClipTimeout)
                        self.game.soundManager.playSound(soundType: .weaponreload)
                        self.game.soundManager.playSound(soundType: self.shotSoundType)
//                        self.game.soundManager.playSoundPositional(soundType: .weaponreload, node: (self.weaponArsenalManager.playerEntity as! SuakePlayerEntity).playerComponent.currentSuakeComponent.node)
//                        GSAudio.sharedInstance.playSound("AudioFileName")
                        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + SuakeVars.reloadClipTimeout, execute: {
                            self.reloading = false
                            self.game.overlayManager.hud.weaponComponent.setAmmoCount(ammoCount: self.ammoCount, clipSize: self.clipSize)
                            self.game.overlayManager.hud.overlayScene.crosshairEntity.currentCrosshairComponent.unavailable = false
                        })
                    }
                }else{
                    self.game.soundManager.playSound(soundType: self.shotSoundType)
                    self.game.overlayManager.hud.weaponComponent.setAmmoCount(ammoCount: self.ammoCount, clipSize: self.clipSize)
                }
            }else{
                self.game.soundManager.playSound(soundType: .noammo)
            }
        }
    }
    
    func checkCadenceDelay()->Bool{
        if(self.lastShot == nil || (CACurrentMediaTime() - self.lastShot) >= self.cadence){
            return true
        }
        return false
    }
    
    func getShotStartPosition()->SCNVector3 {
        let result:SCNVector3 = (self.weaponArsenalManager.playerEntity as! SuakePlayerEntity).cameraComponent.cameraNodeFP.position// self.game.cameraHelper.cameraNodeFP.position
        return result
    }
    
    private func getShotStartVelocity4Target(projectile:SCNNode, target: SCNVector3) -> SCNVector3 {
        let origin = projectile.presentation.position
        var dir = target - origin
        dir.y = 0
        return dir.normalized()
    }
    
    func getShotStartVelocity(bulletNode:BulletBase, target: SCNVector3? = nil)->SCNVector3 {
        var shotStartPosition:SCNVector3 = (self.weaponArsenalManager.playerEntity as! SuakePlayerEntity).cameraComponent.cameraNodeFP.worldFront // self.game.cameraHelper.cameraNodeFP.worldFront
        if(target != nil){
            shotStartPosition = self.getShotStartVelocity4Target(projectile: bulletNode, target: target!)
        }
        let result:SCNVector3 = SCNVector3(x: shotStartPosition.x * bulletNode.shootingVelocity, y: shotStartPosition.y * bulletNode.shootingVelocity, z: shotStartPosition.z * bulletNode.shootingVelocity)
        return result
    }
    
    func getShotStartRotation()->SCNVector4{
        var bulletRotation:SCNVector4 = self.game.cameraHelper.cameraNodeFP.rotation
        if(bulletRotation.w > (CGFloat.pi / 2)){
            bulletRotation.w -= CGFloat.pi
        }else{
            bulletRotation.w += CGFloat.pi
        }
        return bulletRotation
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
