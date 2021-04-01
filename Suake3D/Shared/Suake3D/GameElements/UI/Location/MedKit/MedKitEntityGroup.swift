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
    
    var medKitCount:Int = 5
//    var itemEntityManager:ItemEntityManager!
    
    init(game: GameController) {
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
        }
        //self.groupItems.append(self.itemEntityManager.getItemEntity(itemType: .MedKit, id: 0)!)
    }
}
