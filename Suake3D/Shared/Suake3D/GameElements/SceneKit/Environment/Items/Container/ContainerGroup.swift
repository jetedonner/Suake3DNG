//
//  DesertPlantGroup.swift
//  Suake3D
//
//  Created by dave on 23.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class ContainerGroup:SuakeNodeGroupBase{
    
    var containerCount:Int = 1
    
    init(game: GameController, containerCount:Int) {
        super.init(game: game, locationType: .Container)
        self.containerCount = containerCount
        self.groupName = "ContainerGroup"
        self.initGroup()
    }
    
    func initGroup(){
        groupItems = [ContainerGroupItem]()
        for i in (0..<self.containerCount){
            let item:ContainerGroupItem = ContainerGroupItem(game: game)
            item.id = i
            groupItems.append(item)
        }
    }
}
