//
//  BasePlantNode.swift
//  Suake3D
//
//  Created by dave on 23.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class TreeGroupItem:SuakeNodeGroupItemBase {
    
    let treeComponent:TreeComponent
    
    override init(game:GameController, id:Int = 0) {
        self.treeComponent = TreeComponent(game: game, id: id)
        
        super.init(game: game, id: id)
        
        self.addComponent(self.treeComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
