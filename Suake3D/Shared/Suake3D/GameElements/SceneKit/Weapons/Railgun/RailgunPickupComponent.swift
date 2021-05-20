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

class RailgunPickupComponent: BaseWeaponPickupComponent {
    
    init(game: GameController, id: Int = 0) {
        super.init(game: game, sceneName: "art.scnassets/nodes/weapons/railgun/Railgun.scn", rescale: 0.02, id: id)
        self.node.name = "Railgun pickup: " + id.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
