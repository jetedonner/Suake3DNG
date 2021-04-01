//
//  MachineGunComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 27.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class LasergunComponent: BaseWeaponComponent {
    
    init(game:GameController, weaponArsenalManager:WeaponArsenalManager) {
        super.init(game: game, weaponType: .laser, weaponArsenalManager: weaponArsenalManager)
//        self.cadence = 0.25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
