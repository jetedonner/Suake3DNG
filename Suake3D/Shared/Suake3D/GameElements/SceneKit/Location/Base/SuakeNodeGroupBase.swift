//
//  SuakeNodeGroupBase.swift
//  Suake3D
//
//  Created by Kim David Hauser on 31.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class SuakeNodeGroupBase: SuakeGameClass {
    
    let locationType:LocationType
    var groupName:String = "SuakeNodeGroupBase"
    var groupItems:[SuakeNodeGroupItemBase] = [SuakeNodeGroupItemBase]()
    
    init(game: GameController, locationType:LocationType) {
        self.locationType = locationType
        super.init(game: game)
    }
}
