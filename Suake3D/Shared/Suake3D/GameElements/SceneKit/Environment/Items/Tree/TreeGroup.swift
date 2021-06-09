//
//  DesertPlantGroup.swift
//  Suake3D
//
//  Created by dave on 23.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class TreeGroup:SuakeNodeGroupBase{
    
    var treeCount:Int = 1
    
    init(game: GameController, treeCount:Int) {
        super.init(game: game, locationType: .Tree)
        self.treeCount = treeCount
        self.groupName = "TreeGroup"
        self.initGroup()
    }
    
    func initGroup(){
        groupItems = [TreeGroupItem]()
        for i in (0..<self.treeCount){
            let item:TreeGroupItem = TreeGroupItem(game: game)
            item.id = i
            groupItems.append(item)
        }
    }
}
