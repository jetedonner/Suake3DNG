//
//  SuakeNodeGroupItemBase.swift
//  Suake3D
//
//  Created by Kim David Hauser on 31.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class SuakeNodeGroupItemBase: SuakeBaseNodeEntity {
    
    override init(game: GameController, id:Int = 0) {
        super.init(game: game, id: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
