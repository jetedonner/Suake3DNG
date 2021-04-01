//
//  MachinegunPickupEntity.swift
//  Suake3D
//
//  Created by Kim David Hauser on 26.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class MachinegunPickupEntity: BaseWeaponPickupEntity {
    
    init(game: GameController, id: Int = 0) {
        super.init(game: game, weaponType: .mg, weaponPickupComponent: MachinegunPickupComponent(game: game, id: id), id: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
