//
//  SuakeBaseLocationComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 23.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeBaseLocationComponent: SuakeBaseSCNNodeComponent {
    
    let locationType:LocationType
    
    init(game: GameController, node: SuakeBaseSCNNode, locationType:LocationType, id:Int = 0) {
        self.locationType = locationType
        super.init(game: game, node: node, id: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
