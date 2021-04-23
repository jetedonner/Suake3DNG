//
//  DroidComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class DroidComponent: SuakeBaseSCNNodeComponent {

    var playerEntity:DroidEntity{
        get{ return self.entity as! DroidEntity }
    }
    
    var lightNode:SCNNode!
    var lightLowNode:SCNNode!
    var antennaNCLNode:SCNNode!
    var antennaLowNode:SCNNode!
    var antennaNode:SCNNode!
    var flashLight:SCNNode!
    var flashLightInner:SCNNode!
    let flashLightRotationAnimation = CABasicAnimation(keyPath: "eulerAngles")
    let flashMaterial:SCNMaterial = SCNMaterial()
    
    init(game: GameController, id:Int) {
        super.init(game: game, node: SuakeBaseMultiAnimatedSCNNode(game: game, sceneName: "art.scnassets/nodes/droid/DroidWithFlashLight.scn", scale: SuakeVars.droidScale, animNames: [SuakeVars.droidModelAnimName, SuakeVars.droidModelAnimName2], name: "Droid: " + id.description), id: id)
        self.initPhysicsBody()
        self.node.childNode(withName: "body_low", recursively: true)?.categoryBitMask = CollisionCategory.droid.rawValue
        self.initDroidLights()
    }
    
    func initPhysicsBody(){
        let droidShape = SCNPhysicsShape(geometry: self.node.childNode(withName: "group", recursively: true)!.flattenedClone().geometry!, options: [SCNPhysicsShape.Option.scale: SuakeVars.droidScale])
        self.node.physicsBody = SCNPhysicsBody(type: .kinematic, shape: droidShape)
        self.node.physicsBody?.isAffectedByGravity = false
        self.node.physicsBody?.categoryBitMask = CollisionCategory(category: .droid).rawValue
        self.node.physicsBody?.contactTestBitMask = CollisionCategory(categories: [.mgbullet, .pellet]).rawValue
        self.node.physicsBody?.collisionBitMask = 0
    }
    
    func initDroidLights(){
        self.flashLightRotationAnimation.byValue = SCNVector3(x: CGFloat(0.0), y: CGFloat(CGFloat.pi * 2.0), z: CGFloat(0.0))
        self.flashLightRotationAnimation.duration = SuakeVars.dbgDroidFLTurnDuration
        self.flashLightRotationAnimation.repeatCount = .infinity

        self.flashMaterial.diffuse.contents = NSColor.green
        
        self.lightNode = (self.node as! SuakeBaseMultiAnimatedSCNNode).childNode(withName: "light", recursively: true)
        self.lightNode.geometry?.replaceMaterial(at: 0, with: self.flashMaterial)
//        self.lightNode.geometry = self.lightNode.copy() as! SCNGeometry
        self.lightLowNode = (self.node as! SuakeBaseMultiAnimatedSCNNode).childNode(withName: "light_low", recursively: true)
        self.lightLowNode.geometry?.replaceMaterial(at: 0, with: self.flashMaterial)
        self.antennaNCLNode = (self.node as! SuakeBaseMultiAnimatedSCNNode).childNode(withName: "antenna_ncl1_1", recursively: true)
        self.antennaNCLNode.geometry?.replaceMaterial(at: 0, with: self.flashMaterial)
        self.antennaLowNode = (self.node as! SuakeBaseMultiAnimatedSCNNode).childNode(withName: "antenna_low", recursively: true)
        self.antennaLowNode.geometry?.replaceMaterial(at: 0, with: self.flashMaterial)
        self.antennaNode = (self.node as! SuakeBaseMultiAnimatedSCNNode).childNode(withName: "antenna", recursively: true)
        self.antennaNode.geometry?.replaceMaterial(at: 0, with: self.flashMaterial)
        self.flashLight = self.node.childNode(withName: "flash_light", recursively: true)
        self.flashLight.geometry?.insertMaterial(self.flashMaterial, at: 0)
////        self.flashLight.eulerAngles.x = -0.46Q
//        self.flashLight.light?.color = NSColor.green
        self.flashLightInner = self.node.childNode(withName: "flInner", recursively: true)!
        self.flashLightInner.addAnimation(self.flashLightRotationAnimation, forKey: nil)
//        self.flashLight.addAnimation(self.flashLightRotationAnimation, forKey: nil)
    }
    
    func initSetupPos(addToScene:Bool = true){
        let pos:SCNVector3 = SuakeVars.droidPos
        (self.entity as! SuakeBaseNodeEntity).pos = pos
        self.node.position = SCNVector3(pos.x * SuakeVars.fieldSize, 0, pos.z * SuakeVars.fieldSize)
        (self.node as! SuakeBaseMultiAnimatedSCNNode).stopAnimAndReset()
        self.rotateDroid(newDir: .DOWN, duration: 0.0)
        self.game.levelManager.gameBoard.setGameBoardField(pos: pos, suakeField: .droid)
    }
    
    @discardableResult
    func rotateDroid(newDir:SuakeDir, duration:TimeInterval = SuakeVars.gameStepInterval)->TurnDir{
        let dir:SuakeDir = (self.entity as! DroidEntity).dir
        if(newDir != dir){
            if((dir == .UP && newDir == .RIGHT) ||
                (dir == .RIGHT && newDir == .DOWN) ||
                (dir == .DOWN && newDir == .LEFT) ||
                (dir == .LEFT && newDir == .UP)){
                self.node.runAction(SCNAction.rotateBy(x: 0, y: CGFloat.pi / -2, z: 0, duration: duration))
                (self.entity as! DroidEntity).dir = newDir
                return .Right
            }else if((dir == .UP && newDir == .LEFT) ||
                (dir == .LEFT && newDir == .DOWN) ||
                (dir == .DOWN && newDir == .RIGHT) ||
                (dir == .RIGHT && newDir == .UP)){
                self.node.runAction(SCNAction.rotateBy(x: 0, y: CGFloat.pi / 2, z: 0, duration: duration))
                (self.entity as! DroidEntity).dir = newDir
                return .Left
            }else if((dir == .UP && newDir == .DOWN) ||
                (dir == .LEFT && newDir == .RIGHT) ||
                (dir == .DOWN && newDir == .UP) ||
                (dir == .RIGHT && newDir == .LEFT)){
                self.node.runAction(SCNAction.rotateBy(x: 0, y: CGFloat.pi, z: 0, duration: duration))
                (self.entity as! DroidEntity).dir = newDir
                return .One80
            }
        }
        return .Straight
    }
    
    @discardableResult
    func nextMove(newDir:SuakeDir)->Bool{
//        var turnDir:TurnDir = .Straight
        if(newDir != self.playerEntity.dir){
//            turnDir = self.rotateDroid(newDir: newDir)
            self.rotateDroid(newDir: newDir)
            (self.node as! SuakeBaseMultiAnimatedSCNNode).getAnimPlayer()!.stop()
            if(self.game.gameCenterHelper.isMultiplayerGameRunning){
                let droidEntity:DroidEntity = (self.entity as! DroidEntity)
                self.game.gameCenterHelper.matchMakerHelper.sendDroidDirMsg(nextDir: newDir, position: droidEntity.pos, playerId: "Droid-\(droidEntity.id)")//(turnDir: turnDir, position: droidEntity.pos, playerId: "Droid-\(droidEntity.id)")
            }
            return false
        }else{
            self.nextStep()
            (self.node as! SuakeBaseMultiAnimatedSCNNode).getAnimPlayer()!.play()
            return true
        }
    }
    
    func nextStep(){
        SCNTransaction.begin()
        SCNTransaction.animationDuration = SuakeVars.gameStepInterval
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .linear)
        let newPos = self.moveNode(suakePart: .straightToStraight)
        _ = self.moveNode(newPos: newPos)
        SCNTransaction.commit()
    }
    
