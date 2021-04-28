//
//  ContactHelper.swift
//  Suake3D
//
//  Created by dave on 31.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class ContactHelper: SuakeGameClass, SCNPhysicsContactDelegate {
    
    let allSuakeWeaponCategories:[CollisionCategory] = [.mgbullet, .pellet, .rocket, .railbeam, .sniperRifleBullet, .nuke, .nukeBlast, .laserbeam]
    let allSuakeWeaponPickupCategories:[CollisionCategory] = [.machinegunPickup, .shotgunPickup, .rpgPickup, .railgunPickup, .snipergunPickup, .nukePickup]
    
    override init(game:GameController){
        super.init(game:game)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if(self.checkPhysicsBody4CatBitMask(node: contact.nodeA, catBitMask: CollisionCategory.wall)){
            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMasks: self.allSuakeWeaponCategories)){
                if(contact.nodeB is MachinegunBullet){
                    if((contact.nodeB as! MachinegunBullet).hitTarget(targetCat: .wall, targetNode: contact.nodeA, contact: contact)){
                    }
                }else{
                    _ = (contact.nodeB as! BulletBase).hitTarget(targetCat: CollisionCategory.wall, targetNode: contact.nodeA, contactPoint: contact.contactPoint)
                }
            }
        }/*else if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMask: CollisionCategory.goody)){
            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeA, catBitMasks: self.allSuakeWeaponCategories)){
                self.game.playerEntityManager.goodyEntity.goodyHit()
//                self.game.playerEntityManager.getOwnPlayerEntity().goodyHit(bullet: (contact.nodeA as! BulletBase))
            }
        }*/else if(self.checkPhysicsBody4CatBitMask(node: contact.nodeA, catBitMask: CollisionCategory.goody)){
            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMasks: self.allSuakeWeaponCategories)){
                let bullet:BulletBase = (contact.nodeB as! BulletBase)
//                if(!bullet.isTargetHit){
//                    bullet.isTargetHit = true
//                }else{
//                    return
//                }
                if(contact.nodeB is MachinegunBullet){
                    if((contact.nodeB as! MachinegunBullet).hitTarget(targetCat: .wall, targetNode: contact.nodeA, contact: contact)){
                        if(bullet.weapon.weaponArsenalManager.playerEntity.playerType == .OwnSuake){
                            self.game.playerEntityManager.goodyEntity.goodyHit(bullet: bullet)
        //                    _ = self.game.playerEntityManager.getOwnPlayerEntity().goodyHit(bullet: (contact.nodeB as! BulletBase))
                        }else if(bullet.weapon.weaponArsenalManager.playerEntity.playerType == .OppSuake){
                            self.game.playerEntityManager.goodyEntity.goodyHit(bullet: bullet)
        //                    _ = self.game.playerEntityManager.getOppPlayerEntity()!.goodyHit(bullet: (contact.nodeB as! BulletBase))
                        }
                    }
                }else{
                    if(bullet.hitTarget(targetCat: .goody, targetNode: contact.nodeA)){
                        if(bullet.weapon.weaponArsenalManager.playerEntity.playerType == .OwnSuake){
                            self.game.playerEntityManager.goodyEntity.goodyHit(bullet: bullet)
        //                    _ = self.game.playerEntityManager.getOwnPlayerEntity().goodyHit(bullet: (contact.nodeB as! BulletBase))
                        }else if(bullet.weapon.weaponArsenalManager.playerEntity.playerType == .OppSuake){
                            self.game.playerEntityManager.goodyEntity.goodyHit(bullet: bullet)
        //                    _ = self.game.playerEntityManager.getOppPlayerEntity()!.goodyHit(bullet: (contact.nodeB as! BulletBase))
                        }
                    }
                }
            }
        }else if(self.checkPhysicsBody4CatBitMask(node: contact.nodeA, catBitMask: CollisionCategory.droid)){
            let bullet:BulletBase = (contact.nodeB as! BulletBase)
//                if(!bullet.isTargetHit){
//                    bullet.isTargetHit = true
//                }else{
//                    return
//                }
            
            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMasks: self.allSuakeWeaponCategories)){
                if(contact.nodeB is MachinegunBullet){
                    if((contact.nodeB as! MachinegunBullet).hitTarget(targetCat: .droid, targetNode: contact.nodeA, contact: contact)){
                        (contact.nodeA.entity as! DroidEntity).hitByBullet(bullet: (contact.nodeB as! BulletBase))
                    }
                }else{
                    if(bullet.hitTarget(targetCat: .droid, targetNode: contact.nodeB, contactPoint: contact.contactPoint)){
                        (contact.nodeA.entity as! DroidEntity).hitByBullet(bullet: (contact.nodeB as! BulletBase))
                    }
                }
            }
        }
            
