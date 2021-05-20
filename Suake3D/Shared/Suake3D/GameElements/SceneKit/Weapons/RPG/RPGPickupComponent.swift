//
//  MachinegunPickupComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 26.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class RPGPickupComponent: BaseWeaponPickupComponent {
    
    init(game: GameController, id: Int = 0) {
        super.init(game: game, sceneName: "art.scnassets/nodes/weapons/rpg/rocketlauncher.scn", rescale: 30.0, id: id)
        self.node.name = "RPG pickup: " + id.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
