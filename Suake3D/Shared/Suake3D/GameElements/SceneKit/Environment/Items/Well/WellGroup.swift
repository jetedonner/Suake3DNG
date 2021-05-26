//
//  DesertPlantGroup.swift
//  Suake3D
//
//  Created by dave on 23.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class WellGroup:SuakeNodeGroupBase{
    
    var wellCount:Int = 1
    
    init(game: GameController, wellCount:Int) {
        super.init(game: game, locationType: .Well)
        self.wellCount = wellCount
        self.groupName = "WellGroup"
        self.initGroup()
    }
    
    func initGroup(){
        groupItems = [WellGroupItem]()
        for i in (0..<self.wellCount){
            let item:WellGroupItem = WellGroupItem(game: game)
            item.id = i
            groupItems.append(item)
        }
    }
}
