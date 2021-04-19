//
//  MapOverlayExt.swift
//  Suake3D
//
//  Created by Kim David Hauser on 18.03.21.
//

import Foundation
import SceneKit
import SpriteKit
import GameplayKit
import NetTestFW

extension MapOverlay{
    
    func addNodes(){
        self.map.addChild(self.suakeOwnNode)
        self.map.addChild(self.suakeOppNode)
        
        self.map.addChild(self.goodyNode)
        
        for droid in self.droidNodes{
            self.map.addChild(droid)
        }
        
        for medKit in self.medKitNodes {
            self.map.addChild(medKit)
        }
    }
    
    func drawNodes(){
        
        self.updateLineCount()
        if let ownPlayerEntity = self.game.playerEntityManager.ownPlayerEntity{
            self.suakeOwnNode = self.drawNodeIcon(iconFile: "Snake_red_48x48.png", pos:  ownPlayerEntity.pos)
            ownPlayerEntity.mapNode = self.suakeOwnNode
            self.suakeOwnNode = self.rotateNode(node: self.suakeOwnNode, dir: ownPlayerEntity.dir)
        }
        
        if let oppPlayerEntity = self.game.playerEntityManager.oppPlayerEntity{
            self.suakeOppNode = self.drawNodeIcon(iconFile: "Snake_blue_48x48.png", pos:  oppPlayerEntity.pos)
            oppPlayerEntity.mapNode = self.suakeOppNode
            self.suakeOppNode = self.rotateNode(node: self.suakeOppNode, dir: oppPlayerEntity.dir)
        }
        
        
        self.goodyNode = self.drawNodeIcon(iconFile: "GoodyIcon37x37.png", pos: self.game.playerEntityManager.goodyEntity.pos)
        self.game.playerEntityManager.goodyEntity.mapNode = self.goodyNode
        
        if(self.game.levelManager.currentLevel.levelConfig.levelSetup.loadDroids){
            for droid in self.game.playerEntityManager.droidsNotDead{
                let daDroid:SuakeSpriteNodeMultiTextures = drawNodeIconNGMulti(iconFiles: ["Droid_48x48_green.png", "Droid_48x48_orange.png", "Droid_48x48_red.png"], pos: droid.pos)
                daDroid.id = droid.id
                droid.mapNode = daDroid
                droidNodes.append(daDroid)
            }
        }
        
        self.medKitNodes = self.drawNodeGroupIcons(texture: iconMediKit, group: (self.game.locationEntityManager.entityGroups[.MedKit]?.first)!)

    }
    
    func drawNodeIconNGMulti(iconFiles:[String], pos:SCNVector3, alphaOverride:CGFloat = -1.0)->SuakeSpriteNodeMultiTextures{
        var textures:[SKTexture] = [SKTexture]()
        for iconFile in iconFiles{
            textures.append(SKTexture(imageNamed: "art.scnassets/overlays/gameplay/map/" + iconFile))
        }
        return drawNodeIconNGMulti(textures: textures, pos: pos, alphaOverride: alphaOverride)
    }
    
    func drawNodeIconNGMulti(textures:[SKTexture], pos:SCNVector3, alphaOverride:CGFloat = -1.0)->SuakeSpriteNodeMultiTextures{
        let icon:SuakeSpriteNodeMultiTextures = SuakeSpriteNodeMultiTextures(textures: textures)
        icon.position = getNodePos(pos: pos)
        if(alphaOverride != -1.0){
            icon.alpha = alphaOverride
        }else{
            icon.alpha = alpha
        }
        return icon
    }
    
    func drawNodeGroupIcons(texture:SKTexture, group:SuakeNodeGroupBase)->[SuakeSpriteNode]{
        var icons:[SuakeSpriteNode] = [SuakeSpriteNode]()
        for i in (0..<group.groupItems.count){
            let icon:SuakeSpriteNode = drawNodeIcon(texture: texture, pos: group.groupItems[i].pos)
            group.groupItems[i].mapNode = icon
            icon.id = group.groupItems[i].id
            icons.append(icon)
        }
        return icons
    }
    
