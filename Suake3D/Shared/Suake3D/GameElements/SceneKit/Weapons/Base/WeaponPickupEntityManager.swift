//
//  WeaponPickupEntityManager.swift
//  Suake3D
//
//  Created by Kim David Hauser on 26.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class WeaponPickupEntityManager:EntityManager{
    
    var mgPickupEntities:[MachinegunPickupEntity] = [MachinegunPickupEntity]()
    var shotgunPickupEntities:[ShotgunPickupEntity] = [ShotgunPickupEntity]()
    var rpgPickupEntities:[RPGPickupEntity] = [RPGPickupEntity]()
    var railgunPickupEntities:[RailgunPickupEntity] = [RailgunPickupEntity]()
    var sniperriflePickupEntities:[SniperriflePickupEntity] = [SniperriflePickupEntity]()
    var redeemerPickupEntities:[RedeemerPickupEntity] = [RedeemerPickupEntity]()
    
    var allPickupEntities:[[BaseWeaponPickupEntity]] = [[BaseWeaponPickupEntity]]()
    
    var _isHidden:Bool = false
    var isHidden:Bool{
        get{ return self._isHidden }
        set{
            self._isHidden = newValue
//            for entity in self.entities{
//                for component in entity.components(conformingTo: BaseWeaponPickupComponent.self){
//                    component.node.isHidden = newValue
//                }
//            }
//            self.game.showDbgMsg(dbgMsg: "Setting weapon pickups hidden: " + newValue.description, dbgLevel: .Verbose)
        }
    }
    
    override init(game: GameController) {
        super.init(game: game)
        self.allPickupEntities = [self.mgPickupEntities, self.shotgunPickupEntities, self.rpgPickupEntities, self.railgunPickupEntities, self.sniperriflePickupEntities/*, self.redeemerPickupEntities*/]
    }
    
    func pickupWeapon(weaponPickupType:WeaponType, player:SuakePlayerEntity){
        switch weaponPickupType {
        case .mg:
            self.mgPickupEntities[0].pickupWeapon(player: player)
        case .shotgun:
            self.shotgunPickupEntities[0].pickupWeapon(player: player)
        case .rpg:
            self.rpgPickupEntities[0].pickupWeapon(player: player)
        case .railgun:
            self.railgunPickupEntities[0].pickupWeapon(player: player)
        case .sniperrifle:
            self.sniperriflePickupEntities[0].pickupWeapon(player: player)
        case .redeemer:
            self.redeemerPickupEntities[0].pickupWeapon(player: player)
        default:
            break
        }
        self.game.soundManager.playSound(soundType: .pick_weapon)
        self.game.showDbgMsg(dbgMsg: "Weapon (" + weaponPickupType.toString() + ") picked up", dbgLevel: .Info)
    }
    
    func addWeaponPickupEntities(weaponType:WeaponType, numberOfWeaponPickups:Int) {
        for i in (0..<numberOfWeaponPickups){
            let newEntity:BaseWeaponPickupEntity = self.getNewWeaponPickupEntity(weaponType: weaponType, id: i)
            self.setNewWeaponPickupEntityVar(weaponType: weaponType, newEntity: newEntity)
            self.addWeaponPickupEntity(weaponPickupEntity: newEntity)
        }
    }
    
    func dbgPosWeaponPickups(){
        if(DbgVars.startLoad_Weapons){
            mgPickupEntities[0].pos = SCNVector3(1, 0, 1)
//            mgPickupEntities[0].mgPickupComponent.node.position.y += 10.0
            shotgunPickupEntities[0].pos = SCNVector3(1, 0, 2)
//            shotgunPickupEntities[0].shotgunPickupComponent.node.position.y += 10.0
            rpgPickupEntities[0].pos = SCNVector3(1, 0, 3)
//            rpgPickupEntities[0].rpgPickupComponent.node.position.y += 10.0
            railgunPickupEntities[0].pos = SCNVector3(1, 0, 4)
//            railgunPickupEntities[0].railgunPickupComponent.node.position.y += 10.0
            sniperriflePickupEntities[0].pos = SCNVector3(1, 0, 5)
//            sniperriflePickupEntities[0].sniperriflePickupComponent.node.position.y += 10.0
            redeemerPickupEntities[0].pos = SCNVector3(1, 0, 6)
//            redeemerPickupEntities[0].redeemerPickupComponent.node.position.y += 10.0
        }
    }
    
    let pickupYOffset:CGFloat = 8.0
    
    func addWeaponPickupEntity(weaponPickupEntity:BaseWeaponPickupEntity) {
//        self.add(weaponPickupEntity)
        
        if let weaponPickupComponent = weaponPickupEntity.component(ofType: MachinegunPickupComponent.self) {
            weaponPickupComponent.initSetupPos()
            
//            if(DbgVars.dbgPosWeaponPickups){
                weaponPickupEntity.pos = SCNVector3(1, 0, 1)
            weaponPickupEntity.posPickupParticles(particlePos: weaponPickupComponent.node.position)
//                weaponPickupComponent.node.position.y += pickupYOffset
//            }
        }
        
        if let weaponPickupComponent = weaponPickupEntity.component(ofType: ShotgunPickupComponent.self) {
            weaponPickupComponent.initSetupPos()
//            if(DbgVars.dbgPosWeaponPickups){
                weaponPickupEntity.pos = SCNVector3(1, 0, 2)
            weaponPickupEntity.posPickupParticles(particlePos: weaponPickupComponent.node.position)
//                weaponPickupComponent.node.position.y += pickupYOffset
//            }
        }
//
        if let weaponPickupComponent = weaponPickupEntity.component(ofType: RPGPickupComponent.self) {
            weaponPickupComponent.initSetupPos()
//            if(DbgVars.dbgPosWeaponPickups){
                weaponPickupEntity.pos = SCNVector3(1, 0, 3)
            weaponPickupEntity.posPickupParticles(particlePos: weaponPickupComponent.node.position)
//            }
//            weaponPickupComponent.node.position.y += 3.0 + pickupYOffset
        }
//
        if let weaponPickupComponent = weaponPickupEntity.component(ofType: RailgunPickupComponent.self) {
            weaponPickupComponent.initSetupPos()
//            if(DbgVars.dbgPosWeaponPickups){
                weaponPickupEntity.pos = SCNVector3(1, 0, 4)
            weaponPickupEntity.posPickupParticles(particlePos: weaponPickupComponent.node.position)
//            }
//            weaponPickupComponent.node.position.y += 3.0 + pickupYOffset
        }
//
        if let weaponPickupComponent = weaponPickupEntity.component(ofType: SniperriflePickupComponent.self) {
            weaponPickupComponent.initSetupPos()
//            if(DbgVars.dbgPosWeaponPickups){
                weaponPickupEntity.pos = SCNVector3(1, 0, 5)
            weaponPickupEntity.posPickupParticles(particlePos: weaponPickupComponent.node.position)
//            }
//            weaponPickupComponent.node.position.y += 3.0 + pickupYOffset
        }
//
        if let weaponPickupComponent = weaponPickupEntity.component(ofType: RedeemerPickupComponent.self) {
            weaponPickupComponent.initSetupPos()
//            if(DbgVars.dbgPosWeaponPickups){
                weaponPickupEntity.pos = SCNVector3(1, 0, 6)
            weaponPickupEntity.posPickupParticles(particlePos: weaponPickupComponent.node.position)
//            }
//            weaponPickupComponent.node.position.y += 3.0 + pickupYOffset
        }
//
//        if let lightComponent = weaponPickupEntity.component(ofType: SuakeLightComponent.self) {
//            lightComponent.node.name = "LightNode"
//            lightComponent.initSetupPos(addToScene: false)
//            lightComponent.setSpotRadius(radius: 40)
//        }
    }
    
    func setNewWeaponPickupEntityVar(weaponType:WeaponType, newEntity:BaseWeaponPickupEntity, id:Int = 0){
        switch weaponType {
            case .mg:
                self.mgPickupEntities.append(newEntity as! MachinegunPickupEntity)
            case .shotgun:
                self.shotgunPickupEntities.append(newEntity as! ShotgunPickupEntity)
            case .rpg:
                self.rpgPickupEntities.append(newEntity as! RPGPickupEntity)
            case .railgun:
                self.railgunPickupEntities.append(newEntity as! RailgunPickupEntity)
            case .sniperrifle:
                self.sniperriflePickupEntities.append(newEntity as! SniperriflePickupEntity)
            case .redeemer:
                self.redeemerPickupEntities.append(newEntity as! RedeemerPickupEntity)
            default:
                break
        }
    }
    
    func removeAllWeaponPickupEntities(){
        
        
        // Machinegun
        for mgPickupEntity in self.mgPickupEntities{
            mgPickupEntity.weaponPickupComponent.node.removeFromParentNode()
            mgPickupEntity.pickupParticleComponent.node.removeFromParentNode()
        }
        self.mgPickupEntities.removeAll()
        
        
        // Shotgun
        for shotgunPickupEntity in self.shotgunPickupEntities{
            shotgunPickupEntity.weaponPickupComponent.node.removeFromParentNode()
            shotgunPickupEntity.pickupParticleComponent.node.removeFromParentNode()
        }
        self.shotgunPickupEntities.removeAll()
        
        
        // Rocketlauncher
        for rpgPickupEntity in self.rpgPickupEntities{
            rpgPickupEntity.weaponPickupComponent.node.removeFromParentNode()
            rpgPickupEntity.pickupParticleComponent.node.removeFromParentNode()
        }
        self.rpgPickupEntities.removeAll()
        
        
        // Railgun
        for railgunPickupEntity in self.railgunPickupEntities{
            railgunPickupEntity.weaponPickupComponent.node.removeFromParentNode()
            railgunPickupEntity.pickupParticleComponent.node.removeFromParentNode()
        }
        self.railgunPickupEntities.removeAll()
        
        
        // Sinperrifle
        for sniperriflePickupEntity in self.sniperriflePickupEntities{
            sniperriflePickupEntity.weaponPickupComponent.node.removeFromParentNode()
            sniperriflePickupEntity.pickupParticleComponent.node.removeFromParentNode()
        }
        self.sniperriflePickupEntities.removeAll()
        
        
        // Redeemer
        for redeemerPickupEntity in self.redeemerPickupEntities{
            redeemerPickupEntity.weaponPickupComponent.node.removeFromParentNode()
            redeemerPickupEntity.pickupParticleComponent.node.removeFromParentNode()
        }
        self.redeemerPickupEntities.removeAll()
        
        for pickupEntities in self.allPickupEntities{
            for pickupEntity in pickupEntities{
                pickupEntity.weaponPickupComponent.node.removeFromParentNode()
                pickupEntity.pickupParticleComponent.node.removeFromParentNode()
            }
        }
        self.allPickupEntities.removeAll()
    }
    
