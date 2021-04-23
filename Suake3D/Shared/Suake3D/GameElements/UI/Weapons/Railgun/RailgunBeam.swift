//
//  MachinegunBullet.swift
//  Suake3D
//
//  Created by Kim David Hauser on 28.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class RailgunBeam: BulletBase {
    
    var railBeamNode:SCNNode!
    let shotY:CGFloat = 14.0
    var anim:CAAnimationGroup!
    var fadeAnim:CABasicAnimation!
    let shootingDist:CGFloat = 25.0
    var backShot:Bool = false
    var nameAddition:String = ""
    let oldColor = NSColor.red
    let newColor = NSColor.cyan.withAlphaComponent(0.23)
    let duration: TimeInterval = 0.75
        
    var beamLen:CGFloat = 3000
    
    init(game: GameController, weapon:RailgunComponent) {
        super.init(game: game, weapon: weapon)
        self.name = "RailgunBeam"
        self.damage = SuakeVars.RAILGUN_DAMAGE
    }
    
    override func hitTarget(targetCat:CollisionCategory, targetNode:SCNNode, contactPoint:SCNVector3? = nil)->Bool{
        if(!self.isTargetHit){
            var bRet:Bool = false
            if(targetCat != CollisionCategory.wall){
                self.isTargetHit = true
                bRet = true
            }
            let explosionCompoenent:RailgunExplodingComponent = RailgunExplodingComponent(game: self.game)
            explosionCompoenent.explode(position: targetNode.position)
            return bRet
        }
        return false
    }
    
