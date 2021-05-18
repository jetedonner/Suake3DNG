//
//  DesertPlantGroup.swift
//  Suake3D
//
//  Created by dave on 23.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class GeneratorGroup:SuakeNodeGroupBase{
    
    var generatorCount:Int = 1
    
    init(game: GameController, generatorCount:Int) {
        super.init(game: game, locationType: .Generator)
        self.generatorCount = generatorCount
        self.groupName = "GeneratorCount"
        self.initGroup()
    }
    
    func initGroup(){
        groupItems = [GeneratorGroupItem]()
        for i in (0..<self.generatorCount){
            let item:GeneratorGroupItem = GeneratorGroupItem(game: game)
            item.id = i
            groupItems.append(item)
        }
    }
}
