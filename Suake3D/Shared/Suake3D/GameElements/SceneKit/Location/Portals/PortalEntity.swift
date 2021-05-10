//
//  DbgPoint.swift
//  Suake3D
//
//  Created by Kim David Hauser on 23.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class PortalEntity: SuakeBaseNodeEntity {

//    var pairComponent:PortalPairComponent!
    var portalType:PortalType = .Portal_A
    var otherPortal:PortalEntity!
    var pairEntity:PortalEntityPair!
    var portalComponent:BasePortalComponent!
    
    
    
    init(game: GameController, pairEntity:PortalEntityPair, id:Int = 0, portalType:PortalType = .Portal_A) {
        super.init(game: game, id: id)
//        self.pairComponent = PortalPairComponent(game: game, id: id)
        self.pairEntity = pairEntity
        self.portalType = portalType
        self.portalComponent = BasePortalComponent(game: game, id: id, portalType: portalType)
        self.addComponent(self.portalComponent)
//        self.addComponent(self.pairComponent)
//        self.addComponent(pairComponent.portals[0])
//        self.addComponent(pairComponent.portals[1])
    }
    
//    var toPortal:BasePortalComponent!
    var newBullet:BulletBase!
    
    func beamShot(origShot:BulletBase, contactNode:SCNNode){
        let rn:BulletBase = origShot
        if(!rn.isBeaming){
            rn.isBeaming = true
            let daNode:SuakeBaseSCNNode = (contactNode as! SuakeBaseSCNNode)
            var newPos:SCNVector3!
            var fromPortal:BasePortalComponent!
            var toPortal:BasePortalComponent!
            
            if(self.position.x == daNode.position.x &&
                self.position.z == daNode.position.z){
                fromPortal = self.portalComponent
                toPortal = self.otherPortal.portalComponent
            }else{
                fromPortal = self.otherPortal.portalComponent
                toPortal = self.portalComponent
            }
//            if(pairComponent.portals[0].node.position.x == daNode.position.x && pairComponent.portals[0].node.position.z == daNode.position.z){
//                fromPortal = pairComponent.aPortal //.portals[0]
//                toPortal = pairComponent.bPortal // portals[1]
//            }else{
//                fromPortal = pairComponent.bPortal // pairComponent.portals[1]
//                toPortal = pairComponent.aPortal // pairComponent.portals[0]
//            }

            if(fromPortal.isBeaming || toPortal.isBeaming && !(origShot is ShotgunPellet)){
                return
            }

            newPos = toPortal.pos
            newPos = SCNVector3(newPos.x * SuakeVars.fieldSize, 0, newPos.z * SuakeVars.fieldSize)
            self.newBullet = origShot.addSingleBullet(pos: newPos, vect: rn.physicsBody!.velocity, origBullet: origShot, addBullets: false)
            self.newBullet.name = origShot.name
            if(!(origShot is RailgunBeam)){
                self.game.physicsHelper.qeueNode2Remove(node: origShot)
            }
            if(origShot is ShotgunPellet){
                (origShot as! ShotgunPellet).pelletGrp.checkAllPelletsBeamed()
            }
            toPortal.activatePortation(node2Port: self.newBullet)
        }
    }
    
    func beamSuakeNode(suakeEntity:SuakePlayerEntity, portal:Int){
        
        var fromPortal:BasePortalComponent!
        var toPortal:BasePortalComponent!
        var newPos:SCNVector3!
        if(portal == 0){
            fromPortal = self.portalComponent
            toPortal = self.otherPortal.portalComponent
//            fromPortal = pairComponent.aPortal
//            toPortal = pairComponent.bPortal
        }else{
            fromPortal = self.portalComponent
            toPortal = self.otherPortal.portalComponent
//            fromPortal = pairComponent.bPortal
//            toPortal = pairComponent.aPortal
        }
        
        if(fromPortal.isBeaming || toPortal.isBeaming){
            return
        }
        newPos = toPortal.pos
        print("Beaming suakeNode to: x: " + newPos.x.description + ", z: " + newPos.z.description)
        suakeEntity.pos = newPos
        suakeEntity.playerComponent.currentSuakeComponent.node.isHidden = true
        toPortal.activatePortation(entity2Port: suakeEntity)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