//        if(self.checkPhysicsBody4CatBitMaskContains(node: contact.nodeA, catBitMask: CollisionCategory.suake)){
//            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMasks: self.allSuakeWeaponCategories)){
//                if((contact.nodeB as! BulletBase).weapon.weaponArsenalManager.playerEntity.playerType != .OwnSuake){
//                    self.game.playerEntityManager.getOwnPlayerEntity().hitByBullet(bullet: (contact.nodeB as! BulletBase))
//                }
//            }
//        }
        else if(self.checkPhysicsBody4CatBitMaskContains(node: contact.nodeA, catBitMask: CollisionCategory.suakeOpp)){
            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMasks: self.allSuakeWeaponCategories)){
                if((contact.nodeB as! BulletBase).weapon.weaponArsenalManager.playerEntity.playerType != .OppSuake){
                    if(contact.nodeB is MachinegunBullet){
                        if((contact.nodeB as! MachinegunBullet).hitTarget(targetCat: .suakeOpp, targetNode: contact.nodeA, contact: contact)){
                            self.game.playerEntityManager.oppPlayerEntity.hitByBullet(bullet: (contact.nodeB as! BulletBase))
                        }
                    }else{
                        if((contact.nodeB as! BulletBase).hitTarget(targetCat: .suakeOpp, targetNode: contact.nodeA)){
                            self.game.playerEntityManager.oppPlayerEntity.hitByBullet(bullet: (contact.nodeB as! BulletBase))
                        }
                    }
                }
            }
        }
//        }
        else if(self.checkPhysicsBody4CatBitMask(node: contact.nodeA, catBitMask: CollisionCategory.laserbeam) ||
            self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMask: CollisionCategory.laserbeam)){
            if(self.checkPhysicsBody4CatBitMaskContains(node: contact.nodeB, catBitMask: CollisionCategory.floor) || self.checkPhysicsBody4CatBitMaskContains(node: contact.nodeB, catBitMask: CollisionCategory.wall)){
                // (node: contact.nodeB, catBitMasks: [CollisionCategory.floor, CollisionCategory.wall])){
                _ = (contact.nodeA as! BulletBase).hitTarget(targetCat: .floor, targetNode: contact.nodeB)
//                if(!(contact.nodeA as! BulletBase).isTargetHit){
//                    (contact.nodeA as! BulletBase).isTargetHit = true
//                    self.game.physicsHelper.qeueNode2Remove(node: contact.nodeA)
//                }
            }else if(self.checkPhysicsBody4CatBitMaskContains(node: contact.nodeA, catBitMask: CollisionCategory.suake)){
                if((contact.nodeB as! BulletBase).hitTarget(targetCat: .suake, targetNode: contact.nodeA)){
                    self.game.playerEntityManager.ownPlayerEntity.hitByBullet(bullet: (contact.nodeB as! BulletBase))
                }
            }
        }
//        }else if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMask: CollisionCategory.goody)){
//            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeA, catBitMasks: self.allSuakeWeaponCategories)){
//                self.game.playerEntityManager.getOwnPlayerEntity().goodyHit(bullet: (contact.nodeA as! BulletBase))
//            }
//
//        }else if(self.checkPhysicsBody4CatBitMask(node: contact.nodeA, catBitMask: CollisionCategory.goody)){
//            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMasks: self.allSuakeWeaponCategories)){
//                if((contact.nodeB as! BulletBase).weapon.weaponArsenalManager.playerEntity.playerType == .OwnSuake){
//                    _ = self.game.playerEntityManager.getOwnPlayerEntity().goodyHit(bullet: (contact.nodeB as! BulletBase))
//                }else if((contact.nodeB as! BulletBase).weapon.weaponArsenalManager.playerEntity.playerType == .OppSuake){
//                    _ = self.game.playerEntityManager.getOppPlayerEntity()!.goodyHit(bullet: (contact.nodeB as! BulletBase))
//                }
//            }
//        }
    else if(self.checkPhysicsBody4CatBitMask(node: contact.nodeA, catBitMasks: self.allSuakeWeaponPickupCategories)){
            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMasks: self.allSuakeWeaponCategories)){
//                if(!(contact.nodeB as! BulletBase).isTargetHit){
//                    (contact.nodeB as! BulletBase).isTargetHit = true
//                let oldPos = (contact.nodeA.entity as! MachinegunPickupEntity).mgPickupComponent.node.position
                    (contact.nodeA.entity as! BaseWeaponPickupEntity).pickupWeapon(player: self.game.playerEntityManager.ownPlayerEntity, bullet: (contact.nodeB as! BulletBase))// .pickedUp()
                    //(contact.nodeA.entity as! DroidEntity).hitByBullet(bullet: (contact.nodeB as! BulletBase))
//                }
                
            }
        }//else if(self.checkPhysicsBody4CatBitMask(node: contact.nodeA, catBitMask: CollisionCategory.droid)){
