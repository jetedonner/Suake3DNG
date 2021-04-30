//
//  MedKitEntityGroup.swift
//  Suake3D
//
//  Created by Kim David Hauser on 31.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class PortalEntityPair: SuakeNodeGroupBase {
    
//    var medKitCount:Int = 13
//    var itemEntityManager:ItemEntityManager!
    var portalEntityA:PortalEntity!
    var portalEntityB:PortalEntity!
    
    init(game: GameController, id:Int = 0) {
        super.init(game: game, locationType: .Portal)
        self.portalEntityA = PortalEntity(game: self.game, pairEntity: self, id: id, portalType: .Portal_A)
        self.portalEntityB = PortalEntity(game: self.game, pairEntity: self, id: id, portalType: .Portal_B)
        self.portalEntityA.otherPortal = self.portalEntityB
        self.portalEntityB.otherPortal = self.portalEntityA
//        self.groupName = "MedKitGroup"
//        self.groupItems = [MedKitEntity]()
////        self.itemEntityManager = ItemEntityManager(game: self.game)
//        self.initGroup()
    }
    
    func initSetupPos(addToScene:Bool = true){
//        for portal in portals{
//            portal.initSetupPos()
//        }
        self.portalEntityA.portalComponent.initSetupPos()
        self.portalEntityB.portalComponent.initSetupPos()
    }
   
    func addToScene() {
//        for portal in portals{
//           portal.addToScene()
//        }
        self.portalEntityA.portalComponent.addToScene()
        self.portalEntityB.portalComponent.addToScene()
    }
}
