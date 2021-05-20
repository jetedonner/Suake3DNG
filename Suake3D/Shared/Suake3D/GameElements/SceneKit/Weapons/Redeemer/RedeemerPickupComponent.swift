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

class RedeemerPickupComponent: BaseWeaponPickupComponent {
    
    init(game: GameController, id: Int = 0) {
        super.init(game: game, sceneName: "art.scnassets/nodes/weapons/redeemer/missile.scn", rescale: 7.0, id: id)
        self.node.name = "Redeemer pickup: " + id.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