//    func removeWeaponPickupEntities(weaponType:WeaponType){
//        for mgPickupEntity in self.mgPickupEntities{
//            mgPickupEntity.weaponPickupComponent.node.removeFromParentNode()
//        }
//        self.mgPickupEntities.removeAll()
//
////        for pickupEntities in self.allPickupEntities{
////            for pickupEntity in pickupEntities{
////                if(pickupEntity.weaponType == weaponType){
////                    pickupEntity.weaponPickupComponent.node.removeFromParentNode()
////                }
////                pickupEntities.removeAll()
////            }
////        }
//    }
    
    func getNewWeaponPickupEntity(weaponType:WeaponType, id:Int = 0)->BaseWeaponPickupEntity{
        var entityRet:BaseWeaponPickupEntity!
        switch weaponType {
            case .mg:
                entityRet = MachinegunPickupEntity(game: game, id: id)
            case .shotgun:
                entityRet = ShotgunPickupEntity(game: game, id: id)
            case .rpg:
                entityRet = RPGPickupEntity(game: game, id: id)
            case .railgun:
                entityRet = RailgunPickupEntity(game: game, id: id)
            case .sniperrifle:
                entityRet = SniperriflePickupEntity(game: game, id: id)
            case .redeemer:
                entityRet = RedeemerPickupEntity(game: game, id: id)
            default:
                break
        }
        return entityRet
    }
}