    func drawNodeIcon(iconFile:String, pos:SCNVector3, alphaOverride:CGFloat = -1.0)->SuakeSpriteNode{
        return drawNodeIcon(texture: SKTexture(imageNamed: "art.scnassets/overlays/gameplay/map/" + iconFile), pos: pos, alphaOverride: alphaOverride)
    }
    
    func drawNodeIcon(texture:SKTexture, pos:SCNVector3, alphaOverride:CGFloat = -1.0)->SuakeSpriteNode{
        let icon:SuakeSpriteNode = SuakeSpriteNode(texture: texture)
        icon.position = getNodePos(pos: pos)
        if(alphaOverride != -1.0){
            icon.alpha = alphaOverride
        }else{
            icon.alpha = alpha
        }
        return icon
    }
    
    @discardableResult
    func rotateNode(node:SuakeSpriteNode, dir:SuakeDir)->SuakeSpriteNode{
        node.run(getRotationAction(dir: dir))
        return node
    }
    
    func getRotationAction(dir:SuakeDir, duration:TimeInterval = 0.0) -> SKAction {
        var rotationAction:SKAction = SKAction.rotate(toAngle: 0, duration: duration, shortestUnitArc: true)
        if(dir == .DOWN){
            rotationAction = SKAction.rotate(toAngle: CGFloat.pi * 1.0, duration: duration, shortestUnitArc: true)
        }else if(dir == .LEFT){
            rotationAction = SKAction.rotate(toAngle: CGFloat.pi * 0.5, duration: duration, shortestUnitArc: true)
        }else if(dir == .RIGHT){
            rotationAction = SKAction.rotate(toAngle: CGFloat.pi * 1.5, duration: duration, shortestUnitArc: true)
        }
        return rotationAction
    }
    
    func getNodePos(pos:SCNVector3)->CGPoint{
        let fx:CGFloat = (pos.x * -fieldWidth) - (fieldWidth / 2)
        let fy:CGFloat = (pos.z * fieldWidth) + (fieldWidth / 2)
        return CGPoint(x: fx, y: fy)
    }
    
    public func reposNodeInit(locationType:LocationType, id:Int = 0, pos:SCNVector3){
        switch locationType {
        case .MedKit:
            self.reposNode(playerNode: self.medKitNodes[id], pos: pos)
//            if let index = self.medKitNodes.firstIndex(where: { $0.id == id }) {
//                let medKitNode = self.medKitNodes[index]
//                for ent in self.game.locationEntityManager.entityGroups[.MedKit]!.enumerated(){
//                    for medKitEntity in (ent.element as! MedKitEntityGroup).groupItems{
//                        if((medKitEntity as! MedKitEntity).id == id){
//                            self.reposNode(playerNode: medKitNode, pos: (medKitEntity as! MedKitEntity).pos)
//                        }
//                    }
//                }
//
//            }
//            let medKitNode = self.medKitNodes. { $0.id == id }
//            self.reposNode(playerNode: medKitNode, pos: medKitNode)
            break
        default:
            break
        }
    }
    
    
    public func reposNodeInitNG(mapNode:SuakeSpriteNode, pos:SCNVector3, duration:TimeInterval = 0.0){
        self.reposNode(playerNode: mapNode, pos: pos, duration: duration)
    }
    
    func rotatePlayerNodesNG(mapNode:SuakeSpriteNode, dir:SuakeDir, delta:TimeInterval = SuakeVars.gameStepInterval){
        let rotationAction:SKAction = self.getRotationAction(dir: dir, duration: SuakeVars.gameStepInterval - delta)
        mapNode.run(SKAction.group([rotationAction]))
        
//        self.rotatePlayerNode(playerNode: mapNode, playerEntity: self.game.playerEntityManager.ownPlayerEntity, delta: delta)
//        self.rotatePlayerNode(playerNode: self.suakeOppNode, playerEntity: self.game.playerEntityManager.oppPlayerEntity, delta: delta)
    }
    
