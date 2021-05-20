//
//  BasePlantNode.swift
//  Suake3D
//
//  Created by dave on 23.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class MossRockGroupItem:SuakeNodeGroupItemBase {
    
    let mossRockComponent:MossRockComponent
    
    override init(game:GameController, id:Int = 0) {
        self.mossRockComponent = MossRockComponent(game: game, id: id)
        
        super.init(game: game, id: id)
        
        self.addComponent(self.mossRockComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
