//
//  BulletBase.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class BulletBase: SuakeBaseSCNNode {
    
    var damage:CGFloat = 10.0
    var shootingVelocity:CGFloat = 405.0
    var isTargetHit:Bool = false
    var isBeaming:Bool = false
    var weapon:BaseWeaponComponent!

    init(game: GameController) {
        super.init(game: game)
    }
    
    init(game:GameController, weapon: BaseWeaponComponent, sceneName:String = "", scale:SCNVector3 = SCNVector3(1, 1, 1), nodeName:String = "") {
        self.weapon = weapon
        super.init(game: game, sceneName: sceneName, scale: scale, name: nodeName)
    }
    
    func setupPhysics(geometry:SCNGeometry, type:SCNPhysicsBodyType, categoryBitMask:CollisionCategory, catBitMasks:[CollisionCategory]){

        let bulletShape = SCNPhysicsShape(geometry: geometry, options: nil)
        self.physicsBody = SCNPhysicsBody(type: type, shape: bulletShape)
        self.physicsBody?.categoryBitMask = categoryBitMask.rawValue
        var contactTestBitMask:Int = 0
        for catBitMask in catBitMasks{
            contactTestBitMask = contactTestBitMask | catBitMask.rawValue
        }
        self.physicsBody?.contactTestBitMask = contactTestBitMask
        self.physicsBody?.collisionBitMask = CollisionCategory.container.rawValue | CollisionCategory.generator.rawValue
        self.physicsBody?.restitution = 0.01
        self.physicsBody?.isAffectedByGravity = false
    }

    func addSingleBullet(pos:SCNVector3, vect:SCNVector3, origBullet:BulletBase, addBullets:Bool = true)->BulletBase{
        let newBulletNG:BulletBase = origBullet.getNewBullet()
        newBulletNG.position = pos
        newBulletNG.position.x -= 0.5
        newBulletNG.position.z += 1.0
        newBulletNG.position.y = 14
        newBulletNG.isBeaming = true
        newBulletNG.rotation = origBullet.rotation
        if(!((origBullet is RailgunBeam) || (origBullet is RPGRocketBlast))){
            newBulletNG.physicsBody!.velocity = vect
        }
        if(addBullets){
            self.game.physicsHelper.qeueNode2Add2Scene(node: newBulletNG)
        }
        return newBulletNG
    }

    
    func hitTarget(targetCat:Int, targetNode:SCNNode, contact: SCNPhysicsContact)->Bool{
        return self.hitTarget(targetCat: targetCat, targetNode: targetNode, contact: contact, overrideIsTargetHit: false)
    }

    func hitTarget(targetCat:Int, targetNode:SCNNode, contact: SCNPhysicsContact, overrideIsTargetHit:Bool = false)->Bool{
        if(!self.isTargetHit){
            if(!overrideIsTargetHit){
                self.isTargetHit = true
            }
            self.game.physicsHelper.qeueNode2Remove(node: self)

//            self.game.soundManager.playSound(soundType: .riochet1)
            self.game.soundManager.playBulletHitSound(weaponType: .mg, node: targetNode)
            // TODO: Change target hit sound to weapon specific sounds
//            self.game.audioManager.playBulletHitSound(weaponType: .mg, node: targetNode)

            // Suck your Mothers dick you little fuck
            self.game.showDbgMsg(dbgMsg: "Bullet hit " + (targetCat == CollisionCategory.floor.rawValue ? "floor" : "wall"), dbgLevel: .Verbose)
            return true
        }
        return false
    }
    
    
    func hitTarget(targetCat:CollisionCategory, targetNode:SCNNode, contact: SCNPhysicsContact)->Bool{
        return self.hitTarget(targetCat: targetCat, targetNode: targetNode, contact: contact, overrideIsTargetHit: false)
    }

    func hitTarget(targetCat:CollisionCategory, targetNode:SCNNode, contact: SCNPhysicsContact, overrideIsTargetHit:Bool = false)->Bool{
        if(!self.isTargetHit){
            if(!overrideIsTargetHit){
                self.isTargetHit = true
            }
            self.game.physicsHelper.qeueNode2Remove(node: self)

//            self.game.soundManager.playSound(soundType: .riochet1)
            self.game.soundManager.playBulletHitSound(weaponType: .mg, node: targetNode)
            // TODO: Change target hit sound to weapon specific sounds
//            self.game.audioManager.playBulletHitSound(weaponType: .mg, node: targetNode)

            // Suck your Mothers dick you little fuck
            self.game.showDbgMsg(dbgMsg: "Bullet hit " + (targetCat == CollisionCategory.floor ? "floor" : "wall"), dbgLevel: .Verbose)
            return true
        }
        return false
    }
    
//    func hitTarget(targetCat:CollisionCategory, targetNode:SCNNode, contactPoint:SCNVector3? = nil)->Bool{
//        return self.hitTarget(targetCat: targetCat, targetNode: targetNode, contactPoint: contactPoint, overrideIsTargetHit: false)
//    }
//
//    func hitTarget(targetCat:CollisionCategory, targetNode:SCNNode, contactPoint:SCNVector3? = nil, overrideIsTargetHit:Bool = false)->Bool{
//        if(!self.isTargetHit){
//            if(!overrideIsTargetHit){
//                self.isTargetHit = true
//            }
//            self.game.physicsHelper.qeueNode2Remove(node: self)
//
////            self.game.soundManager.playSound(soundType: .riochet1)
//            self.game.soundManager.playBulletHitSound(weaponType: .mg, node: targetNode)
//            // TODO: Change target hit sound to weapon specific sounds
////            self.game.audioManager.playBulletHitSound(weaponType: .mg, node: targetNode)
//
//            self.game.showDbgMsg(dbgMsg: "Bullet hit " + (targetCat == CollisionCategory.floor ? "floor" : "wall"), dbgLevel: .Verbose)
//            return true
//        }
//        return false
//    }

    func getNewBullet()->BulletBase{
        return BulletBase(game: self.game, weapon: self.weapon)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
