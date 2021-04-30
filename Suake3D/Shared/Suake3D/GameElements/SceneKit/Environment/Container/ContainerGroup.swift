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
//        self.initGroupVars(groupName: "ContainerGroup", groupItemCount: DbgVars.initContainerCount)
        self.initGroup()
    }
    
    /*override */func initGroup(){
        groupItems = [ContainerGroupItem]()
        for i in (0..<self.containerCount){
            let item:ContainerGroupItem = ContainerGroupItem(game: game)
            item.id = i
//            self.groupNode.addChildNode(item)
            groupItems.append(item)
        }
    }
}
