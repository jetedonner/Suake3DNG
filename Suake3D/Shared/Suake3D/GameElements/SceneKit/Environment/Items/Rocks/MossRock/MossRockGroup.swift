//
//  DesertPlantGroup.swift
//  Suake3D
//
//  Created by dave on 23.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class MossRockGroup:SuakeNodeGroupBase{
    
    var mossRockCount:Int = 1
    
    init(game: GameController, mossRockCount:Int) {
        super.init(game: game, locationType: .MossRock)
        self.mossRockCount = mossRockCount
        self.groupName = "MossRockGroup"
        self.initGroup()
    }
    
    func initGroup(){
        groupItems = [MossRockGroupItem]()
        for i in (0..<self.mossRockCount){
//            let item:MossRockGroupItem = MossRockGroupItem(game: game, id: i)
////            item.id = i
//            groupItems.append(item)
            groupItems.append(MossRockGroupItem(game: game, id: i))
        }
    }
}