//    override func addSingleBullet(pos:SCNVector3, vect:SCNVector3, origBullet:BulletBase, addBullets:Bool = true)->BulletBase{
////        let newBulletNG:BulletBase = origBullet.getNewBullet()
////        newBulletNG.position = pos
////        newBulletNG.position.x -= 0.5
////        newBulletNG.position.z += 1.0
////        newBulletNG.position.y = 14
////        newBulletNG.isBeaming = true
////        newBulletNG.rotation = origBullet.rotation
//////        if(!(origBullet is RailgunBeam)){
//////            newBulletNG.physicsBody!.velocity = vect
//////        }
////        if(addBullets){
////            self.game.physicsHelper.qeueNode2Add2Scene(node: newBulletNG)
////        }
////        return newBulletNG
//
//        let newBulletNG:RailgunBeam = (origBullet as! RailgunBeam).getNewBullet()
//        let startZ:CGFloat = pos.z
//        let startX:CGFloat = pos.x
//        let startY:CGFloat = shotY
//        newBulletNG.addRailgunShot(beamPos: SCNVector3(startX, startY, startZ), isBeamed: true)
//        //newBulletNG.rotation = origBullet.rotation
//        newBulletNG.eulerAngles = origBullet.eulerAngles
//        newBulletNG.runAction(SCNAction.fadeOut(duration: 0.35), completionHandler: {
//            newBulletNG.game.physicsHelper.qeueNode2Remove(node: newBulletNG)
//        })
//        return newBulletNG
//    }
    
    override func getNewBullet()->RailgunBeam{
        return RailgunBeam(game: self.game, weapon: self.weapon as! RailgunComponent)
    }
    
    public func addRailgunShot(){
        let startZ:CGFloat = (self.weapon.weaponArsenalManager.playerEntity.playerType == .OwnSuake ? self.game.cameraHelper.cameraNodeFP.position.z : self.game.cameraHelper.cameraNodeFPOpp.position.z)
        let startX:CGFloat = (self.weapon.weaponArsenalManager.playerEntity.playerType == .OwnSuake ? self.game.cameraHelper.cameraNodeFP.position.x : self.game.cameraHelper.cameraNodeFPOpp.position.x)
        let startY:CGFloat = shotY
        self.addRailgunShot(beamPos: SCNVector3(startX, startY, startZ))
        self.runAction(SCNAction.fadeOut(duration: 0.35), completionHandler: {
            self.game.physicsHelper.qeueNode2Remove(node: self)
        })
    }
    
    public func addRailgunShot(beamPos:SCNVector3, isBeamed:Bool = false){
//        self.isBeamed = isBeamed
        beamLen = SuakeVars.fieldSize * self.game.levelManager.currentLevel.levelConfigEnv.levelSize.getNSSize().width
        let c = beamLen
        var degrees:Double = self.game.panCameraHelper.cameraNodeFPDegrees
        
        if(!self.game.cameraHelper.fpv){
            if(self.weapon.weaponArsenalManager.playerEntity.playerType == .OwnSuake){
                if(self.game.playerEntityManager.ownPlayerEntity.dir == .UP){
                    degrees = 0.0 //180.0
                }else if(self.game.playerEntityManager.ownPlayerEntity.dir == .DOWN){
                    degrees = 180.0 //0.0
                }else if(self.game.playerEntityManager.ownPlayerEntity.dir == .RIGHT){
                    degrees = 90.0 //270.0
                }else if(self.game.playerEntityManager.ownPlayerEntity.dir == .LEFT){
                    degrees = 270.0 //90.0
                }
            }else{
                if(self.game.playerEntityManager.oppPlayerEntity.dir == .UP){
                    degrees = 0.0 //180.0
                }else if(self.game.playerEntityManager.oppPlayerEntity.dir == .DOWN){
                    degrees = 180.0 //0.0
                }else if(self.game.playerEntityManager.oppPlayerEntity.dir == .RIGHT){
                    degrees = 90.0 //270.0
                }else if(self.game.playerEntityManager.oppPlayerEntity.dir == .LEFT){
                    degrees = 270.0 //90.0
                }
            }
        }else{
            let degreesNG = (self.weapon.weaponArsenalManager.playerEntity.playerType == .OwnSuake ? self.game.cameraHelper.cameraNodeFP.eulerAngles.y : self.game.cameraHelper.cameraNodeFPOpp.eulerAngles.y) * CGFloat(180 / Double.pi)
            
            
//            if(degreesNG == -0 && (self.game.scnView.pointOfView!.eulerAngles.x > 0)){
//                degreesNG += 180.0
//            }
//                    degrees -= 180
            var deg:Double = Double(degreesNG)
            
//            deg -= 180.0
            deg = deg.truncatingRemainder(dividingBy: 360)
//            if(deg <= 0.0){
//                deg += 360.0
//            }
//            if(deg >= -1 && deg <= 0){
//                deg = 0.0
//            }
//            if(self.game.stateMachine.currentState is SuakeStateReadyToPlay){
//                deg += 180.0
//            }
            
            degrees = deg
        }
        let degrees2:Double = self.game.panCameraHelper.cameraNodeFPDegrees
        self.game.showDbgMsg(dbgMsg: "RAILGUN SHOT: degrees: " + degrees.description + ", FPRotation degrees: " + degrees2.description, dbgLevel: .Info)
        
        // Adjusr degrees from panCameraHelper
        degrees += 90.0
        if(degrees >= 270.0){
            degrees -= 360.0
        }
        
        let a = c * CGFloat(degrees.sin()) // self.sin(degrees: degrees))
        let tmp:Double = Double((a * a * -1) + (c * c))
        var b = tmp.squareRoot()

        if(degrees > 90.0){
            b *= -1
        }
        
        if(self.weapon.weaponArsenalManager.playerEntity.playerType == .OwnSuake){
            self.railBeamNode = self.line2(from: beamPos, to: SCNVector3(beamPos.x + CGFloat(b), beamPos.y, beamPos.z  + CGFloat(a)), width: 5, beamLen: beamLen, color: .cyan)!
        }else{
            self.railBeamNode = self.line2(from: beamPos, to: SCNVector3(self.game.playerEntityManager.goodyEntity.position.x, beamPos.y, self.game.playerEntityManager.goodyEntity.position.z), width: 5, beamLen: beamLen, color: .cyan)!
        }
        self.railBeamNode.opacity = 1.0

        self.setupPhysics(geometry: railBeamNode.geometry!, type: .kinematic, categoryBitMask: CollisionCategory.railbeam, catBitMasks: [CollisionCategory.suakeOpp, CollisionCategory.droid, CollisionCategory.goody, CollisionCategory.medKit, CollisionCategory.wall])

        self.updHelix()
        self.addChildNode(self.railBeamNode)
//        self.position.z += beamPos.z
//        self.position.x += beamPos.x
//        self.position.y += 2.0
//                DispatchQueue.main.async {
//                    Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { _ in
//            }else{
//                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { _ in
//                    self.fadeAnim = CABasicAnimation()
//                    self.fadeAnim.keyPath = "opacity"
//                    self.fadeAnim.fromValue = 1.0
//                    self.fadeAnim.toValue = 0.0
//                    self.fadeAnim.duration = 0.5
//                    self.fadeAnim.fillMode = CAMediaTimingFillMode.forwards
//                    self.fadeAnim.isRemovedOnCompletion = false
//                    //self.fadeAnim.delegate = self
//                    self.fadeAnim.setValue(self.twoPointsNode2, forKey: "beam")
//                    self.fadeAnim.setValue(self.helix, forKey: "helix")
//                    self.fadeAnim.run(forKey: "opacity", object: self.twoPointsNode2!, arguments: nil)
//                    self.fadeAnim.run(forKey: "opacity", object: self.helix!, arguments: nil)
//                }
//            }
//        }
    }
    
    func line2(from:SCNVector3, to:SCNVector3, width:Int, beamLen:CGFloat, color:NSColor) -> SCNNode? {
        
        let cylinder = SCNCylinder(radius: 1, height: CGFloat(beamLen))
        cylinder.radialSegmentCount = width
        cylinder.firstMaterial?.diffuse.contents = NSImage.Name.greenPlasma2
        cylinder.firstMaterial?.lightingModel = .constant
        
        let node = SCNNode(geometry: cylinder)
        var middle:SCNVector3 = (to + from)
        middle.x /= 2
        middle.y /= 2
        middle.z /= 2
        self.position = middle
        
        self.eulerAngles = SCNVector3Make(CGFloat(Float(Double.pi/2)), acos((to.z-from.z)/beamLen), atan2((to.y-from.y), (to.x-from.x)))
        self.position.y = 14.0
        return node
    }
    
    // Swift 3:
