//
//  SuakeBaseComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 12.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeBaseComponent: GKComponent {
    
    let game:GameController
    
    init(game:GameController) {
        self.game = game
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