//    func moveNode()->SCNVector3 {
//        if(self.currentSuakePart != .straightToLeft && self.currentSuakePart != .leftToLeft && self.currentSuakePart != .leftToRight && self.currentSuakePart != .straightToRight && self.currentSuakePart != .rightToRight && self.currentSuakePart != .rightToLeft){
//            return self.moveNode(suakePart: .straightToStraight)
//        }else{
//            return self.moveNode(suakePart: self.currentSuakePart)
//        }
//    }
    
    @discardableResult
    func moveNode(newPos:SCNVector3)->Bool{
        self.playerEntity.pos = newPos
        return true
    }
    
    func moveNode(suakePart:SuakePart)->SCNVector3{
        var posRes:SCNVector3 = self.playerEntity.pos
        switch(self.playerEntity.dir){
            case .UP:
                if(suakePart == .leftToStraight){
                    posRes.x -= 1
                }else if(suakePart == .rightToStraight){
                    posRes.x += 1
                }else if(suakePart == .leftToLeft || suakePart == .leftToRight || suakePart == .rightToRight || suakePart == .rightToLeft){
                    
                }else{
                    posRes.z += 1
                }
            case .DOWN:
                if(suakePart == .leftToStraight){
                    posRes.x += 1
                }else if(suakePart == .rightToStraight){
                    posRes.x -= 1
                }else if(suakePart == .leftToLeft || suakePart == .leftToRight || suakePart == .rightToRight || suakePart == .rightToLeft){
                    
                }else{
                    posRes.z -= 1
                }
            case .LEFT:
                if(suakePart == .leftToStraight){
                    posRes.z += 1
                }else if(suakePart == .rightToStraight){
                    posRes.z -= 1
                }else if(suakePart == .leftToLeft || suakePart == .leftToRight || suakePart == .rightToRight || suakePart == .rightToLeft){
                    
                }else{
                    posRes.x += 1
                }
                break
            case .RIGHT:
                if(suakePart == .leftToStraight){
                    posRes.z -= 1
                }else if(suakePart == .rightToStraight){
                    posRes.z += 1
                }else if(suakePart == .leftToLeft || suakePart == .leftToRight || suakePart == .rightToRight || suakePart == .rightToLeft){
                    
                }else{
                    posRes.x -= 1
                }
            case .NONE:
                break
            case .PORTATIOM:
                break
        }
        self.game.showDbgMsg(dbgMsg: "x: \(posRes.x), z: \(posRes.z), dir: \(self.playerEntity.dir.rawValue)", dbgLevel: .Verbose)
        
        return posRes
    }
    
    func playHeadAnimation(){
        (self.node as! SuakeBaseMultiAnimatedSCNNode).animationPlayer(id: 1).play()
    }
    
    func stopHeadAnimation(){
        (self.node as! SuakeBaseMultiAnimatedSCNNode).animationPlayer(id: 1).stop()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
