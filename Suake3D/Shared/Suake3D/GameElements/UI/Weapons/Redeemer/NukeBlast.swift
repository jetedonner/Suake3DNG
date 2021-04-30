//
//  NukeBlast.swift
//  Suake3D
//
//  Created by Kim David Hauser on 14.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class NukeBlast:BulletBase{

    var hasDetonated:Bool = false
    let blastRescaleFactor:CGFloat = 128.0
    let blastRescale:SCNVector3 = SCNVector3(128.0, 128.0, 128.0)
    
    override init(game: GameController, weapon: BaseWeaponComponent, sceneName: String = "", scale: SCNVector3 = SCNVector3(1, 1, 1), nodeName: String = "") {
        super.init(game: game, weapon: weapon)
        self.name = "Redeemer nuke blast"
        self.damage = SuakeVars.REDEEMER_DAMAGE
    }
//    override init(game: GameController, weapon:BaseWeaponComponent, nodeName: String = "") {
//        super.init(game: game, weapon: weapon)
//        self.name = "Redeemer nuke blast"
//        self.damage = SuakeVars.NUKE_DAMAGE
//    }
    
//    override func hitTarget(targetCat:CollisionCategory, targetNode:SCNNode, contactPoint:SCNVector3? = nil)->Bool{
    override func hitTarget(targetCat:CollisionCategory, targetNode:SCNNode, contact: SCNPhysicsContact)->Bool{
//        if(!self.isTargetHit){
//            self.isTargetHit = true
//            self.weapon.nukeFlying = false
            self.game.scnView.pointOfView = self.game.cameraHelper.cameraNode
//            self.explodeRocket(targetNode: targetNode, removeTargetNode: false, pos: contactPoint)
            //return true
        return super.hitTarget(targetCat: targetCat, targetNode: targetNode, contact: contact)
//            return super.hitTarget(targetCat: targetCat, targetNode: targetNode, contactPoint: contactPoint, overrideIsTargetHit: true)
//        }
//        return false
    }
    
    func blastSphere() -> SCNSphere {
        let blastSphere = SCNSphere(radius: 2.52)
        blastSphere.firstMaterial!.diffuse.contents = NSColor.red
        return blastSphere
    }
    
    public func detonateNuke(pos:SCNVector3){
        if(!self.hasDetonated){
            self.hasDetonated = true
//            origCameraRotation = self.game.scnView!.pointOfView?.rotation
            self.game.scnView.pointOfView?.look(at: pos)
            let geom:SCNSphere = self.blastSphere()
            //let blastNode = SCNNode(geometry: geom)
            self.geometry = geom
            //blastNode.position = pos
            self.position = pos
            let shape = SCNPhysicsShape(geometry: geom, options: [SCNPhysicsShape.Option.scale: self.blastRescale])
            
            self.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
            self.physicsBody?.isAffectedByGravity = false
            self.physicsBody?.categoryBitMask = CollisionCategory(category: .nukeBlast).rawValue
            self.physicsBody?.contactTestBitMask = CollisionCategory(categories: [.suakeOpp, .goody, .medKit, .droid]).rawValue
            self.physicsBody?.collisionBitMask = 0
            
//            blastNode.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
//            blastNode.physicsBody?.isAffectedByGravity = false
//            blastNode.physicsBody?.categoryBitMask = CollisionCategory(category: .nukeBlast).rawValue
//            blastNode.physicsBody?.contactTestBitMask = CollisionCategory(categories: [.suakeOpp, .goody, .medKit, .droid]).rawValue
//            blastNode.physicsBody?.collisionBitMask = 0
//            self.addChildNode(blastNode)
//            self.game.scnView.scene!.rootNode.addChildNode(blastNode)
            self.game.physicsHelper.qeueNode2Add2Scene(node: self)
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 2.0
            SCNTransaction.completionBlock = {
//                SCNTransaction.begin()
//                SCNTransaction.animationDuration = 0.5
//                //self.game.scnView.pointOfView?.rotation = self.origCameraRotation
//                SCNTransaction.commit()
                DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 2.0, execute: {
                    self.game.physicsHelper.qeueNode2Remove(node: self)
                    //(self.weapon as? Redeemer)?.nukeBlasts.remove(at: 0)
                })
            }
            geom.firstMaterial!.diffuse.contents = NSColor.white
            geom.firstMaterial?.transparency = 0.0
            self.scale = self.blastRescale
            SCNTransaction.commit()
            
            self.game.soundManager.playSoundPositional(soundType: .nukeExplosion, node: self)
//            self.game.mediaManagerPositional.playSoundPositional(soundType: .nuc_explosion, node: blastNode, completionHandler: {
//                self.game.showDbgMsg(dbgMsg: "Nuke explosion sound finished")
//            })
//            MenuCursor.showCursor()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
