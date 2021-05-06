//
//  BasePlantNode.swift
//  Suake3D
//
//  Created by dave on 23.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class ContainerGroupItem:SuakeNodeGroupItemBase {
    
    let containerComponent:ContainerComponent
    
    override init(game:GameController, id:Int = 0) {
        self.containerComponent = ContainerComponent(game: game, id: id)
        
        super.init(game: game, id: id)
        
        self.addComponent(self.containerComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
