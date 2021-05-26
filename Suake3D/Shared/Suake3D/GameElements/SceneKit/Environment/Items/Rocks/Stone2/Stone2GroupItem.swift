//
//  BasePlantNode.swift
//  Suake3D
//
//  Created by dave on 23.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class Stone2GroupItem:SuakeNodeGroupItemBase {
    
    let stone2Component:Stone2Component
    
    override init(game:GameController, id:Int = 0) {
        self.stone2Component = Stone2Component(game: game, id: id)
        
        super.init(game: game, id: id)
        
        self.addComponent(self.stone2Component)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
