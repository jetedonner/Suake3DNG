//
//  DbgPointComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 23.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class BasePortalComponent: SuakeBaseLocationComponent {
    
//    let locationType:LocationType = .Portal
    var particleNode:SCNNode!
//    let portalPairId:Int
    var portalType:PortalType = .Portal_A
    var otherPortal:BasePortalComponent!
    
    var isBeaming:Bool = false
//    var contactNode:SCNNode!
    
    var _pos:SCNVector3 = SCNVector3(0, 0, 0)
    var pos:SCNVector3{
       get{ return self._pos }
       set{
            self._pos = newValue
            self.game.levelManager.gameBoard.setGameBoardField(pos: self.pos, suakeField: .portal)
            self.node.position = SCNVector3(self._pos.x * SuakeVars.fieldSize, self._pos.y, self._pos.z * SuakeVars.fieldSize)
    //               self.game.levelManager.gameBoard.setGameBoardField(pos: self.pos, suakeField: .empty)
    //               self._pos = newValue
    //               self.game.levelManager.gameBoard.setGameBoardField(pos: self.pos, suakeField: self.suakeField)
    //               let scnNodeComponents:[SuakeBaseSCNNodeComponent] = self.components(conformingTo: SuakeBaseSCNNodeComponent.self)
    //               for i in (0..<scnNodeComponents.count){
    //                   if( !scnNodeComponents[i].isKind(of: SuakeLightComponent.self) &&
    //                       !scnNodeComponents[i].isKind(of: SuakePlayerFollowCameraComponent.self) &&
    //                       !scnNodeComponents[i].isKind(of: SuakePlayerFollowCameraFPComponent.self) &&
    //                       !scnNodeComponents[i].isKind(of: RisingParticlesComponent.self) &&
    //                       !scnNodeComponents[i].isKind(of: MedKitRisingParticlesComponent.self)){
    //
    //                       if(!scnNodeComponents[i].isKind(of: SuakeBaseSuakePlayerComponent.self)){
    //                           scnNodeComponents[i].node.position = SCNVector3(self._pos.x * SuakeVars.fieldSize, self._pos.y, self._pos.z * SuakeVars.fieldSize)
    //                       }
    //                   }
    //               }
       }
    }
    
    init(game: GameController, id:Int = 0, portalType:PortalType = .Portal_A) {
        self.portalType = portalType
        super.init(game: game, node: SuakeBaseSCNNode(game: game, sceneName: "art.scnassets/particles/RisingParticlesGreenNG.scn"), locationType: .Portal, id: id)
        self.particleNode = self.node.childNode(withName: "particles", recursively: true)
        self.node.childNode(withName: "particles2", recursively: true)!.physicsField?.halfExtent = SCNVector3(x: 0.75, y: 1.0, z: 0.75)
        
        self.node.name = "Portal: " + self.id.description + "-" + self.portalType.rawValue
        
        //print("self.node.particleSystems?.count = " + (self.particleNode.particleSystems?.count.description)!)
        
        let colorAnimation:CAKeyframeAnimation = CAKeyframeAnimation()
        colorAnimation.values = [NSColor.cyan, NSColor.green] //, NSColor.blue, NSColor.red, NSColor.yellow]
        colorAnimation.duration = 1.0
        //colorAnimation.repeatCount = 10.0
//        let opacityAnimation:CAKeyframeAnimation = CAKeyframeAnimation()
//        opacityAnimation.values = [1.0, 0.7, 0.3, 0.0]
        
//        let colorController = SCNParticlePropertyController(animation: colorAnimation)
        //colorController.inputProperty = .
//        colorController.inputMode = .
//        let opatityController = SCNParticlePropertyController(animation: opacityAnimation)
        //self.particleNode.particleSystems![0].particleColor = NSColor.green
//        self.particleNode.particleSystems![0].propertyControllers = [SCNParticleSystem.ParticleProperty.color: colorController]
        self.addPhysicsBody(node: self.node)
//        self.addDbgText()
    }
    
    func activatePortation(node2Port:SCNNode, add2Scene:Bool = true){
        self.isBeaming = true
        self.game.soundManager.playSound(soundType: .teleporter)
        self.changeColor(alt: false)
        self.node.runAction(SCNAction.sequence([SCNAction.wait(duration: 1.0), SCNAction.run({_ in
            self.changeColor(alt: true)
//            if(add2Scene){
                self.game.physicsHelper.qeueNode2Add2Scene(node: node2Port)
//            }else{
//                node2Port.isHidden = false
//            }
            self.isBeaming = false
            self.game.showDbgMsg(dbgMsg: String(format: "Shot: Bullet (%@) beamed", node2Port.name!))
            //self.game.showDbgMsg(dbgMsg: String(format: DbgMsgs.bulletBeamedNG, arguments:[node2Port.name]))
            //self.game.showDbgMsg(dbgMsg: DbgMsgs.bulletBeamed)
        })]))
    }
    
    func activatePortation(entity2Port:SuakePlayerEntity, add2Scene:Bool = true){
        self.isBeaming = true
        if(entity2Port.playerType == .OwnSuake){
            (entity2Port as! SuakeOwnPlayerEntity).isBeaming = true
        }
        self.game.soundManager.playSound(soundType: .teleporter)
        self.changeColor(alt: false)
        self.node.runAction(SCNAction.sequence([SCNAction.wait(duration: 1.0), SCNAction.run({_ in
            
            self.changeColor(alt: true)
            entity2Port.playerComponent.currentSuakeComponent.node.isHidden = false
//            if(add2Scene){
                //self.game.physicsHelper.qeueNode2Add2Scene(node: node2Port)
//            }else{
//                node2Port.isHidden = false
//            }
            entity2Port.pos = self.pos
            entity2Port.cameraComponent.moveFollowCamera(turnDir: .Straight, duration: 0.0)//, moveDifference: -1)
            entity2Port.cameraComponent.moveRotateFPCamera(duration: 0.0, turnDir: .Straight, beamed: true, moveDifference: SuakeVars.fieldSize)
            self.game.overlayManager.hud.overlayScene.map.reposNode(playerNode: self.game.overlayManager.hud.overlayScene.map.suakeOwnNode, pos: self.pos, duration: 0.0)
            self.isBeaming = false
            if(entity2Port.playerType == .OwnSuake){
                (entity2Port as! SuakeOwnPlayerEntity).isBeaming = false
            }
            //self.game.showDbgMsg(dbgMsg: String(format: "SuakePlayer: Bullet (%@) beamed", node2Port.name!))
            //self.game.showDbgMsg(dbgMsg: String(format: DbgMsgs.bulletBeamedNG, arguments:[node2Port.name]))
            //self.game.showDbgMsg(dbgMsg: DbgMsgs.bulletBeamed)
        })]))
        self.game.wormHoleHelper.showWormHole(playerType: entity2Port.playerType)
    }
    
    func changeColor(alt:Bool = false){
        if(!alt){
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 1.0
//            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            let colorAnimation:CAKeyframeAnimation = CAKeyframeAnimation()
            colorAnimation.values = [NSColor.red, NSColor.blue]
            colorAnimation.duration = 1.0
            let colorController = SCNParticlePropertyController(animation: colorAnimation)
            self.particleNode.particleSystems![0].propertyControllers = [SCNParticleSystem.ParticleProperty.color: colorController]
//            SCNTransaction.commit()
        }else{
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 1.0
//            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            let colorAnimation:CAKeyframeAnimation = CAKeyframeAnimation()
            colorAnimation.values = [NSColor.cyan, NSColor.green]
            colorAnimation.duration = 1.0
            let colorController = SCNParticlePropertyController(animation: colorAnimation)
            self.particleNode.particleSystems![0].propertyControllers = [SCNParticleSystem.ParticleProperty.color: colorController]
//            SCNTransaction.commit()
        }
    }
    
    func initSetupPos(){
//        AddinG Portal connection [-2.0, 0.0, 2.0]->[-9.0, 0.0, 7.0]
//        AddinG Portal connection [-5.0, 0.0, 9.0]->[-9.0, 0.0, -7.0]
//        AddinG Portal connection [8.0, 0.0, -9.0]->[0.0, 0.0, 1.0]
        let pos:SCNVector3 = self.game.levelManager.gameBoard.getRandomFreePos()
        if(DbgVars.dbgOppAIPortal && self.portalType == .Portal_A && self.id == 0){
            self.pos = SCNVector3(-2, 0, 2)
        }else if(DbgVars.dbgOppAIPortal && self.portalType == .Portal_B && self.id == 0){
            self.pos = SCNVector3(-9, 0, 7)
        }else if(DbgVars.dbgOppAIPortal && self.portalType == .Portal_A && self.id == 1){
            self.pos = SCNVector3(-5, 0, 9)
        }else if(DbgVars.dbgOppAIPortal && self.portalType == .Portal_B && self.id == 1){
            self.pos = SCNVector3(6, 0, 3) // SCNVector3(-9, 0, -7)
        }else if(DbgVars.dbgOppAIPortal && self.portalType == .Portal_A && self.id == 2){
            self.pos = SCNVector3(8, 0, -9)
        }else if(DbgVars.dbgOppAIPortal && self.portalType == .Portal_B && self.id == 2){
            self.pos = SCNVector3(0, 0, 1)
        }else{
            self.pos = pos
        }
        
        self.game.levelManager.gameBoard.setGameBoardFieldItem(pos: self.pos, suakeFieldItem: self.entity as? SuakeBaseNodeEntity)
        (self.entity as! SuakeBaseNodeEntity)._pos = self.pos
//        self.pos = pos
        //(self.entity as! SuakeBaseNodeEntity).pos = pos // SCNVector3(-1, 0, 3)
    }
    
    func addPhysicsBody(node:SCNNode){
        let geo2:SCNGeometry = SCNCylinder(radius: 20, height: 100)
        //self.contactNode = SCNNode(geometry: geo2)
//        contactNode.opacity = 0
        
        let particleShape = SCNPhysicsShape(geometry: geo2, options: [SCNPhysicsShape.Option.scale: SCNVector3(1.0, 1.0, 1.0)])
        self.node.physicsBody = SCNPhysicsBody(type: .kinematic, shape: particleShape)
        self.node.physicsBody?.categoryBitMask = CollisionCategory(category: .portal).rawValue
        self.node.physicsBody?.contactTestBitMask = CollisionCategory(categories: [.rocket, .mgbullet, .pellet, .railbeam, .sniperRifleBullet]).rawValue
//        node.addChildNode(contactNode)
    }
    
    func addDbgText(){
        let txt:SCNNode = SCNNode()
        var inOut:String = "Portal: \(self.id) / "
        if(self.portalType == .Portal_A){
            inOut += "A"
//            inOut = "Portal Out: "
//            self.name = "PortalOut: " + grpId.description
        }else{
            inOut += "B"
//            self.name = "PortalIn: " + grpId.description
        }
        
        let text:SCNText = SCNText(string: inOut /*+  grpId.description + " (x: " + Int(coord.x).description + "/ z: " + Int(coord.z).description + ")"*/ , extrusionDepth: 2.5)
        
        txt.geometry = text
        txt.scale = SCNVector3(x: 0.2, y: 0.2, z: 0.2)
        txt.position.y += 30
        
        //Center pivot
        let (minVec, maxVec) = txt.boundingBox
        txt.pivot = SCNMatrix4MakeTranslation((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0)
        //scnView.scene?.rootNode.addChildNode(textNode)
        self.node.addChildNode(txt)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
