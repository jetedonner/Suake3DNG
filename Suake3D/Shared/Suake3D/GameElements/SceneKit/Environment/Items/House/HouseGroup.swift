//
//  DesertPlantGroup.swift
//  Suake3D
//
//  Created by dave on 23.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class HouseGroup:SuakeNodeGroupBase{
    
    var houseCount:Int = 1
    
    init(game: GameController, houseCount:Int) {
        super.init(game: game, locationType: .House)
        self.houseCount = houseCount
        self.groupName = "HouseGroup"
        self.initGroup()
    }
    
    func initGroup(){
        groupItems = [HouseGroupItem]()
        for i in (0..<self.houseCount){
            let item:HouseGroupItem = HouseGroupItem(game: game)
            item.id = i
            groupItems.append(item)
        }
    }
}