    public func reposNodeInit(playerType:SuakePlayerType, id:Int = 0){
        switch playerType {
        case .OwnSuake:
            if let ownSuakeEntity = self.game.playerEntityManager.ownPlayerEntity {
                self.reposNode(playerNode: self.suakeOwnNode, pos: ownSuakeEntity.pos)
                self.rotateNode(node: self.suakeOwnNode, dir: ownSuakeEntity.dir)
            }
            break
        case .OppSuake:
            if let oppSuakeEntity = self.game.playerEntityManager.oppPlayerEntity {
                self.reposNode(playerNode: self.suakeOppNode, pos: oppSuakeEntity.pos)
                self.rotateNode(node: self.suakeOppNode, dir: oppSuakeEntity.dir)
            }
            break
        case .Droid:
            self.reposNode(playerNode: self.droidNodes[id], pos: self.game.playerEntityManager.droidEntities[id].pos, duration: SuakeVars.gameStepInterval)
            break
        default:
            break
        }
    }
    
    public func reposNode(playerNode:SuakeSpriteNode, pos:SCNVector3, duration:TimeInterval = 0.0){
        //node.position = getNodePos(pos: pos)
        playerNode.removeAllActions()
        playerNode.run(SKAction.move(to: getNodePos(pos: pos), duration: duration))
    }
    
    func movePlayerNodes(delta:TimeInterval = SuakeVars.gameStepInterval){
        self.movePlayerNode(playerNode: self.suakeOwnNode, playerEntity: self.game.playerEntityManager.ownPlayerEntity, delta: delta)
        self.movePlayerNode(playerNode: self.suakeOppNode, playerEntity: self.game.playerEntityManager.oppPlayerEntity, delta: delta)
        
        if(self.game.usrDefHlpr.loadDroids){
            self.reposNodeInit(playerType: .Droid, id: 0)
        }
    }
    
    func rotatePlayerNodes(delta:TimeInterval = SuakeVars.gameStepInterval){
        self.rotatePlayerNode(playerNode: self.suakeOwnNode, playerEntity: self.game.playerEntityManager.ownPlayerEntity, delta: delta)
        self.rotatePlayerNode(playerNode: self.suakeOppNode, playerEntity: self.game.playerEntityManager.oppPlayerEntity, delta: delta)
    }
    
    func rotatePlayerNode(playerNode:SuakeSpriteNode, playerEntity:SuakeBasePlayerEntity, delta:TimeInterval = SuakeVars.gameStepInterval){
        if((playerEntity as! SuakeBaseExplodingPlayerEntity).playerType == .OwnSuake){
            let rotationAction:SKAction = self.getRotationAction(dir: (playerEntity as! SuakeOwnPlayerEntity).dir, duration: SuakeVars.gameStepInterval - delta)
            playerNode.run(SKAction.group([rotationAction]))
        }else if((playerEntity as! SuakeBaseExplodingPlayerEntity).playerType == .OppSuake){
            let rotationAction:SKAction = self.getRotationAction(dir: (playerEntity as! SuakeOppPlayerEntity).dir, duration: SuakeVars.gameStepInterval - delta)
            playerNode.run(SKAction.group([rotationAction]))
        }
    }
    func movePlayerNode(playerNode:SuakeSpriteNode, playerEntity:SuakeBasePlayerEntity, delta:TimeInterval = SuakeVars.gameStepInterval){
        if((playerEntity as! SuakeBaseExplodingPlayerEntity).playerType == .OwnSuake){
            let overNextPos:SCNVector3 = (playerEntity as! SuakeOwnPlayerEntity).moveComponent.overNextPos
            let moveAction:SKAction = SKAction.move(to: self.getNodePos(pos: overNextPos), duration: SuakeVars.gameStepInterval)
            playerNode.run(SKAction.group([moveAction]))
        }else if((playerEntity as! SuakeBaseExplodingPlayerEntity).playerType == .OwnSuake){
            let overNextPos:SCNVector3 = (playerEntity as! SuakeOppPlayerEntity).moveComponent.overNextPos
            let moveAction:SKAction = SKAction.move(to: self.getNodePos(pos: overNextPos), duration: SuakeVars.gameStepInterval)
            playerNode.run(SKAction.group([moveAction]))
        }
    }
    
}
