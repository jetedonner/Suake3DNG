//
//  BasePlantNode.swift
//  Suake3D
//
//  Created by dave on 23.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class GeneratorGroupItem:SuakeNodeGroupItemBase {
    
    let generatorComponent:GeneratorComponent
    
    override init(game:GameController, id:Int = 0) {
        self.generatorComponent = GeneratorComponent(game: game, id: id)
        
        super.init(game: game, id: id)
        
        self.addComponent(self.generatorComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
