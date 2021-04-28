//
//  ShotGunPellet.swift
//  Suake3D
//
//  Created by Kim David Hauser on 03.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class ShotgunPellet: BulletBase {
    
    let sphere = SCNSphere(radius: 0.35)
    var pelletGrp:ShotgunPelletGrp!
    var id:Int = -1
    
//    override init() {
//        super.init()
//    }
    
    init(pelletGrp:ShotgunPelletGrp, weapon:ShotgunComponent, id:Int = 0) {
        self.pelletGrp = pelletGrp
        self.id = id
        super.init(game: pelletGrp.game, weapon: weapon, nodeName: "Shotgun pellet no: " + self.id.description)
        self.damage = SuakeVars.SHOTGUN_PELLET_DAMAGE
        
        self.loadPellet()
        if(self.id == 1){
            self.position.x += self.pelletGrp.pelletDistance
        }else if(self.id == 2){
            self.position.x -= self.pelletGrp.pelletDistance
        }else if(self.id == 3){
            self.position.y += self.pelletGrp.pelletDistance
        }else if(self.id == 4){
            self.position.y -= self.pelletGrp.pelletDistance
        }
     
        self.pelletGrp.addChildNode(self)
    }
    
    func setupPhysics4Pellet(){
        self.geometry = sphere
        self.setupPhysics(geometry: sphere, type: .dynamic, categoryBitMask: CollisionCategory.pellet, catBitMasks: [CollisionCategory.suakeOpp, CollisionCategory.goody, CollisionCategory.droid, CollisionCategory.medKit, CollisionCategory.wall, CollisionCategory.floor])
    }
    
    
    
    func loadPellet(){
        self.setupPhysics4Pellet()
        
        let material = SCNMaterial()
        material.diffuse.contents = NSImage.Name.lava
        sphere.firstMaterial = material
        sphere.firstMaterial?.lightingModel = .constant
        self.geometry?.materials  = [material]
//        self.filters = BloomHelper.addBloom(inputIntensity: 5.0, inputRadius: 3.0)
    }
    
    override func hitTarget(targetCat:CollisionCategory, targetNode:SCNNode, contactPoint:SCNVector3? = nil)->Bool{
        if(!self.isTargetHit){
            if(!self.pelletGrp.isTargetHit){
                self.pelletGrp.isTargetHit = true
            }

            let isHit:Bool = super.hitTarget(targetCat: targetCat, targetNode: targetNode, contactPoint: contactPoint)
            
            
            if(isHit){
                let explosionCompoenent:BulletImpactExplodingComponent = BulletImpactExplodingComponent(game: self.game)
                explosionCompoenent.explode(position: contactPoint!)
            }

            _ = self.pelletGrp.checkAllPelletsHit()

            return isHit
        }
        return false
    }
    
//    override func getNewBullet()->ShotgunPellet{
//        return ShotgunPellet(pelletGrp: self.pelletGrp, weapon: self.weapon as! ShotgunComponent)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
