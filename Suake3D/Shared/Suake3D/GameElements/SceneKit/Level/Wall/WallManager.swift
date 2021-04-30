//
//  WallManager.swift
//  Suake3D
//
//  Created by Kim David Hauser on 09.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class WallManager: SuakeGameClass {
    
    let wallFactory:WallFactory!
    
    override init(game: GameController) {
        self.wallFactory = WallFactory(game: game)
        super.init(game: game)
    }
    
    func loadWall(initialLoad:Bool = true) {
        self.wallFactory.loadWall(initialLoad: initialLoad)
    }
}
