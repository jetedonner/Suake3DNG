//
//  DroidExplodingComponent.swift
//  Suake3D
//
//  Created by dave on 08.04.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class DroidExplodingComponent:PlayerExplodingComponent{
    
    override init(game:GameController) {
        super.init(game: game)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