//            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMasks: self.allSuakeWeaponCategories)){
//                (contact.nodeA.entity as! DroidEntity).hitByBullet(bullet: (contact.nodeB as! BulletBase))
//            }
//        }
    else if(self.checkPhysicsBody4CatBitMask(node: contact.nodeA, catBitMask: CollisionCategory.container)){
        if(contact.nodeB is MachinegunBullet){
            if((contact.nodeB as! MachinegunBullet).hitTarget(targetCat: .container, targetNode: contact.nodeA, contact: contact)){
                
                //(contact.nodeA.entity as! MedKitEntity).medKitCollected(bullet: (contact.nodeB as! BulletBase))
            }
        }
    }
    /*else if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMask: CollisionCategory.container)){
        var tmp = 1
        tmp /= -1
    }*/
    else if(self.checkPhysicsBody4CatBitMask(node: contact.nodeA, catBitMask: CollisionCategory.medKit)){
            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMasks: self.allSuakeWeaponCategories)){
                if((contact.nodeB as! BulletBase).hitTarget(targetCat: .medKit, targetNode: contact.nodeA, contactPoint: contact.contactPoint)){
                    (contact.nodeA.entity as! MedKitEntity).medKitCollected(bullet: (contact.nodeB as! BulletBase))
                }
            }
    }
//        }else if(self.checkPhysicsBody4CatBitMask(node: contact.nodeA, catBitMask: CollisionCategory.portal)){
//            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMask: CollisionCategory.mgbullet)){
//                (contact.nodeA.entity as! PortalEntity).beamShot(origShot: (contact.nodeB as! BulletBase), contactNode: contact.nodeA)
//            }
//            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMask: CollisionCategory.pellet)){
//                (contact.nodeA.entity as! PortalEntity).beamShot(origShot: (contact.nodeB as! BulletBase), contactNode: contact.nodeA)
//            }
//            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMask: CollisionCategory.rocket)){
//                (contact.nodeA.entity as! PortalEntity).beamShot(origShot: (contact.nodeB as! BulletBase), contactNode: contact.nodeA)
//            }
//            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMask: CollisionCategory.railbeam)){
//                if(!(contact.nodeB as! RailgunBeam).isBeamed){
//                    (contact.nodeA.entity as! PortalEntity).beamShot(origShot: (contact.nodeB as! BulletBase), contactNode: contact.nodeA)
//                }
//            }
//            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMask: CollisionCategory.sniperRifleBullet)){
//                (contact.nodeA.entity as! PortalEntity).beamShot(origShot: (contact.nodeB as! BulletBase), contactNode: contact.nodeA)
//            }
//        }else if(self.checkPhysicsBody4CatBitMask(node: contact.nodeA, catBitMask: CollisionCategory.wall)){
//            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMasks: self.allSuakeWeaponCategories)){
//                _ = (contact.nodeB as! BulletBase).hitTarget(targetCat: CollisionCategory.wall, targetNode: contact.nodeA, contactPoint: contact.contactPoint)
//            }
//        }else if(self.checkPhysicsBody4CatBitMask(node: contact.nodeB, catBitMask: CollisionCategory.floor)){
//            if(self.checkPhysicsBody4CatBitMask(node: contact.nodeA, catBitMasks: self.allSuakeWeaponCategories)){
//                _ = (contact.nodeA as! BulletBase).hitTarget(targetCat: CollisionCategory.floor, targetNode: contact.nodeB, contactPoint: contact.contactPoint)
//            }
//        }
    }
    
    func checkPhysicsBody4CatBitMaskContains(node:SCNNode, catBitMask:CollisionCategory)->Bool{
        return node.physicsBody!.categoryBitMask | catBitMask.rawValue == node.physicsBody!.categoryBitMask
    }
    
    func checkPhysicsBody4CatBitMask(node:SCNNode, catBitMask:CollisionCategory)->Bool{
        return self.checkPhysicsBody4CatBitMask(node: node, catBitMasks: [catBitMask])
    }
    
    func checkPhysicsBody4CatBitMask(node:SCNNode, catBitMasks:[CollisionCategory])->Bool{
        for catBitMask in catBitMasks{
             if(node.physicsBody?.categoryBitMask == catBitMask.rawValue){
                return true
            }
        }
        return false
    }
}
