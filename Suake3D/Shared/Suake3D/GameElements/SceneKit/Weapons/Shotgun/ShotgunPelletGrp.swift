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

class ShotgunPelletGrp: BulletBase {
    
    let numberOfPellets:Int = 5
    let pelletDistance:CGFloat = 1.75
    var pellets:[ShotgunPellet] = [ShotgunPellet]()
    var allPelletsHit:Bool = false
    var allPelletsHBeamed:Bool = false
    
//    override init() {
//        super.init()
//        self.name = "ShotgunPelletGroup"
//
//        self.shootingVelocity = 485.0
//    }
//
//    func setAfterInit(game: GameController, weapon:ShotgunComponent) {
//        self.game = game
//        self.weapon = weapon
////        self.setupPhysics()
//    }
    
    init(game: GameController, weapon:ShotgunComponent) {
        super.init(game: game, weapon: weapon)
//        super.init(game: game, weapon: weapon, nodeName: "Shotgun pellet group")
        self.name = "ShotgunPelletGroup"
        self.shootingVelocity = 485.0
        
        self.createPellets()
        
        let posNG:SCNVector3 = SCNVector3(0, 0, 0)
        let shotParticleSystem = SCNParticleSystem(named: "ShotgunBurst", inDirectory: SuakeVars.DIR_PARTICLES)
//        shotParticleSystem?.isLightingEnabled = true
        let shotParticleNode = SCNNode()
        shotParticleNode.addParticleSystem(shotParticleSystem!)
        shotParticleNode.position = (posNG)
        self.addChildNode(shotParticleNode)
        self.position.y += 2.0
    }
    
    @discardableResult
    func checkAllPelletsHit()->Bool{
        self.allPelletsHit = true
        for pellet in self.pellets{
            if(!pellet.isTargetHit){
                self.allPelletsHit = false
                break
            }
        }
        
        if(self.allPelletsHit){
            self.game.physicsHelper.qeueNode2Remove(node: self)
            self.game.showDbgMsg(dbgMsg: "All pellets hit the target", dbgLevel: .Verbose)
        }else{
            self.game.showDbgMsg(dbgMsg: "NOT all pellets hit the target", dbgLevel: .Verbose)
        }
        
        return self.allPelletsHit
    }
    
//    @discardableResult
//    func checkAllPelletsBeamed()->Bool{
//        self.allPelletsHBeamed = true
//        for pellet in self.pellets{
//            if(!pellet.isBeaming){
//                self.allPelletsHBeamed = false
//                break
//            }
//        }
//        
//        if(self.allPelletsHBeamed){
//            self.game.physicsHelper.qeueNode2Remove(node: self)
//            self.game.showDbgMsg(dbgMsg: "All pellets were beamed", dbgLevel: .Verbose)
//        }else{
//            self.game.showDbgMsg(dbgMsg: "NOT all pellets were beamed", dbgLevel: .Verbose)
//        }
//        return self.allPelletsHBeamed
//    }
//    
    func createPellets(){
        self.pellets.removeAll()
        for i in (0..<self.numberOfPellets){
            let pellet:ShotgunPellet = ShotgunPellet(pelletGrp: self, weapon: self.weapon as! ShotgunComponent, id: i)
            self.pellets.append(pellet)
            self.addChildNode(pellet)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
