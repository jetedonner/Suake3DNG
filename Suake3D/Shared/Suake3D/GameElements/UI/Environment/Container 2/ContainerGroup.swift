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
    
    override init(game: GameController) {
        super.init(game: game)
        self.groupNode.name = "ContainerGroup"
        self.initGroupVars(groupName: "ContainerGroup", groupItemCount: DbgVars.initContainerCount)
    }
    
    override func initItems(){
        groupItems = [ContainerGroupItem]()
        for i in (0..<self.groupItemCount){
            let item:ContainerGroupItem = ContainerGroupItem(game: game)
            item.id = i
            self.groupNode.addChildNode(item)
            groupItems.append(item)
        }
    }
}
