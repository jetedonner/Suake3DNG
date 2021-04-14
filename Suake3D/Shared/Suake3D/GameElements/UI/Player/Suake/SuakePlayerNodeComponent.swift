//
//  SuakePlayerComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 12.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class SuakePlayerNodeComponent: SuakeBaseSCNNodeComponent {
    
    override var node:SuakeBaseAnimatedSCNNode{
        get{ return super.node as! SuakeBaseAnimatedSCNNode }
    }
    
    var playerEntity:SuakePlayerEntity{
        get{ return super.entity as! SuakePlayerEntity }
    }
    
    var isHidden:Bool{
        get{
            return self.node.isHidden
        }
        set{
            self.node.isHidden = newValue
        }
    }
    
    var isStopped:Bool{
        get{
            return self.node.isStopped
        }
        set{
            self.node.isStopped = newValue
        }
    }
    
    var _suakePart:SuakePart = .straightToStraight
    var suakePart:SuakePart{
        get{ return self._suakePart }
        set{ self._suakePart = newValue }
    }
    
    init(game: GameController, node: SuakeBaseAnimatedSCNNode, suakePart:SuakePart) {
        super.init(game: game, node: node)
        self.suakePart = suakePart
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        if(self.playerEntity.playerType == .OppSuake){
            self.addPhysics(catBitMask: CollisionCategory.suakeOpp.rawValue)
        }else if(self.playerEntity.playerType == .OwnSuake){
            self.addPhysics(catBitMask: CollisionCategory.suake.rawValue)
        }
    }
    
    func addPhysics(catBitMask:Int){
        addPhysicsBodies2SuakePart(suakePart: self.node, catBitMask: catBitMask)
    }
    
    private func addPhysicsBodies2SuakePart(suakePart:SCNNode, catBitMask:Int){
        addPhysicsBody(node: suakePart.childNode(withName: "joint1", recursively: true)!, catBitMask: catBitMask | CollisionCategory.suakeHead.rawValue)
        addPhysicsBody(node: suakePart.childNode(withName: "joint3", recursively: true)!, catBitMask: catBitMask | CollisionCategory.suakeHead.rawValue)
        addPhysicsBody(node: suakePart.childNode(withName: "joint5", recursively: true)!, catBitMask: catBitMask | CollisionCategory.suakeHead.rawValue)
        addPhysicsBody(node: suakePart.childNode(withName: "joint7", recursively: true)!, catBitMask: catBitMask | CollisionCategory.suakeMid.rawValue)
        addPhysicsBody(node: suakePart.childNode(withName: "joint9", recursively: true)!, catBitMask: catBitMask | CollisionCategory.suakeMid.rawValue)
        addPhysicsBody(node: suakePart.childNode(withName: "joint11", recursively: true)!, catBitMask: catBitMask | CollisionCategory.suakeMid.rawValue)
        addPhysicsBody(node: suakePart.childNode(withName: "joint13", recursively: true)!, catBitMask: catBitMask | CollisionCategory.suakeMid.rawValue)
        addPhysicsBody(node: suakePart.childNode(withName: "joint15", recursively: true)!, catBitMask: catBitMask | CollisionCategory.suakeMid.rawValue)
        addPhysicsBody(node: suakePart.childNode(withName: "joint17", recursively: true)!, catBitMask: catBitMask | CollisionCategory.suakeMid.rawValue)
        addPhysicsBody(node: suakePart.childNode(withName: "joint19", recursively: true)!, catBitMask: catBitMask | CollisionCategory.suakeTail.rawValue)
        addPhysicsBody(node: suakePart.childNode(withName: "joint21", recursively: true)!, catBitMask: catBitMask | CollisionCategory.suakeTail.rawValue)
        addPhysicsBody(node: suakePart.childNode(withName: "joint23", recursively: true)!, catBitMask: catBitMask | CollisionCategory.suakeTail.rawValue)
        addPhysicsBody(node: suakePart.childNode(withName: "joint2", recursively: true)!, catBitMask: catBitMask | CollisionCategory.suakeTail.rawValue)
    }
    
    private func addPhysicsBody(node:SCNNode, catBitMask:Int){
        let geo:SCNGeometry = SCNSphere(radius: 1.5)
        let shape = SCNPhysicsShape(geometry: geo, options: [SCNPhysicsShape.Option.scale: SCNVector3(10, 10, 10)])
        node.physicsBody = SCNPhysicsBody(type: .kinematic, shape: shape)
        
        node.physicsBody?.categoryBitMask = catBitMask
        node.physicsBody?.contactTestBitMask = catBitMask | CollisionCategory.laserbeam.rawValue | CollisionCategory.mgbullet.rawValue | CollisionCategory.pellet.rawValue
        node.physicsBody?.collisionBitMask = 0
    }
    
    func createBB() {
//        let hitTestBox:SCNBox = SCNBox(width: 2, height: 2, length: 10, chamferRadius: 0)
//
//        hitTestBox.materials.first?.diffuse.contents = NSColor.red
//        let boxNode = SCNNode(geometry: hitTestBox)
//        boxNode.opacity = 1.0
//        boxNode.position.y += 1.0
//
//        if(self.playerEntity.playerType == .OwnSuake){
//            boxNode.name = "Own suake hitTestBox"
//            boxNode.categoryBitMask = CollisionCategory.suake.rawValue
//            self.node.cloneNode.categoryBitMask = CollisionCategory.suake.rawValue
//        }else if(self.playerEntity.playerType == .OppSuake){
//            boxNode.name = "Opp suake hitTestBox"
//            boxNode.categoryBitMask = CollisionCategory.suakeOpp.rawValue
//            let shp:SCNPhysicsShape = SCNPhysicsShape(geometry: hitTestBox, options: nil)
//            boxNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: shp)
//            boxNode.physicsBody?.categoryBitMask = CollisionCategory.suakeOpp.rawValue
//            boxNode.physicsBody?.contactTestBitMask = CollisionCategory.suakeOpp.rawValue | CollisionCategory.mgbullet.rawValue
//            self.node.cloneNode.categoryBitMask = CollisionCategory.suakeOpp.rawValue
//        }
//        self.node.cloneNode.addChildNode(boxNode)
    }
    
    func movePlayerNodeComponent(newTurnDir:TurnDir, newDir:SuakeDir? = nil, deltaTime seconds: TimeInterval){
        if(newDir != nil){
            self.playerEntity.dirOld = self.playerEntity.dir
            self.playerEntity.dir = newDir!
        }
        if(self.suakePart == .leftToStraight || self.suakePart == .rightToStraight){
            
            SuakeDirTurnDirHelper.initNodeRotation(node: self.playerEntity.playerComponent.mainNode, dir: self.playerEntity.dir)
        }
        
        self.node.animation?.stop()
        
        if(seconds < 1.0){
            self.node.animation?.animation.timeOffset = seconds
        }
        
        self.node.animation?.play()
        
        let animDuration:TimeInterval = (seconds < 1.0 ? SuakeVars.gameStepInterval - seconds : SuakeVars.gameStepInterval)
        
        self.playerEntity.cameraComponent.moveFollowCamera(turnDir: newTurnDir, duration: animDuration)
        
        self.playerEntity.cameraComponent.moveRotateFPCamera(duration: animDuration, turnDir: newTurnDir)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
