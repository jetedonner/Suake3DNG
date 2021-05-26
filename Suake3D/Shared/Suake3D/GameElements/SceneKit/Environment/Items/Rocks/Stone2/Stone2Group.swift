//
//  DesertPlantGroup.swift
//  Suake3D
//
//  Created by dave on 23.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class Stone2Group:SuakeNodeGroupBase{
    
    var stone2Count:Int = 1
    
    init(game: GameController, stone2Count:Int) {
        super.init(game: game, locationType: .Stone2)
        self.stone2Count = stone2Count
        self.groupName = "Stone2Count"
        self.initGroup()
    }
    
    func initGroup(){
        groupItems = [Stone2GroupItem]()
        for i in (0..<self.stone2Count){
            groupItems.append(Stone2GroupItem(game: self.game, id: i))
        }
    }
}
