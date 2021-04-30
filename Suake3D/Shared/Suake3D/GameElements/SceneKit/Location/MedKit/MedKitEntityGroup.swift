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

class MedKitEntityGroup: SuakeNodeGroupBase {
    
    let medKitCount:Int
    var medKitPos:[SCNVector3]!
//    var itemEntityManager:ItemEntityManager!
    
    init(game: GameController, itemCount:Int = 3, medKitPos:[SCNVector3]? = nil) {
        self.medKitCount = itemCount
        self.medKitPos = medKitPos
        super.init(game: game, locationType: .MedKit)
        self.groupName = "MedKitGroup"
        self.groupItems = [MedKitEntity]()
//        self.itemEntityManager = ItemEntityManager(game: self.game)
        self.initGroup()
    }
    
    func initGroup(){
//        self.itemEntityManager.addMedKitEntities(numberOfMedKits: self.medKitCount)
        for i in 0..<medKitCount{
            self.groupItems.append(MedKitEntity(game: self.game, id: i))
            if(self.medKitPos != nil){
                self.groupItems[i].pos = self.medKitPos[i]
            }
        }
        //self.groupItems.append(self.itemEntityManager.getItemEntity(itemType: .MedKit, id: 0)!)
    }
}