//    func sin(degrees: Double) -> Double {
//        return __sinpi(degrees/180.0)
//    }
    
    var helix:SCNNode!
    var hHeight:Float = 60.0
    
    func updHelix(){
        let helixHelper:HelixVertexArray = HelixVertexArray(width: 6.0, height: hHeight, depth: 3.2, pitch: 1.95, quality: false)
        helix = helixHelper.getNode()
        helix.position = SCNVector3(0.0, (beamLen / -2) + ((helix.boundingBox.max.y - helix.boundingBox.min.y) / 2), 0)
        
        let act0 = SCNAction.customAction(duration: duration, action: { (node, elapsedTime) in
            let percentage = elapsedTime / CGFloat(self.duration)
            node.geometry?.firstMaterial?.diffuse.contents = AnimationHelper.aniColor(from: self.oldColor, to: self.newColor, percentage: percentage)
            node.geometry?.firstMaterial?.lightingModel = .constant
        })
        helix.runAction(SCNAction.group([SCNAction.rotateBy(x: 0, y: CGFloat(Double.pi) * 2, z: 0, duration: duration), act0]))
        self.addChildNode(helix)
    }
    
//    func addBloom() -> [CIFilter]? {
//        let bloomFilter = CIFilter(name:"CIBloom")!
//        bloomFilter.setValue(10.0, forKey: "inputIntensity")
//        bloomFilter.setValue(9.0, forKey: "inputRadius")
//
//        return [bloomFilter]
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
